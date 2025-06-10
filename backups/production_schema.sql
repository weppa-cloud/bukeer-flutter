--
-- PostgreSQL database dump
--

-- Dumped from database version 15.6
-- Dumped by pg_dump version 16.9 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: itinerary_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.itinerary_status AS ENUM (
    'planned',
    'in_progress',
    'completed',
    'cancelled'
);


--
-- Name: calculate_total_cost(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.calculate_total_cost() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.product_type <> 'Hoteles' THEN
        NEW.total_cost := NEW.unit_cost * NEW.quantity;
    ELSE
        NEW.total_cost := NEW.unit_cost * NEW.quantity * NEW.hotel_nights;
    END IF;
    RETURN NEW;
END;
$$;


--
-- Name: calculated_total_markup(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.calculated_total_markup() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    new_total_amount numeric;
    rate numeric;
BEGIN
    -- Calcular el nuevo total_amount
    new_total_amount := COALESCE(NEW.total_hotels, 0) + 
                        COALESCE(NEW.total_flights, 0) + 
                        COALESCE(NEW.total_activities, 0) + 
                        COALESCE(NEW.total_transfer, 0);

    -- Verificar si types_increase es un arreglo JSON válido
    IF NEW.types_increase IS NOT NULL AND jsonb_typeof(NEW.types_increase) = 'array' THEN
        -- Consultar el rate desde types_increase
        SELECT (value->>'rate')::numeric INTO rate
        FROM jsonb_array_elements(NEW.types_increase) AS value
        WHERE LOWER(value->>'name') = LOWER(NEW.request_type);

        -- Ajustar total_amount con el rate
        IF rate IS NOT NULL THEN
            new_total_amount := new_total_amount * (1 + rate / 100);
        END IF;
    END IF;

    -- Redondear total_amount a 1 decimal
    new_total_amount := ROUND(new_total_amount, 1);

    -- Actualizar total_amount
    UPDATE itineraries
    SET total_amount = new_total_amount
    WHERE id = NEW.id;

    -- Calcular y actualizar total_markup
    IF new_total_amount > 0 THEN
        UPDATE itineraries
        SET total_markup = ROUND((new_total_amount - COALESCE(NEW.total_cost, 0)), 1) 
        WHERE id = NEW.id;
    ELSE
        UPDATE itineraries
        SET total_markup = 0
        WHERE id = NEW.id;
    END IF;

    RETURN NEW;
END;
$$;


--
-- Name: escape_newlines(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.escape_newlines() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
  -- Reemplazar saltos de línea únicamente si es necesario
  IF NEW.description IS NOT NULL THEN
    NEW.description := REPLACE(NEW.description, E'\n', '\\n'); -- Conserva el salto de línea
  END IF;

  -- Aplica el mismo reemplazo a otros campos relevantes
  IF NEW.inclutions IS NOT NULL THEN
    NEW.inclutions := REPLACE(NEW.inclutions, E'\n', '\n');
  END IF;

  IF NEW.exclutions IS NOT NULL THEN
    NEW.exclutions := REPLACE(NEW.exclutions, E'\n', '\n');
  END IF;

  IF NEW.recomendations IS NOT NULL THEN
    NEW.recomendations := REPLACE(NEW.recomendations, E'\n', '\n');
  END IF;

  IF NEW.instructions IS NOT NULL THEN
    NEW.instructions := REPLACE(NEW.instructions, E'\n', '\n');
  END IF;

  RETURN NEW;
END;$$;


--
-- Name: filter_contacts(text, text, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.filter_contacts(search_term text DEFAULT NULL::text, user_rol_filter text DEFAULT NULL::text, is_vendor_filter boolean DEFAULT NULL::boolean) RETURNS TABLE(id uuid, name text, last_name text, email text, phone text, user_rol text, is_vendor boolean, number_id text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.id,
        c.name,
        c.last_name,
        c.email,
        c.phone,
        c.user_rol,
        c.is_vendor,
        c.number_id
    FROM 
        public.contacts c
    WHERE 
        (
            search_term IS NULL OR search_term = '' OR
            c.name ILIKE '%' || search_term || '%' OR
            c.number_id ILIKE '%' || search_term || '%' OR
            c.email ILIKE '%' || search_term || '%' OR
            c.phone ILIKE '%' || search_term || '%'
        )
        AND (user_rol_filter IS NULL OR user_rol_filter = '' OR c.user_rol = user_rol_filter)
        AND (is_vendor_filter IS NULL OR c.is_vendor = is_vendor_filter);
END;
$$;


--
-- Name: function_add_activity(text, text, text, uuid, text, text, text, text, text, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_add_activity(name text, description text, type text, location uuid, inclutions text, exclutions text, recomendations text, instructions text, id_contact text, account_id uuid) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_contact uuid;
    v_activity_id uuid;
BEGIN
    -- Convert id_contact from text to uuid
    v_id_contact := id_contact::uuid;

    -- Insert the new activity into the activities table
    INSERT INTO public.activities (
        name,
        description,
        type,
        location,
        inclutions,
        exclutions,
        recomendations,
        instructions,
        id_contact,
        account_id  -- Include account_id in the insert
    ) VALUES (
        name,
        description,
        type,
        location,  -- Ahora es de tipo uuid
        inclutions,
        exclutions,
        recomendations,
        instructions,
        v_id_contact,
        account_id  -- Use the account_id parameter
    ) RETURNING id INTO v_activity_id;

    -- Return the id of the new activity
    RETURN v_activity_id;
END;
$$;


--
-- Name: function_add_activity_test(text, text, text, text, uuid, text, text, text, text, text, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_add_activity_test(name text, description text, description_short text, type text, location uuid, inclutions text, exclutions text, recomendations text, instructions text, id_contact text, account_id uuid) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_contact uuid;
    v_activity_id uuid;
BEGIN
    -- Convert id_contact from text to uuid
    v_id_contact := id_contact::uuid;
    description := REPLACE(description, E'\n', ' ');

    -- Insert the new activity into the activities table
    INSERT INTO public.activities (
        name,
        description,
        description_short,  -- Incluir el nuevo campo en la inserción
        type,
        location,
        inclutions,
        exclutions,
        recomendations,
        instructions,
        id_contact,
        account_id  -- Include account_id in the insert
    ) VALUES (
        name,
        description,
        description_short,  -- Usar el nuevo parámetro
        type,
        location,  -- Ahora es de tipo uuid
        inclutions,
        exclutions,
        recomendations,
        instructions,
        v_id_contact,
        account_id  -- Use the account_id parameter
    ) RETURNING id INTO v_activity_id;

    -- Return the id of the new activity as JSON
    RETURN json_build_object('id', v_activity_id);  -- Retorna el ID en formato JSON
END;
$$;


--
-- Name: function_add_edit_product_rates(text, text, text, text, text, numeric, numeric, numeric, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_add_edit_product_rates(typeproduct text, typeaction text, id_product text, id_rate text, p_name text, p_unit_cost numeric, p_profit numeric, p_price numeric, account_id text) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF typeproduct = 'activities' THEN
        IF typeaction = 'add' THEN
            INSERT INTO public.activities_rates (id_product, name, unit_cost, profit, price, account_id)
            VALUES (id_product::uuid, p_name, p_unit_cost, p_profit, p_price, account_id::uuid);
        ELSIF typeaction = 'edit' THEN
            UPDATE public.activities_rates
            SET name = p_name,  -- Usar p_name para evitar ambigüedad
                unit_cost = p_unit_cost,  -- Usar p_unit_cost
                profit = p_profit,        -- Usar p_profit
                price = p_price          -- Usar p_price
            WHERE id = id_rate::uuid;  -- Convertir id_rate a uuid
        ELSE
            RAISE EXCEPTION 'Invalid typeaction: %', typeaction;
        END IF;

    ELSIF typeproduct = 'hotels' THEN
        IF typeaction = 'add' THEN
            INSERT INTO public.hotel_rates (hotel_id, name, unit_cost, profit, price, account_id)
            VALUES (id_product::uuid, p_name, p_unit_cost, p_profit, p_price, account_id::uuid);
        ELSIF typeaction = 'edit' THEN
            UPDATE public.hotel_rates
            SET name = p_name,  -- Usar p_name para evitar ambigüedad
                unit_cost = p_unit_cost,  -- Usar p_unit_cost
                profit = p_profit,        -- Usar p_profit
                price = p_price          -- Usar p_price
            WHERE id = id_rate::uuid;  -- Convertir id_rate a uuid
        ELSE
            RAISE EXCEPTION 'Invalid typeaction: %', typeaction;
        END IF;

    ELSIF typeproduct = 'transfers' THEN
        IF typeaction = 'add' THEN
            INSERT INTO public.transfer_rates (id_transfer, name, unit_cost, profit, price, account_id)
            VALUES (id_product::uuid, p_name, p_unit_cost, p_profit, p_price, account_id::uuid);
        ELSIF typeaction = 'edit' THEN
            UPDATE public.transfer_rates
            SET name = p_name,  -- Usar p_name para evitar ambigüedad
                unit_cost = p_unit_cost,  -- Usar p_unit_cost
                profit = p_profit,        -- Usar p_profit
                price = p_price          -- Usar p_price
            WHERE id = id_rate::uuid;  -- Convertir id_rate a uuid
        ELSE
            RAISE EXCEPTION 'Invalid typeaction: %', typeaction;
        END IF;

    ELSE
        RAISE EXCEPTION 'Invalid typeproduct: %', typeproduct;
    END IF;
END;
$$;


--
-- Name: function_add_rate_activity(text, numeric, numeric, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_add_rate_activity(name text, unit_cost numeric, price numeric, id_product text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_profit numeric;
    v_id_product uuid;
BEGIN
    -- Convertir el id_product de string a UUID
    v_id_product := id_product::uuid;

    -- Calcular el profit como porcentaje y redondear a un decimal
    IF unit_cost > 0 THEN
        v_profit := ROUND(((price - unit_cost) / unit_cost) * 100, 1);
    ELSE
        v_profit := 0; -- Evitar división por cero
    END IF;

    -- Insertar el registro en la tabla activities_rates
    INSERT INTO public.activities_rates (name, unit_cost, profit, price, id_product, created_at, updated_at)
    VALUES (name, unit_cost, v_profit, price, v_id_product, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
END;
$$;


--
-- Name: function_all_items_itinerary(uuid, integer, integer, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_all_items_itinerary(p_id_itinerary uuid, p_page_number integer, p_page_size integer, p_search text) RETURNS TABLE(id uuid, product_name text, rate_name text, quantity numeric, unit_cost numeric, total_cost numeric, date date, provider_name text, provider_email text, provider_email_related text, paid_cost numeric, pending_paid_cost numeric, reservation_status boolean, reservation_messages jsonb[], product_type text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ii.id AS id,
        ii.product_name,
        ii.rate_name,
        ii.quantity,
        ii.unit_cost,
        ii.total_cost,
        ii.date,
        CASE
            WHEN al.id IS NOT NULL THEN al.name
            WHEN h.id_contact IS NOT NULL THEN c.name
            WHEN t.id_contact IS NOT NULL THEN c.name
            WHEN a.id_contact IS NOT NULL THEN c.name
            ELSE NULL
        END AS provider_name,
        c.email AS provider_email,
        ( SELECT string_agg(crelated.email, ', ') AS provider_email_related FROM public.contacts crelated WHERE crelated.id_related_contact = c.id AND crelated. 
        notify = true OR crelated.id = c.id),
        ii.paid_cost,
        ii.pending_paid_cost,
        ii.reservation_status,
        ii.reservation_messages,
        ii.product_type
    FROM 
        itinerary_items ii
    LEFT JOIN activities a ON ii.id_product = a.id
    LEFT JOIN hotels h ON ii.id_product = h.id
    LEFT JOIN transfers t ON ii.id_product = t.id
    LEFT JOIN airlines al ON ii.id_product = al.id
    LEFT JOIN contacts c ON (
        a.id_contact = c.id OR 
        h.id_contact = c.id OR 
        t.id_contact = c.id
    )
    WHERE 
        ii.id_itinerary = p_id_itinerary
        AND (
            ii.product_name ILIKE '%' || p_search || '%'
            OR ii.rate_name ILIKE '%' || p_search || '%'
            OR (c.name ILIKE '%' || p_search || '%' AND c.id IS NOT NULL)
        )
    ORDER BY ii.date, ii.id
    LIMIT p_page_size OFFSET p_page_number * p_page_size;
END;
$$;


--
-- Name: function_calculate_item_pending_paid_cost(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_calculate_item_pending_paid_cost() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Calcular el campo pending_paid_cost igual al total_cost antes de insertar el registro
    NEW.pending_paid_cost := NEW.total_cost;
    RETURN NEW;
END;
$$;


--
-- Name: function_client_itinerary(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_client_itinerary(p_id text) RETURNS TABLE(itinerary_name text, contact_name text, contact_last_name text, user_image text, start_date date, end_date date, currency_type text, valid_until date, total_amount numeric, passenger_count numeric, travel_planner_name text, travel_planner_last_name text, travel_planner_email text, travel_planner_phone text, travel_planner_user_image text, id_fm text, currency jsonb, account_id uuid, logo_image text, account_name text, itinerary_visibility boolean, rates_visibility boolean, personalized_message text, main_image text)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    -- Validar que el parámetro p_id sea un UUID válido
    IF NOT (p_id ~* '^[a-f0-9\-]{36}$') THEN
        RAISE EXCEPTION 'El parámetro p_id no es un UUID válido: %', p_id
            USING HINT = 'Asegúrate de enviar un UUID válido.';
    END IF;

    -- Devolver resultados si existen coincidencias
    RETURN QUERY
    SELECT 
        i.name AS itinerary_name,
        c.name AS contact_name,
        c.last_name AS contact_last_name,
        c.user_image,
        i.start_date AS start_date,
        i.end_date AS end_date,
        i.currency_type,
        i.valid_until AS valid_until,
        i.total_amount,
        i.passenger_count,
        tp.name AS travel_planner_name,
        tp.last_name AS travel_planner_last_name,
        tp.email AS travel_planner_email,
        tp.phone AS travel_planner_phone,
        tp.user_image AS travel_planner_user_image,
        i.id_fm,
        i.currency,
        i.account_id,
        a.logo_image,
        a.name AS account_name,
        i.itinerary_visibility,
        i.rates_visibility,
        i.personalized_message,
        i.main_image
    FROM 
        public.itineraries i
    JOIN 
        public.contacts c ON c.id = i.id_contact
    LEFT JOIN 
        public.contacts tp ON tp.user_id = i.id_created_by
    LEFT JOIN 
        public.accounts a ON a.id = i.account_id
    WHERE 
        i.id = p_id::uuid;

    -- Si no se encuentran resultados, devolver valores NULL
    IF NOT FOUND THEN
        RETURN QUERY SELECT NULL::text, NULL::text, NULL::text, NULL::text, NULL::date, NULL::date, NULL::text, NULL::date, NULL::numeric, NULL::numeric, NULL::text, NULL::text, NULL::text, NULL::text, NULL::text, NULL::text, NULL::jsonb, NULL::uuid, NULL::text, NULL::text, NULL::boolean, NULL::boolean, NULL::text, NULL::text; 
    END IF;
END;
$_$;


--
-- Name: function_copy_itinerary_item(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_copy_itinerary_item(original_id uuid) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    new_item_id uuid;
    result_json json;
BEGIN
    -- Insertar un nuevo ítem duplicado
    INSERT INTO public.itinerary_items (id_itinerary, start_time, end_time, day_number, "order", 
        unit_cost, quantity, total_cost, date, destination, product_name, rate_name, product_type, 
        hotel_nights, profit_percentage, profit, total_price, flight_departure, flight_arrival, 
        departure_time, arrival_time, flight_number, airline, unit_price, id_product, account_id)
    SELECT 
        ii.id_itinerary, ii.start_time, ii.end_time, ii.day_number, ii."order", 
        ii.unit_cost, ii.quantity, ii.total_cost, ii.date, ii.destination, ii.product_name, ii.rate_name, ii.product_type, 
        ii.hotel_nights, ii.profit_percentage, ii.profit, ii.total_price, ii.flight_departure, ii.flight_arrival, 
        ii.departure_time, ii.arrival_time, ii.flight_number, ii.airline, ii.unit_price, ii.id_product, ii.account_id
    FROM 
        public.itinerary_items ii
    WHERE 
        ii.id = original_id
    RETURNING itinerary_items.id INTO new_item_id;

    -- Construir el JSON con la información del nuevo ítem
    SELECT row_to_json(result_row) INTO result_json
    FROM (
        SELECT 
            ii.id,
            ii.id_itinerary,
            ii.start_time,
            ii.end_time,
            ii.day_number,
            ii."order",
            ii.created_at,
            ii.updated_at,
            ii.unit_cost,
            ii.quantity,
            ii.total_cost,
            ii.date,
            ii.destination,
            ii.product_name,
            ii.rate_name,
            ii.product_type,
            ii.hotel_nights,
            ii.profit_percentage,
            ii.profit,
            ii.total_price,
            ii.flight_departure,
            ii.flight_arrival,
            ii.departure_time,
            ii.arrival_time,
            ii.flight_number,
            ii.airline,
            ii.unit_price,
            ii.id_product,
            ii.account_id,
            a.logo_symbol_url,
            CASE 
                WHEN ii.product_type = 'Hoteles' THEN (SELECT h.main_image FROM public.hotels h WHERE h.id = ii.id_product)
                WHEN ii.product_type = 'Servicios' THEN (SELECT a.main_image FROM public.activities a WHERE a.id = ii.id_product)
                WHEN ii.product_type = 'Transporte' THEN (SELECT t.main_image FROM public.transfers t WHERE t.id = ii.id_product)
                ELSE NULL
            END AS main_image,
            CASE 
                WHEN ii.product_type = 'Hoteles' THEN (SELECT c.name FROM public.hotels h JOIN public.contacts c ON h.id_contact = c.id WHERE h.id = ii.id_product)
                WHEN ii.product_type = 'Servicios' THEN (SELECT c.name FROM public.activities a JOIN public.contacts c ON a.id_contact = c.id WHERE a.id = ii.id_product)
                WHEN ii.product_type = 'Transporte' THEN (SELECT c.name FROM public.transfers t JOIN public.contacts c ON t.id_contact = c.id WHERE t.id = ii.id_product)
                ELSE NULL
            END AS name_provider
        FROM 
            public.itinerary_items ii
        LEFT JOIN 
            public.airlines a ON ii.airline = a.id
        WHERE 
            ii.id = new_item_id
    ) result_row;

    RETURN result_json;
END;
$$;


--
-- Name: function_count_passengers_by_itinerary(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_count_passengers_by_itinerary(p_itinerary_id uuid) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    passenger_count integer;
BEGIN
    -- Contar el número de registros en la tabla passenger que coinciden con el itinerary_id
    SELECT COUNT(*) INTO passenger_count
    FROM public.passenger
    WHERE itinerary_id = p_itinerary_id;  -- Usar el parámetro renombrado

    -- Retornar el conteo
    RETURN passenger_count;
END;
$$;


--
-- Name: function_create_itinerary(text, date, numeric, date, text, timestamp with time zone, text, uuid, text, uuid, text, text, uuid, jsonb, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_create_itinerary(name text, itinerary_start_date date, itinerary_passenger_count numeric, itinerary_end_date date, itinerary_currency_type text, itinerary_valid_until timestamp with time zone, itinerary_agent text, contact_id uuid, itinerary_language text, creator_id uuid, itinerary_request_type text, itinerary_id_fm text, account_id uuid, input_currency jsonb, itinerary_status text) RETURNS TABLE(itinerary_id uuid, itinerary_name text, contact_name text, created_by_contact_name text, id_contact uuid, id_created_by uuid, start_date date, end_date date, status text, passenger_count numeric, currency_type text, valid_until timestamp with time zone, request_type text, total_amount numeric, total_cost numeric, agent text, total_provider_payment numeric, id_fm text, language text, total_hotels numeric, total_flights numeric, total_activities numeric, total_transfer numeric, currency jsonb)
    LANGUAGE plpgsql
    AS $$
DECLARE
    new_itinerary_id uuid;
    contact_name text;
    created_by_contact_name text;  -- Variable para almacenar el nombre del creador
BEGIN
    -- Insertar el nuevo registro en la tabla itineraries
    INSERT INTO itineraries (
        id, name, start_date, end_date, passenger_count, currency_type, 
        valid_until, agent, id_contact, language, id_created_by, 
        request_type, id_fm, account_id, currency, status  -- Incluir status en la inserción
    ) VALUES (
        DEFAULT, name, itinerary_start_date, itinerary_end_date, itinerary_passenger_count, itinerary_currency_type, 
        itinerary_valid_until, itinerary_agent, contact_id, itinerary_language, creator_id, 
        itinerary_request_type, itinerary_id_fm, account_id, input_currency, itinerary_status  -- Usar itinerary_status directamente
    )
    RETURNING id INTO new_itinerary_id;

    -- Obtener el nombre del contacto
    SELECT c.name INTO contact_name
    FROM contacts c
    WHERE c.id = contact_id;

    -- Obtener el nombre del creador desde la tabla contacts usando user_id
    SELECT c.name INTO created_by_contact_name
    FROM contacts c
    WHERE c.user_id = creator_id;  -- Cambiado para buscar por user_id

    -- Retornar los datos del nuevo itinerario
    RETURN QUERY
    SELECT
        new_itinerary_id AS itinerary_id,
        name AS itinerary_name,
        contact_name,
        created_by_contact_name,  -- Incluir el nombre del creador
        contact_id AS id_contact,
        creator_id AS id_created_by,
        itinerary_start_date AS start_date,
        itinerary_end_date AS end_date,
        itinerary_status AS status,  -- Retornar el campo status
        itinerary_passenger_count AS passenger_count,
        itinerary_currency_type AS currency_type,
        itinerary_valid_until AS valid_until,
        itinerary_request_type AS request_type,
        0::numeric AS total_amount,  -- Cast to numeric
        0::numeric AS total_cost,     -- Cast to numeric
        itinerary_agent AS agent,
        0::numeric AS total_provider_payment,  -- Cast to numeric
        itinerary_id_fm AS id_fm,
        itinerary_language AS language,
        0::numeric AS total_hotels,  -- Cast to numeric
        0::numeric AS total_flights,  -- Cast to numeric
        0::numeric AS total_activities,  -- Cast to numeric
        0::numeric AS total_transfer,  -- Cast to numeric
        input_currency  -- Incluir input_currency directamente
    ;
END;
$$;


--
-- Name: function_create_itinerary(text, date, numeric, date, text, timestamp with time zone, text, uuid, text, uuid, text, text, uuid, jsonb, text, jsonb); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_create_itinerary(name text, itinerary_start_date date, itinerary_passenger_count numeric, itinerary_end_date date, itinerary_currency_type text, itinerary_valid_until timestamp with time zone, itinerary_agent text, contact_id uuid, itinerary_language text, creator_id uuid, itinerary_request_type text, itinerary_id_fm text, account_id uuid, input_currency jsonb, itinerary_status text, input_types_increase jsonb) RETURNS TABLE(itinerary_id uuid, itinerary_name text, contact_name text, created_by_contact_name text, id_contact uuid, id_created_by uuid, start_date date, end_date date, status text, passenger_count numeric, currency_type text, valid_until timestamp with time zone, request_type text, total_amount numeric, total_cost numeric, agent text, total_provider_payment numeric, id_fm text, language text, total_hotels numeric, total_flights numeric, total_activities numeric, total_transfer numeric, currency jsonb, types_increase jsonb)
    LANGUAGE plpgsql
    AS $$
DECLARE
    new_itinerary_id uuid;
    contact_name text;
    created_by_contact_name text;  -- Variable para almacenar el nombre del creador
BEGIN
    -- Insertar el nuevo registro en la tabla itineraries
    INSERT INTO itineraries (
        id, name, start_date, end_date, passenger_count, currency_type, 
        valid_until, agent, id_contact, language, id_created_by, 
        request_type, id_fm, account_id, currency, status, types_increase  -- Incluir types_increase en la inserción este
    ) VALUES (
        DEFAULT, name, itinerary_start_date, itinerary_end_date, itinerary_passenger_count, itinerary_currency_type, 
        itinerary_valid_until, itinerary_agent, contact_id, itinerary_language, creator_id, 
        itinerary_request_type, itinerary_id_fm, account_id, input_currency, itinerary_status, input_types_increase  -- Usar types_increase directamente este
    )
    RETURNING id INTO new_itinerary_id;

    -- Obtener el nombre del contacto
    SELECT c.name INTO contact_name
    FROM contacts c
    WHERE c.id = contact_id;

    -- Obtener el nombre del creador desde la tabla contacts usando user_id
    SELECT c.name INTO created_by_contact_name
    FROM contacts c
    WHERE c.user_id = creator_id;  -- Cambiado para buscar por user_id

    -- Retornar los datos del nuevo itinerario
    RETURN QUERY
    SELECT
        new_itinerary_id AS itinerary_id,
        name AS itinerary_name,
        contact_name,
        created_by_contact_name,  -- Incluir el nombre del creador
        contact_id AS id_contact,
        creator_id AS id_created_by,
        itinerary_start_date AS start_date,
        itinerary_end_date AS end_date,
        itinerary_status AS status,  -- Retornar el campo status
        itinerary_passenger_count AS passenger_count,
        itinerary_currency_type AS currency_type,
        itinerary_valid_until AS valid_until,
        itinerary_request_type AS request_type,
        0::numeric AS total_amount,  -- Cast to numeric
        0::numeric AS total_cost,     -- Cast to numeric
        itinerary_agent AS agent,
        0::numeric AS total_provider_payment,  -- Cast to numeric
        itinerary_id_fm AS id_fm,
        itinerary_language AS language,
        0::numeric AS total_hotels,  -- Cast to numeric
        0::numeric AS total_flights,  -- Cast to numeric
        0::numeric AS total_activities,  -- Cast to numeric
        0::numeric AS total_transfer,  -- Cast to numeric
        input_currency,  -- Incluir input_currency directamente
        input_types_increase  -- Incluir types_increase en el retorno este
    ;
END;
$$;


--
-- Name: function_create_itinerary(text, date, numeric, date, text, timestamp with time zone, text, uuid, text, uuid, text, text, uuid, jsonb, text, jsonb, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_create_itinerary(name text, itinerary_start_date date, itinerary_passenger_count numeric, itinerary_end_date date, itinerary_currency_type text, itinerary_valid_until timestamp with time zone, itinerary_agent text, contact_id uuid, itinerary_language text, creator_id uuid, itinerary_request_type text, itinerary_id_fm text, account_id uuid, input_currency jsonb, itinerary_status text, input_types_increase jsonb, itinerary_personalized_message text) RETURNS TABLE(itinerary_id uuid, itinerary_name text, contact_name text, created_by_contact_name text, id_contact uuid, id_created_by uuid, start_date date, end_date date, status text, passenger_count numeric, currency_type text, valid_until timestamp with time zone, request_type text, total_amount numeric, total_cost numeric, agent text, total_provider_payment numeric, id_fm text, language text, total_hotels numeric, total_flights numeric, total_activities numeric, total_transfer numeric, currency jsonb, types_increase jsonb, personalized_message text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    new_itinerary_id uuid;
    contact_name text;
    created_by_contact_name text;  -- Variable para almacenar el nombre del creador
BEGIN
    -- Insertar el nuevo registro en la tabla itineraries
    INSERT INTO itineraries (
        id, name, start_date, end_date, passenger_count, currency_type, 
        valid_until, agent, id_contact, language, id_created_by, 
        request_type, id_fm, account_id, currency, status, types_increase, personalized_message  -- Mantener el nombre de la columna en la BD
    ) VALUES (
        DEFAULT, name, itinerary_start_date, itinerary_end_date, itinerary_passenger_count, itinerary_currency_type, 
        itinerary_valid_until, itinerary_agent, contact_id, itinerary_language, creator_id, 
        itinerary_request_type, itinerary_id_fm, account_id, input_currency, itinerary_status, input_types_increase, itinerary_personalized_message  -- Usar el nuevo parámetro
    )
    RETURNING id INTO new_itinerary_id;

    -- Obtener el nombre del contacto
    SELECT c.name INTO contact_name
    FROM contacts c
    WHERE c.id = contact_id;

    -- Obtener el nombre del creador desde la tabla contacts usando user_id
    SELECT c.name INTO created_by_contact_name
    FROM contacts c
    WHERE c.user_id = creator_id;  -- Cambiado para buscar por user_id

    -- Retornar los datos del nuevo itinerario
    RETURN QUERY
    SELECT
        new_itinerary_id AS itinerary_id,
        name AS itinerary_name,
        contact_name,
        created_by_contact_name,  -- Incluir el nombre del creador
        contact_id AS id_contact,
        creator_id AS id_created_by,
        itinerary_start_date AS start_date,
        itinerary_end_date AS end_date,
        itinerary_status AS status,  -- Retornar el campo status
        itinerary_passenger_count AS passenger_count,
        itinerary_currency_type AS currency_type,
        itinerary_valid_until AS valid_until,
        itinerary_request_type AS request_type,
        0::numeric AS total_amount,  -- Cast to numeric
        0::numeric AS total_cost,     -- Cast to numeric
        itinerary_agent AS agent,
        0::numeric AS total_provider_payment,  -- Cast to numeric
        itinerary_id_fm AS id_fm,
        itinerary_language AS language,
        0::numeric AS total_hotels,  -- Cast to numeric
        0::numeric AS total_flights,  -- Cast to numeric
        0::numeric AS total_activities,  -- Cast to numeric
        0::numeric AS total_transfer,  -- Cast to numeric
        input_currency,  -- Incluir input_currency directamente
        input_types_increase,  -- Incluir types_increase en el retorno este
        itinerary_personalized_message AS personalized_message  -- Usar el nuevo parámetro en el retorno
    ;
END;
$$;


--
-- Name: function_create_itinerary(text, date, numeric, date, text, timestamp with time zone, text, uuid, text, uuid, text, text, uuid, jsonb, text, jsonb, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_create_itinerary(name text, itinerary_start_date date, itinerary_passenger_count numeric, itinerary_end_date date, itinerary_currency_type text, itinerary_valid_until timestamp with time zone, itinerary_agent text, contact_id uuid, itinerary_language text, creator_id uuid, itinerary_request_type text, itinerary_id_fm text, account_id uuid, input_currency jsonb, itinerary_status text, input_types_increase jsonb, itinerary_personalized_message text, itinerary_main_image text) RETURNS TABLE(itinerary_id uuid, itinerary_name text, contact_name text, created_by_contact_name text, id_contact uuid, id_created_by uuid, start_date date, end_date date, status text, passenger_count numeric, currency_type text, valid_until timestamp with time zone, request_type text, total_amount numeric, total_cost numeric, agent text, total_provider_payment numeric, id_fm text, language text, total_hotels numeric, total_flights numeric, total_activities numeric, total_transfer numeric, currency jsonb, types_increase jsonb, personalized_message text, main_image text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    new_itinerary_id uuid;
    contact_name text;
    created_by_contact_name text;
BEGIN
    -- Insertar el nuevo registro en la tabla itineraries
    INSERT INTO itineraries (
        id, name, start_date, end_date, passenger_count, currency_type, 
        valid_until, agent, id_contact, language, id_created_by, 
        request_type, id_fm, account_id, currency, status, types_increase, 
        personalized_message, main_image  -- Añadido el nuevo campo
    ) VALUES (
        DEFAULT, name, itinerary_start_date, itinerary_end_date, itinerary_passenger_count, itinerary_currency_type, 
        itinerary_valid_until, itinerary_agent, contact_id, itinerary_language, creator_id, 
        itinerary_request_type, itinerary_id_fm, account_id, input_currency, itinerary_status, input_types_increase, 
        itinerary_personalized_message, itinerary_main_image  -- Añadido el nuevo parámetro
    )
    RETURNING id INTO new_itinerary_id;

    -- Obtener el nombre del contacto
    SELECT c.name INTO contact_name
    FROM contacts c
    WHERE c.id = contact_id;

    -- Obtener el nombre del creador desde la tabla contacts usando user_id
    SELECT c.name INTO created_by_contact_name
    FROM contacts c
    WHERE c.user_id = creator_id;

    -- Retornar los datos del nuevo itinerario
    RETURN QUERY
    SELECT
        new_itinerary_id AS itinerary_id,
        name AS itinerary_name,
        contact_name,
        created_by_contact_name,
        contact_id AS id_contact,
        creator_id AS id_created_by,
        itinerary_start_date AS start_date,
        itinerary_end_date AS end_date,
        itinerary_status AS status,
        itinerary_passenger_count AS passenger_count,
        itinerary_currency_type AS currency_type,
        itinerary_valid_until AS valid_until,
        itinerary_request_type AS request_type,
        0::numeric AS total_amount,
        0::numeric AS total_cost,
        itinerary_agent AS agent,
        0::numeric AS total_provider_payment,
        itinerary_id_fm AS id_fm,
        itinerary_language AS language,
        0::numeric AS total_hotels,
        0::numeric AS total_flights,
        0::numeric AS total_activities,
        0::numeric AS total_transfer,
        input_currency,
        input_types_increase,
        itinerary_personalized_message AS personalized_message,
        itinerary_main_image AS main_image  -- Añadido al retorno
    ;
END;
$$;


--
-- Name: function_cuentas_por_cobrar(text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_cuentas_por_cobrar(fecha_inicial text DEFAULT NULL::text, fecha_final text DEFAULT NULL::text, search text DEFAULT NULL::text) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
    fecha_inicial_date DATE;
    fecha_final_date DATE;
    total_pending_paid numeric;
BEGIN
    -- Establecer fechas por defecto si no se proporcionan
    IF fecha_inicial IS NULL OR fecha_inicial = '' THEN
        fecha_inicial_date := '-infinity';  -- Permitir todos los registros pasados
    ELSE
        fecha_inicial_date := fecha_inicial::DATE;  -- Convertir a tipo DATE
    END IF;

    IF fecha_final IS NULL OR fecha_final = '' THEN
        fecha_final_date := CURRENT_DATE + INTERVAL '1 month';  -- Un mes a partir de hoy
    ELSE
        fecha_final_date := fecha_final::DATE;  -- Convertir a tipo DATE
    END IF;

    -- Calcular el total de pending_paid
    SELECT SUM(i.pending_paid) INTO total_pending_paid
    FROM 
        itineraries i
    WHERE 
        i.status = 'Confirmado'
        AND i.pending_paid > 0
        AND i.start_date BETWEEN fecha_inicial_date AND fecha_final_date
        AND (search IS NULL OR i.name ILIKE '%' || search || '%');

    -- Verificar si total_pending_paid es NULL y devolver un array vacío y 0
    IF total_pending_paid IS NULL THEN
        RETURN jsonb_build_object(
            'items', jsonb_build_array(),  -- Array vacío
            'total', 0                     -- Total 0
        );
    END IF;

    -- Devolver el objeto JSON que incluye items y total
    RETURN jsonb_build_object(
        'items', (
            SELECT jsonb_agg(jsonb_build_object(
                'name', i.name,            -- Nombre del itinerario
                'name_contact', c.name,    -- Nombre del contacto
                'last_name', c.last_name,  -- Apellido del contacto
                'start_date', i.start_date,
                'total_amount', i.total_amount,  -- Especificar que es de la tabla itineraries
                'pending_paid', i.pending_paid,   -- Especificar que es de la tabla itineraries
                'id_fm', i.id_fm
            ))
            FROM 
                itineraries i
            LEFT JOIN 
                contacts c ON i.id_contact = c.id  -- Unir con la tabla contacts
            WHERE 
                i.status = 'Confirmado'
                AND i.pending_paid > 0
                AND i.start_date BETWEEN fecha_inicial_date AND fecha_final_date
                AND (search IS NULL OR i.name ILIKE '%' || search || '%')
        ),
        'total', total_pending_paid
    );
END;
$$;


--
-- Name: function_cuentas_por_pagar(text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_cuentas_por_pagar(search text DEFAULT NULL::text, fecha_inicial text DEFAULT NULL::text, fecha_final text DEFAULT NULL::text) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
    result jsonb;
    total_pending_paid numeric;  -- Variable para almacenar la suma total
    fecha_inicial_date date;
    fecha_final_date date;
BEGIN
    -- Establecer fechas por defecto si no se proporcionan
    IF fecha_inicial = '' THEN
        fecha_inicial := NULL;
    END IF;

    IF fecha_final = '' THEN
        fecha_final := NULL;
    END IF;

    -- Si no se proporcionan fechas, establecer el rango del último mes
    IF fecha_inicial IS NULL AND fecha_final IS NULL THEN
        fecha_inicial_date := CURRENT_DATE - INTERVAL '1 month';  -- Un mes atrás desde hoy
        fecha_final_date := CURRENT_DATE;  -- Hoy
    ELSE
        -- Convertir las fechas de texto a tipo date
        fecha_inicial_date := fecha_inicial::date;
        fecha_final_date := fecha_final::date;
    END IF;

    -- Obtener la suma total de pending_paid_cost
    SELECT SUM(ii.pending_paid_cost) INTO total_pending_paid
    FROM public.itinerary_items ii
    JOIN public.itineraries it ON ii.id_itinerary = it.id AND it.status = 'Confirmado'
    LEFT JOIN public.activities a ON ii.id_product = a.id
    LEFT JOIN public.hotels h ON ii.id_product = h.id
    LEFT JOIN public.transfers t ON ii.id_product = t.id
    LEFT JOIN public.airlines al ON ii.id_product = al.id
    LEFT JOIN public.contacts c ON 
        (h.id_contact = c.id OR t.id_contact = c.id OR a.id_contact = c.id)  -- Obtener el nombre del contacto
    WHERE 
        ii.date BETWEEN fecha_inicial_date AND fecha_final_date  -- Filtrar por rango de fechas
        AND ii.pending_paid_cost > 0  -- Filtrar solo ítems donde pending_paid_cost sea mayor a 0
        AND (search IS NULL OR search = '' OR 
             ii.product_name ILIKE '%' || search || '%' OR 
             COALESCE(a.name, c.name, al.name) ILIKE '%' || search || '%');  -- Filtrar por nombre del producto o proveedor

    -- Obtener los datos de los proveedores
    SELECT jsonb_agg(provider_data) INTO result
    FROM (
        SELECT 
            CASE 
                WHEN al.name IS NOT NULL THEN al.name  -- Si es un vuelo, usar el nombre de airlines
                ELSE COALESCE(a.name, c.name)  -- Para otros tipos, usar el nombre de activities o contacts
            END AS provider_name,
            SUM(ii.pending_paid_cost) AS total_pending_paid_cost,  -- Sumar pending_paid_cost
            jsonb_agg(jsonb_build_object(
                'date', ii.date,
                'product_name', ii.product_name,
                'total_price', ii.total_price,
                'pending_paid_cost', ii.pending_paid_cost,  -- Incluir pending_paid_cost
                'id_fm', it.id_fm  -- Incluir id_fm del itinerario
            ) ORDER BY ii.date) AS items  -- Ordenar los ítems por fecha
        FROM 
            public.itinerary_items ii
        JOIN 
            public.itineraries it ON ii.id_itinerary = it.id AND it.status = 'Confirmado'
        LEFT JOIN 
            public.activities a ON ii.id_product = a.id
        LEFT JOIN 
            public.hotels h ON ii.id_product = h.id
        LEFT JOIN 
            public.transfers t ON ii.id_product = t.id
        LEFT JOIN 
            public.airlines al ON ii.id_product = al.id
        LEFT JOIN 
            public.contacts c ON 
                (h.id_contact = c.id OR t.id_contact = c.id OR a.id_contact = c.id)  -- Obtener el nombre del contacto
        WHERE 
            ii.date BETWEEN fecha_inicial_date AND fecha_final_date  -- Filtrar por rango de fechas
            AND ii.pending_paid_cost > 0  -- Filtrar solo ítems donde pending_paid_cost sea mayor a 0
            AND (search IS NULL OR search = '' OR 
                 ii.product_name ILIKE '%' || search || '%' OR 
                 COALESCE(a.name, c.name, al.name) ILIKE '%' || search || '%')  -- Filtrar por nombre del producto o proveedor
        GROUP BY 
            provider_name
    ) AS provider_data;

    -- Si no se encontraron resultados, devolver un JSON vacío
    IF result IS NULL THEN
        RETURN jsonb_build_object('providers', jsonb_build_array(), 'total_pending_paid', 0);  -- Retornar un objeto con array vacío y total 0
    END IF;

    RETURN jsonb_build_object('providers', result, 'total_pending_paid', total_pending_paid);  -- Retornar el objeto con proveedores y total
END;
$$;


--
-- Name: function_delete_record(uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_delete_record(record_id uuid, record_type text) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF record_type = 'hotels' THEN
        DELETE FROM public.hotels
        WHERE id = record_id;

    ELSIF record_type = 'transfers' THEN
        DELETE FROM public.transfers
        WHERE id = record_id;

    ELSIF record_type = 'activities' THEN
        DELETE FROM public.activities
        WHERE id = record_id;

    ELSE
        RAISE EXCEPTION 'Invalid record type: %', record_type;  -- Manejo de error para tipos no válidos
    END IF;
END;
$$;


--
-- Name: function_duplicate_itinerary(uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_duplicate_itinerary(original_id uuid, new_id_fm text) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$DECLARE
    new_itinerary_id uuid;
    original_itinerary RECORD;
BEGIN
    -- Obtener el itinerario original
    SELECT * INTO original_itinerary
    FROM public.itineraries
    WHERE id = original_id;
    -- Verificar si se encontró el itinerario original
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Itinerary with ID % not found', original_id;
    END IF;
    -- Insertar el nuevo itinerario con el nombre modificado
    INSERT INTO public.itineraries (
        name,
        start_date,
        end_date,
        passenger_count,
        currency_type,
        valid_until,
        agent,
        id_contact,
        language,
        personalized_message,
        id_created_by,
        request_type,
        id_fm,  -- Incluir id_fm aquí
        account_id,
        currency,
        status,
        total_amount,  -- Establecer en 0
        total_cost,    -- Establecer en 0
        total_provider_payment,  -- Establecer en 0
        total_hotels,  -- Establecer en 0
        total_flights,  -- Establecer en 0
        total_activities,  -- Establecer en 0
        total_transfer,   -- Establecer en 0
        types_increase,
        main_image    -- Nuevo campo agregado
    ) VALUES (
        original_itinerary.name || '-COPIA',  -- Modificar el nombre
        original_itinerary.start_date,
        original_itinerary.end_date,
        original_itinerary.passenger_count,
        original_itinerary.currency_type,
        original_itinerary.valid_until,
        original_itinerary.agent,
        original_itinerary.id_contact,
        original_itinerary.language,
        original_itinerary.personalized_message,
        original_itinerary.id_created_by,
        original_itinerary.request_type,
        new_id_fm,  -- Usar directamente el nuevo id_fm proporcionado
        original_itinerary.account_id,
        original_itinerary.currency,
        'Presupuesto',
        0,  -- total_amount se establece en 0
        0,  -- total_cost se establece en 0
        0,  -- total_provider_payment se establece en 0
        0,  -- total_hotels se establece en 0
        0,  -- total_flights se establece en 0
        0,  -- total_activities se establece en 0
        0,   -- total_transfer se establece en 0
        original_itinerary.types_increase,
        original_itinerary.main_image   -- Copiar el valor del campo types_increase del original
    ) RETURNING id INTO new_itinerary_id;
    -- Duplicar los registros en itinerary_items
    INSERT INTO public.itinerary_items (
        id_itinerary,
        start_time,
        end_time,
        day_number,
        "order",
        created_at,
        updated_at,
        unit_cost,
        quantity,
        total_cost,
        date,
        destination,
        product_name,
        personalized_message,
        rate_name,
        product_type,
        hotel_nights,
        profit_percentage,
        profit,
        total_price,
        flight_departure,
        flight_arrival,
        departure_time,
        arrival_time,
        flight_number,
        airline,
        unit_price,
        id_product,
        account_id
    )
    SELECT
        new_itinerary_id,  -- Reemplazar con el nuevo id
        start_time,
        end_time,
        day_number,
        "order",
        created_at,
        updated_at,
        unit_cost,
        quantity,
        total_cost,
        date,
        destination,
        product_name,
        personalized_message,
        rate_name,
        product_type,
        hotel_nights,
        profit_percentage,
        profit,
        total_price,
        flight_departure,
        flight_arrival,
        departure_time,
        arrival_time,
        flight_number,
        airline,
        unit_price,
        id_product,
        account_id
    FROM
        public.itinerary_items
    WHERE
        id_itinerary = original_id;
    -- Retornar el nuevo id del itinerario duplicado
    RETURN jsonb_build_object('itinerary_id', new_itinerary_id);
END;$$;


--
-- Name: function_get_accounts_info_by_user_id_and_exclude_account(uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_get_accounts_info_by_user_id_and_exclude_account(p_user_id uuid, p_account_id uuid) RETURNS TABLE(account_id uuid, name text, status text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT a.id, a.name, a.status, a.created_at
    FROM public.accounts a
    JOIN public.user_roles ur ON a.id = ur.account_id
    WHERE ur.user_id = p_user_id
      AND a.id <> p_account_id;
END;
$$;


--
-- Name: function_get_accounts_with_location(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_get_accounts_with_location(input_account_id uuid) RETURNS TABLE(id uuid, created_at timestamp with time zone, name text, status text, id_fm integer, logo_image text, type_id text, number_id text, phone text, phone2 text, mail text, location uuid, website text, cancellation_policy text, privacy_policy text, terms_conditions text, currency jsonb[], types_increase jsonb[], address text, payment_methods jsonb[])
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        a.id,
        a.created_at,
        a.name,
        a.status,
        a.id_fm,
        a.logo_image,
        a.type_id,
        a.number_id,
        a.phone,
        a.phone2,
        a.mail,
        a.location,
        a.website,
        a.cancellation_policy,
        a.privacy_policy,
        a.terms_conditions,
        a.currency,  -- Traer el valor de currency directamente de la tabla accounts
        a.types_increase,  -- Traer el valor de types_increase directamente de la tabla accounts
        l.address::text,
        a.payment_methods  -- Convertir address a text si es necesario
    FROM 
        accounts a
    LEFT JOIN 
        locations l ON a.location = l.id  -- Realiza el join con la tabla locations
    WHERE 
        a.id = input_account_id;  -- Filtra por el ID de la cuenta proporcionado
END;
$$;


--
-- Name: function_get_agenda(text, text, text, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_get_agenda(search text DEFAULT NULL::text, fecha_inicial text DEFAULT NULL::text, fecha_final text DEFAULT NULL::text, page_number integer DEFAULT 0, page_size integer DEFAULT 10) RETURNS TABLE(id uuid, unit_cost numeric, quantity numeric, total_cost numeric, date date, product_name text, contact_name text, id_fm text, client_name text, product_type text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ii.id,
        ii.unit_cost,
        ii.quantity,
        ii.total_cost,
        ii.date,
        ii.product_name,
        COALESCE(a_ct.name, h_ct.name, t_ct.name, al.name) AS contact_name,
        it.id_fm,
        cli_ct.name AS client_name,
        ii.product_type  -- Added product_type from itineraries
    FROM itinerary_items ii
    
    INNER JOIN itineraries it ON ii.id_itinerary = it.id AND it.status = 'Confirmado'
    LEFT JOIN contacts cli_ct ON it.id_contact = cli_ct.id
    
    LEFT JOIN activities a ON ii.id_product = a.id AND ii.product_type = 'Servicios'
    LEFT JOIN contacts a_ct ON a.id_contact = a_ct.id
    
    LEFT JOIN hotels h ON ii.id_product = h.id AND ii.product_type = 'Hoteles'
    LEFT JOIN contacts h_ct ON h.id_contact = h_ct.id
    
    LEFT JOIN transfers t ON ii.id_product = t.id AND ii.product_type = 'Transporte'
    LEFT JOIN contacts t_ct ON t.id_contact = t_ct.id
    
    LEFT JOIN airlines al ON ii.id_product = al.id AND ii.product_type = 'Vuelos'
    
    WHERE ii.date >= CURRENT_DATE 
    AND (COALESCE(NULLIF(fecha_inicial, ''), CURRENT_DATE::TEXT)::DATE IS NULL 
         OR COALESCE(NULLIF(fecha_final, ''), '9999-12-31'::TEXT)::DATE IS NULL 
         OR ii.date BETWEEN COALESCE(NULLIF(fecha_inicial, ''), CURRENT_DATE::TEXT)::DATE 
                        AND COALESCE(NULLIF(fecha_final, ''), '9999-12-31'::TEXT)::DATE)
    AND (search IS NULL OR search = '' 
         OR ii.product_name ILIKE '%' || search || '%'
         OR cli_ct.name ILIKE '%' || search || '%'
         OR it.id_fm ILIKE '%' || search || '%')
    ORDER BY ii.date ASC
    LIMIT page_size OFFSET page_number * page_size;
END;
$$;


--
-- Name: function_get_agenda_by_date(date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_get_agenda_by_date(target_date date) RETURNS TABLE(id uuid, unit_cost numeric, quantity numeric, total_cost numeric, date date, product_name text, contact_name text, id_fm text, client_name text, product_type text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ii.id,
        ii.unit_cost,
        ii.quantity,
        ii.total_cost,
        ii.date,
        ii.product_name,
        COALESCE(a_ct.name, h_ct.name, t_ct.name, al.name) AS contact_name,
        it.id_fm,
        cli_ct.name AS client_name,
        ii.product_type  -- Added product_type from itineraries
    FROM itinerary_items ii
    
    INNER JOIN itineraries it ON ii.id_itinerary = it.id AND it.status = 'Confirmado'
    LEFT JOIN contacts cli_ct ON it.id_contact = cli_ct.id
    
    LEFT JOIN activities a ON ii.id_product = a.id AND ii.product_type = 'Servicios'
    LEFT JOIN contacts a_ct ON a.id_contact = a_ct.id
    
    LEFT JOIN hotels h ON ii.id_product = h.id AND ii.product_type = 'Hoteles'
    LEFT JOIN contacts h_ct ON h.id_contact = h_ct.id
    
    LEFT JOIN transfers t ON ii.id_product = t.id AND ii.product_type = 'Transporte'
    LEFT JOIN contacts t_ct ON t.id_contact = t_ct.id
    
    LEFT JOIN airlines al ON ii.id_product = al.id AND ii.product_type = 'Vuelos'
    
    WHERE ii.date = target_date
    ORDER BY ii.date ASC;
END;
$$;


--
-- Name: function_get_agenda_by_date(text, text, text, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_get_agenda_by_date(search text DEFAULT NULL::text, fecha_inicial text DEFAULT NULL::text, fecha_final text DEFAULT NULL::text, page_number integer DEFAULT 0, page_size integer DEFAULT 10) RETURNS TABLE(agenda_date date, items jsonb)
    LANGUAGE plpgsql
    AS $$
DECLARE
    query_limit integer;
    query_offset integer;
BEGIN
    query_limit := page_size;
    query_offset := page_number * page_size;

    RETURN QUERY
    WITH agenda_items AS (
        SELECT
            ii.id,
            ii.id_itinerary,
            ii.unit_cost,
            ii.quantity,
            ii.total_cost,
            ii.date AS item_date,
            ii.product_name,
            COALESCE(a_ct.name, h_ct.name, t_ct.name, al.name) AS contact_name,
            it.id_fm,
            cli_ct.name AS client_name,
            ii.product_type
        FROM itinerary_items ii
        INNER JOIN itineraries it ON ii.id_itinerary = it.id AND it.status = 'Confirmado'
        LEFT JOIN contacts cli_ct ON it.id_contact = cli_ct.id
        LEFT JOIN activities a ON ii.id_product = a.id AND ii.product_type = 'Servicios'
        LEFT JOIN contacts a_ct ON a.id_contact = a_ct.id
        LEFT JOIN hotels h ON ii.id_product = h.id AND ii.product_type = 'Hoteles'
        LEFT JOIN contacts h_ct ON h.id_contact = h_ct.id
        LEFT JOIN transfers t ON ii.id_product = t.id AND ii.product_type = 'Transporte'
        LEFT JOIN contacts t_ct ON t.id_contact = t_ct.id
        LEFT JOIN airlines al ON ii.id_product = al.id AND ii.product_type = 'Vuelos'
        WHERE ii.date >= CURRENT_DATE
        AND (COALESCE(NULLIF(fecha_inicial, ''), CURRENT_DATE::TEXT)::DATE IS NULL
             OR COALESCE(NULLIF(fecha_final, ''), '9999-12-31'::TEXT)::DATE IS NULL
             OR ii.date BETWEEN COALESCE(NULLIF(fecha_inicial, ''), CURRENT_DATE::TEXT)::DATE
                            AND COALESCE(NULLIF(fecha_final, ''), '9999-12-31'::TEXT)::DATE)
        AND (search IS NULL OR search = ''
             OR ii.product_name ILIKE '%' || search || '%'
             OR cli_ct.name ILIKE '%' || search || '%'
             OR it.id_fm ILIKE '%' || search || '%')
        ORDER BY ii.date ASC
    ),
    distinct_dates AS (
        SELECT DISTINCT item_date AS unique_date
        FROM agenda_items
        ORDER BY unique_date ASC
        LIMIT query_limit OFFSET query_offset
    )
    SELECT 
        dd.unique_date AS agenda_date,
        jsonb_agg(
            jsonb_build_object(
                'id', ai.id,
                'id_itinerary', ai.id_itinerary,
                'unit_cost', ai.unit_cost,
                'quantity', ai.quantity,
                'total_cost', ai.total_cost,
                'date', ai.item_date::text,
                'product_name', ai.product_name,
                'contact_name', ai.contact_name,
                'id_fm', ai.id_fm,
                'client_name', ai.client_name,
                'product_type', ai.product_type
            )
        ) AS items
    FROM distinct_dates dd
    JOIN agenda_items ai ON dd.unique_date = ai.item_date
    GROUP BY dd.unique_date
    ORDER BY dd.unique_date ASC;
END;
$$;


--
-- Name: function_get_agent_data(text, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_get_agent_data(user_id_input text, account_id_param uuid) RETURNS TABLE(id uuid, name text, last_name text, user_image text, email text, role_id bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Consultamos directamente uniendo las tablas accounts, user_roles y contacts
    RETURN QUERY
    SELECT 
        c.id,
        c.name, 
        c.last_name, 
        c.user_image, 
        c.email, 
        ur.role_id
    FROM 
        public.contacts c
    JOIN 
        public.user_roles ur ON c.user_id = ur.user_id
    WHERE 
        c.user_id = (user_id_input::uuid)
        AND ur.account_id = account_id_param
        -- Verificamos que el contacto está relacionado con la cuenta específica
        AND c.account_id = account_id_param;
END;
$$;


--
-- Name: function_get_airlines(text, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_get_airlines(search text DEFAULT NULL::text, page_number integer DEFAULT 0, page_size integer DEFAULT 5) RETURNS TABLE(id uuid, name text, logo_lockup_url text, logo_symbol_url text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT a.id, a.name, a.logo_lockup_url, a.logo_symbol_url  -- Agregado logo_symbol_url
    FROM public.airlines a
    WHERE (search IS NULL OR search = '' OR a.name ILIKE '%' || search || '%')
    ORDER BY a.name
    LIMIT page_size OFFSET page_number * page_size;
END;
$$;


--
-- Name: function_get_airports(text, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_get_airports(search text DEFAULT NULL::text, page_size integer DEFAULT 10, page_number integer DEFAULT 0) RETURNS TABLE(name text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Retorna los registros de la vista filtrados por search, si se proporciona
    RETURN QUERY
    SELECT 
        a.name
    FROM public.airports_view a
    WHERE
        COALESCE(search, '') = '' OR a.name ILIKE '%' || COALESCE(search, '') || '%'
    ORDER BY a.name ASC
    LIMIT page_size OFFSET (page_number * page_size);
END;
$$;


--
-- Name: function_get_contact_with_location(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_get_contact_with_location(input_contact_id uuid) RETURNS TABLE(contact_id uuid, contact_name text, contact_last_name text, contact_email text, contact_phone text, contact_nationality text, contact_type_id text, contact_number_id text, contact_id_itinerary uuid, contact_birth_date date, contact_website text, contact_is_company boolean, contact_is_provider boolean, contact_phone2 text, contact_is_client boolean, contact_account_id uuid, location_id uuid, location_latlng text, location_name text, location_address text, location_city text, location_state text, location_country text, location_zip_code text, location_account_id uuid, contact_user_image text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.id AS contact_id,
        c.name AS contact_name,
        c.last_name AS contact_last_name,
        c.email AS contact_email,
        c.phone AS contact_phone,
        c.nationality AS contact_nationality,
        c.type_id AS contact_type_id,
        c.number_id AS contact_number_id,
        c.id_itinerary AS contact_id_itinerary,
        c.birth_date AS contact_birth_date,
        c.website AS contact_website,
        c.is_company AS contact_is_company,
        c.is_provider AS contact_is_provider,
        c.phone2 AS contact_phone2,
        c.is_client AS contact_is_client,
        c.account_id AS contact_account_id,
        l.id AS location_id,  -- Added to select the location ID
        l.latlng AS location_latlng,
        l.name AS location_name,
        l.address AS location_address,
        l.city AS location_city,
        l.state AS location_state,
        l.country AS location_country,
        l.zip_code AS location_zip_code,
        l.account_id AS location_account_id,
        c.user_image AS contact_user_image  -- Added to select the user image
    FROM 
        contacts c
    LEFT JOIN 
        locations l ON c.location = l.id
    WHERE 
        c.id = input_contact_id;  -- Updated to use the renamed parameter
END;
$$;


--
-- Name: function_get_contacts_related(uuid, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_get_contacts_related(contact_id uuid, page_number integer DEFAULT 0, page_size integer DEFAULT 10) RETURNS TABLE(id uuid, name text, last_name text, email text, phone text, phone2 text, is_company boolean, is_provider boolean, is_client boolean, user_image text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.id, 
        c.name, 
        c.last_name, 
        c.email, 
        c.phone, 
        c.phone2,  -- Incluir el nuevo campo en la selección
        c.is_company, 
        c.is_provider, 
        c.is_client, 
        c.user_image
    FROM 
        public.contacts c
    WHERE 
        c.id_related_contact = contact_id  -- Filtrar por el ID del contacto relacionado
    ORDER BY 
        c.updated_at DESC  -- Ordenar por fecha de actualización
    LIMIT page_size OFFSET page_number * page_size;  -- Aplicar paginación
END;
$$;


--
-- Name: function_get_contacts_search(text, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_get_contacts_search(search text, page_number integer DEFAULT 0, page_size integer DEFAULT 10) RETURNS TABLE(name text, last_name text, email text, phone text, is_company boolean, is_provider boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT c.name, c.last_name, c.email, c.phone, c.is_company, c.is_provider
    FROM public.contacts c
    WHERE (search IS NULL OR search = '' OR 
           c.name ILIKE '%' || search || '%' OR 
           c.last_name ILIKE '%' || search || '%' OR 
           c.email ILIKE '%' || search || '%' OR 
           c.phone ILIKE '%' || search || '%')
    ORDER BY c.updated_at DESC
    LIMIT page_size OFFSET page_number * page_size;
END;
$$;


--
-- Name: function_get_contacts_search(text, text, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_get_contacts_search(search text, type text DEFAULT 'all'::text, page_number integer DEFAULT 0, page_size integer DEFAULT 10) RETURNS TABLE(id uuid, name text, last_name text, email text, phone text, is_company boolean, is_provider boolean, is_client boolean, user_image text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT c.id, c.name, c.last_name, c.email, c.phone, c.is_company, c.is_provider, c.is_client, c.user_image
    FROM public.contacts c
    WHERE (type = 'all' OR 
           (type = 'provider' AND c.is_provider = true) OR 
           (type = 'client' AND c.is_client = true)) AND
          (search IS NULL OR search = '' OR 
           c.name ILIKE '%' || search || '%' OR 
           c.last_name ILIKE '%' || search || '%' OR 
           c.email ILIKE '%' || search || '%' OR 
           c.phone ILIKE '%' || search || '%')
    ORDER BY c.updated_at DESC
    LIMIT page_size OFFSET page_number * page_size;
END;
$$;


--
-- Name: function_get_images_and_main_image(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_get_images_and_main_image(p_id text) RETURNS TABLE(image_url text)
    LANGUAGE plpgsql
    AS $$BEGIN
    RETURN QUERY
    WITH main_image_data AS (
        SELECT 
            a.main_image AS main_image
        FROM 
            activities a
        WHERE 
            a.id::text = p_id
        UNION ALL
        SELECT 
            h.main_image AS main_image
        FROM 
            hotels h
        WHERE 
            h.id::text = p_id
        UNION ALL
        SELECT 
            t.main_image AS main_image
        FROM 
            transfers t
        WHERE 
            t.id::text = p_id
    ),
    image_data AS (
        SELECT 
            i.url AS image_url
        FROM 
            images i
        WHERE 
            i.entity_id::text = p_id
            AND NOT EXISTS (
                SELECT 1
                FROM main_image_data
                WHERE main_image_data.main_image = i.url
            )
    )
    -- Combina la imagen principal si existe y las adicionales
    SELECT 
        main_image_data.main_image AS image_url
    FROM 
        main_image_data
    WHERE 
        main_image_data.main_image IS NOT NULL
    UNION ALL
    SELECT 
        image_data.image_url AS image_url
    FROM 
        image_data;
END;$$;


--
-- Name: function_get_itineraries_with_contact_names(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_get_itineraries_with_contact_names() RETURNS TABLE(itinerary_id uuid, itinerary_name text, contact_name text, created_by_contact_name text, id_contact uuid, id_created_by uuid, start_date date, end_date date, status text, passenger_count numeric, currency_type text, valid_until timestamp with time zone, request_type text, total_amount numeric, total_cost numeric, agent text, total_provider_payment numeric, id_fm text, language text, total_hotels numeric, total_flights numeric, total_activities numeric, total_transfer numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        i.id AS itinerary_id,
        i.name AS itinerary_name,
        c.name AS contact_name,
        c_created.name AS created_by_contact_name,
        i.id_contact AS id_contact,
        i.id_created_by AS id_created_by,
        i.start_date,
        i.end_date,
        i.status,
        i.passenger_count,
        i.currency_type,
        i.valid_until,
        i.request_type,
        i.total_amount,
        i.total_cost,
        i.agent,
        i.total_provider_payment,
        i.id_fm,
        i.language,
        i.total_hotels,
        i.total_flights,
        i.total_activities,
        i.total_transfer
    FROM
        itineraries i
    LEFT JOIN
        contacts c ON i.id_contact = c.id
    LEFT JOIN
        contacts c_created ON i.id_created_by = c_created.user_id;
END;
$$;


--
-- Name: function_get_itineraries_with_contact_names_search(text, integer, integer, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_get_itineraries_with_contact_names_search(search text DEFAULT NULL::text, page_number integer DEFAULT 0, page_size integer DEFAULT 10, confirmados boolean DEFAULT false) RETURNS TABLE(itinerary_id uuid, itinerary_name text, contact_name text, created_by_contact_name text, id_contact uuid, id_created_by uuid, start_date date, end_date date, status text, passenger_count numeric, currency_type text, valid_until date, request_type text, total_amount numeric, total_cost numeric, agent text, total_provider_payment numeric, id_fm text, language text, total_hotels numeric, total_flights numeric, total_activities numeric, total_transfer numeric, updated_at timestamp with time zone, currency jsonb, user_image text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT DISTINCT
        i.id AS itinerary_id,
        i.name AS itinerary_name,
        c.name AS contact_name,
        c_created.name AS created_by_contact_name,
        i.id_contact AS id_contact,
        i.id_created_by AS id_created_by,
        i.start_date,
        i.end_date,
        i.status,
        i.passenger_count,
        i.currency_type,
        i.valid_until::date,  -- Asegurarse de que se seleccione como DATE
        i.request_type,
        i.total_amount,
        i.total_cost,
        i.agent,
        i.total_provider_payment,
        i.id_fm,
        i.language,
        i.total_hotels,
        i.total_flights,
        i.total_activities,
        i.total_transfer,
        i.updated_at,  -- Agregado para cumplir con la cláusula ORDER BY
        i.currency,  -- Incluir currency directamente sin convertir a un arreglo
        c_created.user_image  -- Cambiado para obtener user_image del creador
    FROM
        itineraries i
    LEFT JOIN
        contacts c ON i.id_contact = c.id
    LEFT JOIN
        contacts c_created ON i.id_created_by = c_created.user_id
    WHERE
        (search IS NULL OR search = '' OR 
         i.name ILIKE '%' || search || '%' OR 
         i.id_fm ILIKE '%' || search || '%' OR
         c.name ILIKE '%' || search || '%')  -- Agregado para buscar por el nombre del contacto
        AND (NOT confirmados OR (confirmados AND i.status = 'Confirmado'))  -- Condición para el campo confirmados
    ORDER BY
        i.updated_at DESC
    LIMIT page_size OFFSET page_number * page_size;
END;
$$;


--
-- Name: function_get_itineraries_with_id(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_get_itineraries_with_id(itinerary_id uuid) RETURNS TABLE(itinerary_name text, contact_name text, created_by_contact_name text, id_contact uuid, id_created_by uuid, start_date date, end_date date, status text, passenger_count numeric, currency_type text, valid_until timestamp with time zone, request_type text, total_amount numeric, total_paid numeric, total_cost numeric, agent text, total_provider_payment numeric, id_fm text, language text, total_hotels numeric, total_flights numeric, total_activities numeric, total_transfer numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        i.name AS itinerary_name,
        c.name AS contact_name,
        c_created.name AS created_by_contact_name,
        i.id_contact AS id_contact,
        i.id_created_by AS id_created_by,
        i.start_date,
        i.end_date,
        i.status,
        i.passenger_count,
        i.currency_type,
        i.valid_until,
        i.request_type,
        i.total_amount,
        i.total_paid,
        i.total_cost,
        i.agent,
        i.total_provider_payment,
        i.id_fm,
        i.language,
        i.total_hotels,      -- Nuevo campo
        i.total_flights,     -- Nuevo campo
        i.total_activities,  -- Nuevo campo
        i.total_transfer      -- Nuevo campo
    FROM
        itineraries i
    LEFT JOIN
        contacts c ON i.id_contact = c.id
    LEFT JOIN
        contacts c_created ON i.id_created_by = c_created.user_id
    WHERE
        i.id = itinerary_id;  -- Filtrar por el ID del itinerario proporcionado

    -- Manejo de caso donde no se encuentra el itinerario
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Itinerary with ID % not found', itinerary_id;
    END IF;
END;
$$;


--
-- Name: function_get_itinerary_details(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_get_itinerary_details(itinerary_id uuid) RETURNS TABLE(id uuid, id_created_by uuid, name text, start_date date, end_date date, status text, id_contact uuid, passenger_count numeric, currency_type text, valid_until date, request_type text, total_amount numeric, total_markup numeric, total_cost numeric, agent text, total_provider_payment numeric, id_fm text, language text, account_id uuid, total_hotels numeric, total_flights numeric, total_activities numeric, total_transfer numeric, travel_planner_name text, travel_planner_last_name text, travel_planner_user_image text, travel_planner_email text, contact_name text, contact_lastname text, paid numeric, pending_paid numeric, currency jsonb, itinerary_visibility boolean, rates_visibility boolean, types_increase jsonb, personalized_message text, main_image text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        i.id,
        i.id_created_by,
        i.name,
        i.start_date,
        i.end_date,
        i.status,
        i.id_contact,
        i.passenger_count,
        i.currency_type,
        i.valid_until::date,
        i.request_type,
        i.total_amount,
        i.total_markup,
        i.total_cost,
        i.agent,
        i.total_provider_payment,
        i.id_fm,
        i.language,
        i.account_id,
        i.total_hotels,
        i.total_flights,
        i.total_activities,
        i.total_transfer,
        tp.name AS travel_planner_name,
        tp.last_name AS travel_planner_last_name,
        tp.user_image AS travel_planner_user_image,
        tp.email AS travel_planner_email,
        c.name AS contact_name,
        c.last_name AS contact_lastname,  -- Se agregó el campo last_name de contacts
        i.paid,
        i.pending_paid,
        i.currency,
        i.itinerary_visibility,
        i.rates_visibility,
        i.types_increase,
        i.personalized_message,
        i.main_image  -- Añadido main_image al SELECT
    FROM 
        itineraries i
    LEFT JOIN 
        contacts tp ON i.id_created_by = tp.user_id
    LEFT JOIN 
        contacts c ON i.id_contact = c.id
    WHERE 
        i.id = itinerary_id;
END;
$$;


--
-- Name: function_get_itinerary_id_by_id_fm(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_get_itinerary_id_by_id_fm(id_fm text) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    itinerary_id uuid;
BEGIN
    -- Buscar el id en la tabla itineraries donde coincida el id_fm
    SELECT i.id INTO itinerary_id
    FROM itineraries i
    WHERE i.id_fm = id_fm;

    -- Retornar el id encontrado o NULL si no se encuentra
    RETURN itinerary_id;
END;
$$;


--
-- Name: function_get_locations_products(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_get_locations_products(p_type text) RETURNS SETOF text
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT DISTINCT locations.city
    FROM locations
    WHERE locations.type_entity = p_type
      AND locations.city IS NOT NULL
      AND locations.city <> ''
    ORDER BY locations.city;
END;
$$;


--
-- Name: function_get_passengers_itinerary(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_get_passengers_itinerary(id_itinerary text) RETURNS text
    LANGUAGE plpgsql
    AS $$DECLARE
    result_text text := '<br>';  -- Agrega un salto de línea inicial con HTML
    record record;
BEGIN
    FOR record IN
        SELECT p.name, p.last_name, p.type_id, p.number_id::text, p.birth_date
        FROM public.passenger p
        WHERE p.itinerary_id = id_itinerary::uuid  
    LOOP
        result_text := result_text || 
            'Nombre: ' || record.name || ' ' || record.last_name || '<br>' ||
            'ID: ' || COALESCE(record.type_id, 'N/A') || ' ' || COALESCE(record.number_id, 'N/A') || '<br>' ||
            'Fecha de nacimiento: ' || COALESCE(record.birth_date::text, 'N/A') || '<br><br>';  -- Dos <br> entre registros
    END LOOP;

    RETURN result_text || '<br>';  -- Dos <br> al final para más espacio
END;$$;


--
-- Name: function_get_product_rates(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_get_product_rates(product_id text, typeproduct text) RETURNS TABLE(id uuid, name text, unit_cost numeric, profit numeric, price numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF typeproduct = 'activities' THEN
        RETURN QUERY
        SELECT ar.id, ar.name, ar.unit_cost, ar.profit, ar.price
        FROM public.activities_rates ar
        JOIN public.activities a ON ar.id_product = a.id
        WHERE ar.id_product = product_id::uuid
        ORDER BY ar.updated_at DESC;

    ELSIF typeproduct = 'hotels' THEN
        RETURN QUERY
        SELECT hr.id, hr.name, hr.unit_cost, hr.profit, hr.price
        FROM public.hotel_rates hr
        JOIN public.hotels h ON hr.hotel_id = h.id
        WHERE hr.hotel_id = product_id::uuid
        ORDER BY hr.updated_at DESC;

    ELSIF typeproduct = 'transfers' THEN
        RETURN QUERY
        SELECT tr.id, tr.name, tr.unit_cost, tr.profit, tr.price
        FROM public.transfer_rates tr
        JOIN public.transfers t ON tr.id_transfer = t.id
        WHERE tr.id_transfer = product_id::uuid
        ORDER BY tr.updated_at DESC;

    ELSE
        RAISE EXCEPTION 'Invalid typeproduct: %', typeproduct;
    END IF;
END;
$$;


--
-- Name: function_get_products_by_type_location_search(text, text, text, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_get_products_by_type_location_search(type text, search text DEFAULT NULL::text, location_param text DEFAULT NULL::text, page_size integer DEFAULT 10, page_number integer DEFAULT 0) RETURNS TABLE(id uuid, name text, description text, description_short text, main_image text)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    -- Validar que el parámetro 'type' no sea NULL
    IF type IS NULL OR type = '' THEN
        RAISE EXCEPTION 'The "type" parameter is required.';
    END IF;

    -- Validar que el tipo sea válido
    IF type NOT IN ('hotels', 'activities', 'transfers') THEN
        RAISE EXCEPTION 'Invalid type: %. Valid types are "hotels", "activities", "transfers".', type;
    END IF;

    -- Normalizar parámetros
    search := COALESCE(search, '');
    location_param := COALESCE(location_param, '');

    -- Si location_param es vacío o nulo, no consultar la tabla locations
    IF location_param = '' THEN
        RETURN QUERY EXECUTE format('
            SELECT t.id, t.name, t.description, t.description_short, t.main_image
            FROM public.%I t
            WHERE ($1 = '''' OR 
                   t.name ILIKE ''%%'' || $1 || ''%%'' OR 
                   t.description ILIKE ''%%'' || $1 || ''%%'' OR 
                   t.description_short ILIKE ''%%'' || $1 || ''%%'')
            ORDER BY t.updated_at DESC
            LIMIT $2 OFFSET $3',
            type
        )
        USING search, page_size, page_number * page_size;
    ELSE
        -- Si location_param tiene valor, consultar la tabla locations
        RETURN QUERY EXECUTE format('
            SELECT t.id, t.name, t.description, t.description_short, t.main_image
            FROM public.%I t
            LEFT JOIN public.locations l ON t.location = l.id
            WHERE (l.city ILIKE ''%%'' || $1 || ''%%'') AND
                  ($2 = '''' OR 
                   t.name ILIKE ''%%'' || $2 || ''%%'' OR 
                   t.description ILIKE ''%%'' || $2 || ''%%'' OR 
                   t.description_short ILIKE ''%%'' || $2 || ''%%'')
            ORDER BY t.updated_at DESC
            LIMIT $3 OFFSET $4',
            type
        )
        USING location_param, search, page_size, page_number * page_size;
    END IF;
END;
$_$;


--
-- Name: function_get_products_by_type_search(text, text, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_get_products_by_type_search(type text, search text DEFAULT NULL::text, page_size integer DEFAULT 10, page_number integer DEFAULT 0) RETURNS TABLE(id uuid, name text, description text, description_short text, main_image text)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    -- Validar que el parámetro 'type' no sea NULL
    IF type IS NULL OR type = '' THEN
        RAISE EXCEPTION 'The "type" parameter is required.';
    END IF;

    -- Validar que el tipo sea válido
    IF type NOT IN ('hotels', 'activities', 'transfers') THEN
        RAISE EXCEPTION 'Invalid type: %. Valid types are "hotels", "activities", "transfers".', type;
    END IF;

    -- Normalizar parámetros
    search := COALESCE(search, '');

    -- Consultar la tabla correspondiente al 'type'
    RETURN QUERY EXECUTE format('
        SELECT t.id, t.name, t.description, t.description_short, t.main_image
        FROM public.%I t
        WHERE ($1 = '''' OR 
               t.name ILIKE ''%%'' || $1 || ''%%'' OR 
               t.description ILIKE ''%%'' || $1 || ''%%'' OR 
               t.description_short ILIKE ''%%'' || $1 || ''%%'')
        ORDER BY t.updated_at DESC
        LIMIT $2 OFFSET $3',
        type
    )
    USING search, page_size, page_number * page_size;
END;
$_$;


--
-- Name: function_get_products_from_tables(text, text, text, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_get_products_from_tables(type text DEFAULT NULL::text, search text DEFAULT NULL::text, location_param text DEFAULT NULL::text, page_size integer DEFAULT 10, page_number integer DEFAULT 0) RETURNS TABLE(id uuid, name text, description text, description_short text, main_image text, city text, inclutions text, exclutions text, recomendations text, instructions text, social_image text, name_provider text)
    LANGUAGE plpgsql
    AS $$BEGIN
    IF type = 'activities' THEN
        RETURN QUERY
        SELECT a.id,
               a.name,
               a.description,
               a.description_short,
               a.main_image,
               l.city AS city,
               a.inclutions,
               a.exclutions,
               a.recomendations,
               a.instructions,
               a.social_image,  -- Agregado social_image aquí
               c.name AS name_provider
        FROM public.activities a
        LEFT JOIN public.locations l ON a.location = l.id
        LEFT JOIN public.contacts c ON a.id_contact = c.id
        WHERE (COALESCE(search, '') = '' OR 
               a.name ILIKE '%' || COALESCE(search, '') || '%' OR 
               a.description ILIKE '%' || COALESCE(search, '') || '%' OR 
               a.description_short ILIKE '%' || COALESCE(search, '') || '%' OR 
               l.city ILIKE '%' || COALESCE(search, '') || '%'  OR
               c.name ILIKE '%' || COALESCE(search, '') || '%') 
          AND (COALESCE(location_param, '') = '' OR l.city ILIKE '%' || COALESCE(location_param, '') || '%')  
          AND a.account_id = '9fc24733-b127-4184-aa22-12f03b98927a'
        ORDER BY a.updated_at DESC
        LIMIT page_size OFFSET (page_number * page_size);

    ELSIF type = 'hotels' THEN
        RETURN QUERY
        SELECT h.id,
               h.name,
               h.description,
               h.description_short,
               h.main_image,
               l.city AS city,
               h.inclutions,
               h.exclutions,
               h.recomendations,
               h.instructions,
               h.social_image,  -- Agregado social_image aquí
               c.name AS name_provider
        FROM public.hotels h
        LEFT JOIN public.locations l ON h.location = l.id
        LEFT JOIN public.contacts c ON h.id_contact = c.id
        WHERE (COALESCE(search, '') = '' OR 
               h.name ILIKE '%' || COALESCE(search, '') || '%' OR 
               h.description ILIKE '%' || COALESCE(search, '') || '%' OR 
               h.description_short ILIKE '%' || COALESCE(search, '') || '%' OR 
               l.city ILIKE '%' || COALESCE(search, '') || '%' OR
               c.name ILIKE '%' || COALESCE(search, '') || '%') 
          AND (COALESCE(location_param, '') = '' OR l.city ILIKE '%' || COALESCE(location_param, '') || '%')  
          AND h.account_id = '9fc24733-b127-4184-aa22-12f03b98927a'
        ORDER BY h.updated_at DESC
        LIMIT page_size OFFSET (page_number * page_size);

    ELSE
        RAISE EXCEPTION 'Invalid type: %. Expected values: activities, hotels.', type;
    END IF;
END;$$;


--
-- Name: function_get_products_from_views(text, text, text, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_get_products_from_views(type text DEFAULT NULL::text, search text DEFAULT NULL::text, location text DEFAULT NULL::text, page_size integer DEFAULT 10, page_number integer DEFAULT 0) RETURNS TABLE(id uuid, name text, description text, description_short text, main_image text, city text, inclutions text, exclutions text, recomendations text, instructions text, name_provider text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF type = 'activities' THEN
        RETURN QUERY
        SELECT 
            a.id, 
            a.name, 
            a.description, 
            a.description_short, 
            a.main_image, 
            a.city, 
            a.inclutions, 
            a.exclutions, 
            a.recomendations, 
            a.instructions,
            a.name_provider  -- Agregando name_provider de activities_view
        FROM public.activities_view a
        WHERE
            (
                (COALESCE(search, '') = '' OR 
                a.name ILIKE '%' || COALESCE(search, '') || '%' OR 
                a.description ILIKE '%' || COALESCE(search, '') || '%' OR 
                a.city ILIKE '%' || COALESCE(search, '') || '%' OR
                a.name_provider ILIKE '%' || COALESCE(search, '') || '%')  -- Agregando búsqueda en name_provider
                AND (COALESCE(location, '') = '' OR a.city ILIKE '%' || COALESCE(location, '') || '%')
            )
        ORDER BY a.updated_at DESC
        LIMIT page_size OFFSET (page_number * page_size);
    ELSIF type = 'hotels' THEN
        RETURN QUERY
        SELECT 
            h.id, 
            h.name, 
            h.description, 
            h.description_short, 
            h.main_image, 
            h.city, 
            h.inclutions, 
            h.exclutions, 
            h.recomendations, 
            h.instructions,
            h.name_provider  -- Agregando name_provider de hotels_view
        FROM public.hotels_view h
        WHERE
            (
                (COALESCE(search, '') = '' OR 
                h.name ILIKE '%' || COALESCE(search, '') || '%' OR 
                h.description ILIKE '%' || COALESCE(search, '') || '%' OR 
                h.city ILIKE '%' || COALESCE(search, '') || '%' OR
                h.name_provider ILIKE '%' || COALESCE(search, '') || '%')  -- Agregando búsqueda en name_provider
                AND (COALESCE(location, '') = '' OR h.city ILIKE '%' || COALESCE(location, '') || '%')
            )
        ORDER BY h.updated_at DESC
        LIMIT page_size OFFSET (page_number * page_size);
    ELSIF type = 'transfers' THEN
        RETURN QUERY
        SELECT 
            t.id, 
            t.name, 
            t.description, 
            t.description_short, 
            t.main_image, 
            t.city, 
            t.inclutions, 
            t.exclutions, 
            t.recomendations, 
            t.instructions,
            t.name_provider  -- Agregando name_provider de transfers_view
        FROM public.transfers_view t
        WHERE
            (
                (COALESCE(search, '') = '' OR 
                t.name ILIKE '%' || COALESCE(search, '') || '%' OR 
                t.description ILIKE '%' || COALESCE(search, '') || '%' OR 
                t.city ILIKE '%' || COALESCE(search, '') || '%' OR
                t.name_provider ILIKE '%' || COALESCE(search, '') || '%')  -- Agregando búsqueda en name_provider
                AND (COALESCE(location, '') = '' OR t.city ILIKE '%' || COALESCE(location, '') || '%')
            )
        ORDER BY t.updated_at DESC
        LIMIT page_size OFFSET (page_number * page_size);
    ELSE
        RAISE EXCEPTION 'Invalid type: %. Expected values: activities, hotels, transfers.', type;
    END IF;
END;
$$;


--
-- Name: function_get_products_itinerary_items(uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_get_products_itinerary_items(p_id_itinerary uuid, p_product_type text) RETURNS TABLE(id uuid, id_itinerary uuid, start_time timestamp with time zone, end_time timestamp with time zone, day_number integer, "order" integer, created_at timestamp with time zone, updated_at timestamp with time zone, unit_cost numeric, quantity numeric, total_cost numeric, date date, destination text, product_name text, rate_name text, product_type text, hotel_nights integer, profit_percentage numeric, profit numeric, total_price numeric, flight_departure text, flight_arrival text, departure_time text, arrival_time text, flight_number text, airline uuid, unit_price numeric, id_product uuid, account_id uuid, logo_symbol_url text, main_image text, name_provider text, personalized_message text)
    LANGUAGE plpgsql
    AS $$BEGIN
    RETURN QUERY
    SELECT 
        ii.id,
        ii.id_itinerary,
        ii.start_time,
        ii.end_time,
        ii.day_number,
        ii."order",
        ii.created_at,
        ii.updated_at,
        ii.unit_cost,
        ii.quantity,
        ii.total_cost,
        ii.date,
        ii.destination,
        ii.product_name,
        ii.rate_name,
        ii.product_type,
        ii.hotel_nights,
        ii.profit_percentage,
        ii.profit,
        ii.total_price,
        ii.flight_departure,
        ii.flight_arrival,
        ii.departure_time,
        ii.arrival_time,
        ii.flight_number,
        ii.airline,
        ii.unit_price,
        ii.id_product,
        ii.account_id,
        a.logo_symbol_url,
        CASE 
            WHEN ii.product_type = 'Hoteles' THEN (SELECT h.main_image FROM public.hotels h WHERE h.id = ii.id_product)
            WHEN ii.product_type = 'Servicios' THEN (SELECT a.main_image FROM public.activities a WHERE a.id = ii.id_product)
            WHEN ii.product_type = 'Transporte' THEN (SELECT t.main_image FROM public.transfers t WHERE t.id = ii.id_product)
            ELSE NULL
        END AS main_image,  -- Subconsulta para obtener el main_image según el tipo de producto
        CASE 
            WHEN ii.product_type = 'Hoteles' THEN (SELECT c.name FROM public.hotels h JOIN public.contacts c ON h.id_contact = c.id WHERE h.id = ii.id_product)
            WHEN ii.product_type = 'Servicios' THEN (SELECT c.name FROM public.activities a JOIN public.contacts c ON a.id_contact = c.id WHERE a.id = ii.id_product)
            WHEN ii.product_type = 'Transporte' THEN (SELECT c.name FROM public.transfers t JOIN public.contacts c ON t.id_contact = c.id WHERE t.id = ii.id_product)
            ELSE NULL
        END AS name_provider,  -- Subconsulta para obtener el name_provider según el tipo de producto
        ii.personalized_message  -- Added personalized_message to the SELECT statement
    FROM 
        public.itinerary_items ii
    LEFT JOIN 
        public.airlines a ON ii.airline = a.id
    WHERE 
        ii.id_itinerary = p_id_itinerary
        AND ii.product_type = p_product_type
    ORDER BY 
        ii.date ASC;
END;$$;


--
-- Name: function_get_products_paginated(text, text, text, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_get_products_paginated(searchterm text, location_param text, typeproduct text, page_size integer, page_number integer) RETURNS TABLE(id uuid, name text, description text, description_short text, location text, created_at timestamp with time zone, updated_at timestamp with time zone, main_image text)
    LANGUAGE plpgsql
    AS $_$
DECLARE
    query TEXT;
BEGIN
    IF typeProduct = 'activities' THEN
        query := 'SELECT a.id, a.name, a.description, a.description_short, a.location, a.created_at, a.updated_at, a.main_image
                  FROM public.activities a
                  WHERE 
                      (COALESCE($1, '''') = '''' OR 
                       a.name ILIKE ''%'' || COALESCE($1, '''') || ''%'' OR 
                       a.description ILIKE ''%'' || COALESCE($1, '''') || ''%'' OR 
                       a.description_short ILIKE ''%'' || COALESCE($1, '''') || ''%'')
                      AND 
                      (COALESCE($2, '''') = '''' OR 
                       a.location ILIKE ''%'' || COALESCE($2, '''') || ''%'')
                  ORDER BY a.created_at DESC
                  LIMIT $3 OFFSET $4;';

    ELSIF typeProduct = 'hotels' THEN
        query := 'SELECT h.id, h.name, h.description, h.description_short, h.address AS location, h.created_at, h.updated_at, h.main_image
                  FROM public.hotels h
                  WHERE 
                      (COALESCE($1, '''') = '''' OR 
                       h.name ILIKE ''%'' || COALESCE($1, '''') || ''%'' OR 
                       h.description ILIKE ''%'' || COALESCE($1, '''') || ''%'' OR 
                       h.description_short ILIKE ''%'' || COALESCE($1, '''') || ''%'')
                      AND 
                      (COALESCE($2, '''') = '''' OR 
                       h.address ILIKE ''%'' || COALESCE($2, '''') || ''%'')
                  ORDER BY h.created_at DESC
                  LIMIT $3 OFFSET $4;';

    ELSIF typeProduct = 'transfers' THEN
        query := 'SELECT t.id, t.name, t.description, t.description_short, t.location, t.created_at, t.updated_at, t.main_image
                  FROM public.transfers t
                  WHERE 
                      (COALESCE($1, '''') = '''' OR 
                       t.name ILIKE ''%'' || COALESCE($1, '''') || ''%'' OR 
                       t.description ILIKE ''%'' || COALESCE($1, '''') || ''%'' OR 
                       t.description_short ILIKE ''%'' || COALESCE($1, '''') || ''%'')
                      AND 
                      (COALESCE($2, '''') = '''' OR 
                       t.location ILIKE ''%'' || COALESCE($2, '''') || ''%'')
                  ORDER BY t.created_at DESC
                  LIMIT $3 OFFSET $4;';

    ELSE
        RAISE EXCEPTION 'Tipo de producto no soportado';
    END IF;

    RETURN QUERY EXECUTE query USING searchTerm, location_param, page_size, (page_number) * page_size;
END;
$_$;


--
-- Name: function_get_provider_payments(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_get_provider_payments(p_id_item_itinerary uuid) RETURNS TABLE(transaction_date date, transaction_value numeric, transaction_payment_method text, transaction_voucher_url text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT date, value AS transaction_value, payment_method AS transaction_payment_method, voucher_url AS transaction_voucher_url
    FROM transactions
    WHERE id_item_itinerary = p_id_item_itinerary
    ORDER BY created_at DESC;
END;
$$;


--
-- Name: function_get_user_by_email(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_get_user_by_email(p_email text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  RETURN (
    SELECT json_build_object(
      'id', id,
      'email', email,
      'created_at', created_at
    )
    FROM auth.users
    WHERE email = p_email
    LIMIT 1
  );
END;
$$;


--
-- Name: function_get_user_roles_for_authenticated_user(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_get_user_roles_for_authenticated_user() RETURNS TABLE(user_role_id bigint, role_name text, account_id uuid, contact_name text, contact_email text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        user_roles.id AS user_role_id, 
        roles.role_name, 
        user_roles.account_id, 
        contacts.name AS contact_name, 
        contacts.email AS contact_email
    FROM public.user_roles
    JOIN public.roles ON user_roles.role_id = roles.id
    JOIN public.contacts ON contacts.user_id = user_roles.user_id
    WHERE user_roles.account_id = (SELECT user_roles.account_id
                                    FROM user_roles
                                    WHERE user_roles.user_id = auth.uid()
                                    LIMIT 1);
END;
$$;


--
-- Name: function_insert_location(text, text, text, text, text, text, text, uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_insert_location(latlng text, name text, address text, city text, state text, country text, zip_code text, account_id uuid, type_entity text) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    new_location_id uuid;
BEGIN
    -- Insertar el nuevo registro en la tabla locations
    INSERT INTO locations (latlng, name, address, city, state, country, zip_code, account_id, type_entity)
    VALUES (latlng, name, address, city, state, country, zip_code, account_id, type_entity)
    RETURNING id INTO new_location_id;

    -- Retornar el id del nuevo registro
    RETURN new_location_id;
END;
$$;


--
-- Name: function_reporte_ventas(text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_reporte_ventas(search text DEFAULT NULL::text, fecha_inicial text DEFAULT NULL::text, fecha_final text DEFAULT NULL::text) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$DECLARE
    result jsonb;
    fecha_inicial_date date;
    fecha_final_date date;
BEGIN
    -- Establecer fechas por defecto si no se proporcionan
    IF fecha_inicial = '' THEN
        fecha_inicial := NULL;
    END IF;

    IF fecha_final = '' THEN
        fecha_final := NULL;
    END IF;

    -- Si no se proporcionan fechas, establecer el rango del último mes
    IF fecha_inicial IS NULL AND fecha_final IS NULL THEN
        fecha_inicial_date := CURRENT_DATE - INTERVAL '1 month';  -- Un mes atrás desde hoy
        fecha_final_date := CURRENT_DATE;  -- Hoy
    ELSE
        -- Convertir las fechas de texto a tipo date
        fecha_inicial_date := fecha_inicial::date;
        fecha_final_date := fecha_final::date;
    END IF;

    SELECT jsonb_build_object(
        'total_amount', COALESCE(SUM(agent_data.total_amount), 0),
        'total_markup', COALESCE(SUM(agent_data.total_markup), 0),
        'agents', COALESCE(jsonb_agg(agent_data), jsonb_build_array())
    ) INTO result
    FROM (
        SELECT 
            c_agent.name AS contact_name,
            c_agent.last_name AS contact_last_name,
            c_agent.email AS contact_email,
            SUM(i.total_amount) AS total_amount,
            SUM(i.total_markup) AS total_markup,
            jsonb_agg(jsonb_build_object(
                'id_fm', i.id_fm,
                'created_at', i.created_at,
                'confirmation_date', i.confirmation_date,  -- Agregado para mostrar fecha de confirmación
                'total_amount', i.total_amount,
                'total_markup', i.total_markup,
                'client_name', c_client.name
            ) ORDER BY i.confirmation_date DESC) AS items
        FROM 
            public.itineraries i
        JOIN 
            public.contacts c_agent ON i.id_created_by = c_agent.user_id
        JOIN 
            public.contacts c_client ON i.id_contact = c_client.id
        WHERE 
            i.status = 'Confirmado'
            AND i.confirmation_date BETWEEN fecha_inicial_date AND fecha_final_date  -- Cambiado a confirmation_date
            AND (search IS NULL OR c_agent.name ILIKE '%' || search || '%')
        GROUP BY 
            c_agent.name, c_agent.last_name, c_agent.email
    ) AS agent_data;

    -- Si no se encontraron resultados, devolver un JSON con totales como 0 y un array vacío para agentes
    IF result IS NULL THEN
        RETURN jsonb_build_object('total_amount', 0, 'total_markup', 0, 'agents', jsonb_build_array());  -- Retornar un objeto con totales y un array vacío
    END IF;

    RETURN result;
END;$$;


--
-- Name: function_search_products(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_search_products(type text, search text) RETURNS TABLE(id uuid, name text, updated_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $$BEGIN
    IF type = 'hotels' THEN
        RETURN QUERY
        SELECT h.id, h.name, h.updated_at FROM hotels h
        WHERE (search IS NULL OR search = '' OR h.name ILIKE '%' || search || '%')
        ORDER BY h.updated_at DESC;
    ELSE
        RAISE EXCEPTION 'Invalid type: %', type;
    END IF;
END;$$;


--
-- Name: function_test_products(text, text, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_test_products(type text DEFAULT NULL::text, search text DEFAULT NULL::text, page_size integer DEFAULT 10, page_number integer DEFAULT 0) RETURNS TABLE(id uuid, name text, description text, description_short text, main_image text, city text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF type = 'activities' THEN
        RETURN QUERY
        SELECT a.id, a.name, a.description, a.description_short, a.main_image, a.city
        FROM public.activities_view a
        WHERE
            (
                COALESCE(search, '') = '' OR 
                a.name ILIKE '%' || COALESCE(search, '') || '%' OR 
                a.description ILIKE '%' || COALESCE(search, '') || '%' OR 
                a.city ILIKE '%' || COALESCE(search, '') || '%'
            )
        ORDER BY a.updated_at DESC
        LIMIT page_size OFFSET (page_number * page_size);
    ELSIF type = 'hotels' THEN
        RETURN QUERY
        SELECT h.id, h.name, h.description, h.description_short, h.main_image, h.city
        FROM public.hotels_view h
        WHERE
            (
                COALESCE(search, '') = '' OR 
                h.name ILIKE '%' || COALESCE(search, '') || '%' OR 
                h.description ILIKE '%' || COALESCE(search, '') || '%' OR 
                h.city ILIKE '%' || COALESCE(search, '') || '%'
            )
        ORDER BY h.updated_at DESC
        LIMIT page_size OFFSET (page_number * page_size);
    ELSIF type = 'transfers' THEN
        RETURN QUERY
        SELECT t.id, t.name, t.description, t.description_short, t.main_image, t.city
        FROM public.transfers_view t
        WHERE
            (
                COALESCE(search, '') = '' OR 
                t.name ILIKE '%' || COALESCE(search, '') || '%' OR 
                t.description ILIKE '%' || COALESCE(search, '') || '%' OR 
                t.city ILIKE '%' || COALESCE(search, '') || '%'
            )
        ORDER BY t.updated_at DESC
        LIMIT page_size OFFSET (page_number * page_size);
    ELSE
        RAISE EXCEPTION 'Invalid type: %. Expected values: activities, hotels, transfers.', type;
    END IF;
END;
$$;


--
-- Name: function_test_productstres(text, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_test_productstres(location_param text DEFAULT NULL::text, page_size integer DEFAULT 10, page_number integer DEFAULT 0) RETURNS TABLE(name text, description text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT a.name, a.description
    FROM public.activities_filtered_view a
    WHERE
        (
            COALESCE(location_param, '') = '' OR 
            a.city ILIKE '%' || COALESCE(location_param, '') || '%'
        )
    ORDER BY a.updated_at DESC
    LIMIT page_size OFFSET (page_number * page_size);
END;
$$;


--
-- Name: function_update_activity(text, text, text, text, text, text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_update_activity(id text, p_name text, p_description text, p_experience_type text, p_location text, p_inclutions text, p_exclutions text, p_recomendations text, p_instructions text, p_id_contact text) RETURNS TABLE(received_id text, received_name text, received_description text, received_experience_type text, received_location text, received_inclutions text, received_exclutions text, received_recomendations text, received_instructions text, received_id_contact text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id uuid;
    v_id_contact uuid;
BEGIN
    -- Convertir el id de text a uuid
    v_id := id::uuid;

    -- Convertir el id_contact de text a uuid, si no es vacío
    v_id_contact := NULLIF(p_id_contact, '')::uuid;

    -- Actualizar la actividad en la tabla activities
    UPDATE public.activities
    SET
        name = COALESCE(NULLIF(p_name, ''), public.activities.name),
        description = COALESCE(NULLIF(p_description, ''), public.activities.description),
        experience_type = COALESCE(NULLIF(p_experience_type, ''), public.activities.experience_type),
        location = COALESCE(NULLIF(p_location, ''), public.activities.location),
        inclutions = COALESCE(NULLIF(p_inclutions, ''), public.activities.inclutions),
        exclutions = COALESCE(NULLIF(p_exclutions, ''), public.activities.exclutions),
        recomendations = COALESCE(NULLIF(p_recomendations, ''), public.activities.recomendations),
        instructions = COALESCE(NULLIF(p_instructions, ''), public.activities.instructions),
        id_contact = COALESCE(v_id_contact, public.activities.id_contact)  -- Usar el valor convertido
    WHERE public.activities.id = v_id;

    -- Retornar los valores recibidos
    RETURN QUERY SELECT
        id,
        p_name,
        p_description,
        p_experience_type,
        p_location,
        p_inclutions,
        p_exclutions,
        p_recomendations,
        p_instructions,
        p_id_contact;
END;
$$;


--
-- Name: function_update_activity_rate(uuid, text, numeric, numeric); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_update_activity_rate(p_id uuid, p_name text, p_unit_cost numeric, p_price numeric) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_profit numeric;
BEGIN
    -- Calcular el profit como porcentaje y redondear a un decimal
    IF p_unit_cost > 0 THEN
        v_profit := ROUND(((p_price - p_unit_cost) / p_unit_cost) * 100, 1);
    ELSE
        v_profit := 0; -- Evitar división por cero
    END IF;

    -- Actualizar el registro en la tabla activities_rates
    UPDATE public.activities_rates
    SET 
        name = p_name,
        unit_cost = p_unit_cost,
        profit = v_profit,
        price = p_price,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_id;
END;
$$;


--
-- Name: function_update_hotel_descriptions_batch(integer, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_update_hotel_descriptions_batch(batch_size integer DEFAULT 10, only_null_descriptions boolean DEFAULT true) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  hotels_to_process UUID[];
  result JSONB := jsonb_build_object('success', 0, 'error', 0, 'skipped', 0, 'processed_ids', '{}');
  edge_function_url TEXT := 'https://wzlxbpicdcdvxvdcvgas.supabase.co/functions/v1/hotel-description-generator';
  hotel_id UUID;
  api_response JSONB;
  response_status INTEGER;
  success_count INTEGER := 0;
  error_count INTEGER := 0;
  skipped_count INTEGER := 0;
  processed_ids JSONB := '[]';
BEGIN
  -- Fetch hotels for processing with consistent ordering
  IF only_null_descriptions THEN
    -- Only process hotels that don't have a short description
    SELECT array_agg(id)
    INTO hotels_to_process
    FROM public.hotels
    WHERE description_short IS NULL 
      AND description IS NOT NULL
      AND description != ''
    ORDER BY created_at  -- Added ordering to get consistent results
    LIMIT batch_size;
  ELSE
    -- Process all hotels that have a description
    SELECT array_agg(id)
    INTO hotels_to_process
    FROM public.hotels
    WHERE description IS NOT NULL
      AND description != ''
    ORDER BY created_at  -- Added ordering to get consistent results
    LIMIT batch_size;
  END IF;

  -- Rest of the function remains the same...
  -- Check if we found any hotels to process
  IF hotels_to_process IS NULL OR array_length(hotels_to_process, 1) IS NULL THEN
    RETURN jsonb_build_object('status', 'No hotels found for processing');
  END IF;

  -- Process each hotel in the batch
  FOREACH hotel_id IN ARRAY hotels_to_process
  LOOP
    BEGIN
      -- Call the edge function to generate the description
      SELECT 
        status, 
        content::jsonb
      INTO 
        response_status, 
        api_response
      FROM http((
        'POST',
        edge_function_url,
        ARRAY[
          ('Content-Type', 'application/json'),
          ('Authorization', 'Bearer ' || current_setting('supabase.service_key', true))
        ]::extensions.http_header[],
        jsonb_build_object('hotelId', hotel_id)::text,
        NULL
      )::record);

      -- Check response status
      IF response_status >= 200 AND response_status < 300 AND api_response->>'success' = 'true' THEN
        success_count := success_count + 1;
        processed_ids := processed_ids || to_jsonb(hotel_id);
      ELSE
        error_count := error_count + 1;
        RAISE NOTICE 'Error processing hotel %. Response: %', hotel_id, api_response;
      END IF;

    EXCEPTION WHEN others THEN
      -- Handle errors safely - log error but continue processing the batch
      error_count := error_count + 1;
      RAISE NOTICE 'Exception processing hotel %: %', hotel_id, SQLERRM;
    END;

    -- Add a small delay between API calls to avoid rate limiting
    PERFORM pg_sleep(0.5);
  END LOOP;

  -- Build and return result
  RETURN jsonb_build_object(
    'total_processed', array_length(hotels_to_process, 1),
    'success', success_count,
    'error', error_count,
    'skipped', skipped_count,
    'processed_ids', processed_ids
  );
END;
$$;


--
-- Name: function_update_location_by_type(uuid, text, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_update_location_by_type(search_id uuid, type text, location_id uuid) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF type = 'activities' THEN
        UPDATE public.activities
        SET location = location_id
        WHERE id = search_id;
        RETURN 'Updated location in activities';
        
    ELSIF type = 'hotels' THEN
        UPDATE public.hotels
        SET location = location_id
        WHERE id = search_id;
        RETURN 'Updated location in hotels';
        
    ELSIF type = 'transfers' THEN
        UPDATE public.transfers
        SET location = location_id
        WHERE id = search_id;
        RETURN 'Updated location in transfers';
        
    ELSIF type = 'contacts' THEN
        UPDATE public.contacts
        SET location = location_id
        WHERE id = search_id;
        RETURN 'Updated location in contacts';
        
    ELSIF type = 'accounts' THEN  -- Agregado para manejar la tabla accounts
        UPDATE public.accounts
        SET location = location_id
        WHERE id = search_id;
        RETURN 'Updated location in accounts';
        
    ELSE
        RETURN 'Invalid type provided';
    END IF;
END;
$$;


--
-- Name: function_validate_delete_contact(uuid, boolean, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_validate_delete_contact(contact_id uuid, is_client boolean, is_provider boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    client_exists boolean;
    provider_exists boolean;
BEGIN
    -- Inicializar las variables de existencia
    client_exists := false;
    provider_exists := false;

    -- Verificar si is_client es true y buscar en itineraries
    IF is_client THEN
        SELECT EXISTS (
            SELECT 1 
            FROM itineraries 
            WHERE id_contact = contact_id  -- Usar contact_id en lugar de id
        ) INTO client_exists;
    END IF;

    -- Verificar si is_provider es true y buscar en activities, hotels y transfers
    IF is_provider THEN
        SELECT EXISTS (
            SELECT 1 
            FROM activities 
            WHERE id_contact = contact_id  -- Usar contact_id en lugar de id
        ) INTO provider_exists;

        IF NOT provider_exists THEN
            SELECT EXISTS (
                SELECT 1 
                FROM hotels 
                WHERE id_contact = contact_id  -- Usar contact_id en lugar de id
            ) INTO provider_exists;
        END IF;

        IF NOT provider_exists THEN
            SELECT EXISTS (
                SELECT 1 
                FROM transfers 
                WHERE id_contact = contact_id  -- Usar contact_id en lugar de id
            ) INTO provider_exists;
        END IF;
    END IF;

    -- Retornar 200 si se encuentra alguna coincidencia, de lo contrario 204
    IF (is_client AND client_exists) OR (is_provider AND provider_exists) THEN
        RETURN 200;
    ELSE
        RETURN 204;
    END IF;
END;
$$;


--
-- Name: function_validate_delete_product(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.function_validate_delete_product(product_id uuid) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    product_count integer;  -- Variable para contar los productos encontrados
BEGIN
    -- Contar cuántos productos coinciden con el id proporcionado
    SELECT COUNT(*) INTO product_count
    FROM public.itinerary_items
    WHERE id_product = product_id;

    -- Retornar 200 si se encuentra al menos un producto, de lo contrario retornar 204
    IF product_count > 0 THEN
        RETURN 200;  -- Producto encontrado
    ELSE
        RETURN 204;  -- No se encontró el producto
    END IF;
END;
$$;


--
-- Name: get_activities_with_location(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_activities_with_location() RETURNS TABLE(activity_id uuid, activity_name text, activity_description text, description_short text, city text, state text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        a.id AS activity_id,
        a.name AS activity_name,
        a.description AS activity_description,
        a.description_short,
        l.city,
        l.state
    FROM 
        public.activities a
    LEFT JOIN 
        public.locations l ON a.location = l.id;
END;
$$;


--
-- Name: get_bukeer_data_for_wp_sync(uuid, text, integer, integer, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_bukeer_data_for_wp_sync(p_account_id uuid, p_location text DEFAULT NULL::text, p_page_number integer DEFAULT 1, p_page_size integer DEFAULT 10, p_search text DEFAULT NULL::text, p_type text DEFAULT 'hotel'::text) RETURNS TABLE(id uuid, name text, description_short text, description text, main_image text, city text, account_id uuid, star_rating integer, experience_type text, gallery jsonb, inclutions text, exclutions text, recomendations text, product_type text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    IF p_type = 'hotel' THEN
        RETURN QUERY
        SELECT
            vh.id, vh.name, vh.description_short, vh.description, vh.main_image, vh.city,
            vh.account_id, vh.star_rating, NULL::TEXT, vh.gallery, vh.inclutions, vh.exclutions, vh.recomendations, vh.product_type
        FROM public.view_hotels_wp_sync vh
        WHERE vh.account_id = p_account_id
          AND (p_location IS NULL OR vh.city ILIKE '%' || p_location || '%')
          AND (p_search IS NULL OR vh.name ILIKE '%' || p_search || '%' OR vh.description ILIKE '%' || p_search || '%')
        ORDER BY vh.name
        LIMIT p_page_size OFFSET (p_page_number - 1) * p_page_size;
    ELSIF p_type = 'activity' THEN
        RETURN QUERY
        SELECT
            va.id, va.name, va.description_short, va.description, va.main_image, va.city,
            va.account_id, NULL::INT, va.experience_type, va.gallery, va.inclutions, va.exclutions, va.recomendations, va.product_type
        FROM public.view_activities_wp_sync va
        WHERE va.account_id = p_account_id
          AND (p_location IS NULL OR va.city ILIKE '%' || p_location || '%')
          AND (p_search IS NULL OR va.name ILIKE '%' || p_search || '%' OR va.description ILIKE '%' || p_search || '%')
        ORDER BY va.name
        LIMIT p_page_size OFFSET (p_page_number - 1) * p_page_size;
    ELSE
        RETURN;
    END IF;
END;
$$;


--
-- Name: get_data_by_id_products(text, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_data_by_id_products(table_name text, record_id uuid) RETURNS TABLE(id uuid, name text, description text, description_short text, city text, name_location text, type text, created_at timestamp with time zone, updated_at timestamp with time zone, star_rating integer, duration_minutes integer, price numeric, inclutions text, exclutions text, recommendations text, instructions text, location uuid, main_image text, schedule_data jsonb[])
    LANGUAGE plpgsql
    AS $$ 
BEGIN
    IF table_name = 'activities' THEN
        RETURN QUERY
        SELECT 
            a.id,
            a.name,
            a.description,
            a.description_short,
            l.address AS city,  -- Cambiado de l.city a l.address
            l.name AS name_location,
            a.type,
            a.created_at,
            a.updated_at,
            NULL::integer AS star_rating,
            a.duration_minutes,
            NULL::numeric AS price,
            a.inclutions,
            a.exclutions,
            a.recomendations,
            a.instructions,
            a.location,
            a.main_image,
            a.schedule_data  -- Retorno del campo schedule_data
        FROM 
            activities a
        LEFT JOIN 
            locations l ON a.location = l.id
        WHERE 
            a.id = record_id;

    ELSIF table_name = 'hotels' THEN
        RETURN QUERY
        SELECT 
            h.id,
            h.name,
            h.description,
            h.description_short,
            l.address AS city,  -- Cambiado de l.city a l.address
            l.name AS name_location,
            NULL::text AS type,
            h.created_at,
            h.updated_at,
            h.star_rating,
            NULL::integer AS duration_minutes,
            NULL::numeric AS price,
            h.inclutions,
            h.exclutions,
            h.recomendations,
            h.instructions,
            h.location,
            h.main_image,
            NULL::jsonb[] AS schedule_data  -- Retorno nulo para schedule_data en hoteles
        FROM 
            hotels h
        LEFT JOIN 
            locations l ON h.location = l.id
        WHERE 
            h.id = record_id;

    ELSIF table_name = 'transfers' THEN
        RETURN QUERY
        SELECT 
            t.id,
            t.name,
            t.description,
            t.description_short,
            l.address AS city,  -- Cambiado de l.city a l.address
            l.name AS name_location,
            t.type,
            t.created_at,
            t.updated_at,
            NULL::integer AS star_rating,
            NULL::integer AS duration_minutes,
            NULL::numeric AS price,
            t.inclutions,
            t.exclutions,
            t.recomendations,
            t.instructions,
            t.location,
            t.main_image,
            NULL::jsonb[] AS schedule_data  -- Retorno nulo para schedule_data en transfers
        FROM 
            transfers t
        LEFT JOIN 
            locations l ON t.location = l.id
        WHERE 
            t.id = record_id;

    ELSE
        RAISE EXCEPTION 'Invalid table name: %', table_name;
    END IF;
END;
$$;


--
-- Name: get_hotels_paginated(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_hotels_paginated(page_number integer, page_size integer) RETURNS TABLE(id uuid, name text, address text, latitude double precision, longitude double precision, star_rating integer, description text, check_in_time time without time zone, check_out_time time without time zone, region_id bigint, created_at timestamp with time zone, updated_at timestamp with time zone, provider_id uuid, type text, booking_type text, location text, metadata jsonb, description_short text, inclutions text, exclutions text, recomendations text, instructions text, id_contact uuid, main_image text, account_id uuid)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT *
    FROM public.hotels
    ORDER BY created_at
    LIMIT page_size OFFSET (page_number) * page_size;
END;
$$;


--
-- Name: get_image_urls_by_entity(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_image_urls_by_entity(product_id_catalog uuid) RETURNS TABLE(url text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT im.url
    FROM public.images AS im
    WHERE im.entity_id = product_id_catalog;
END;
$$;


--
-- Name: get_locations_by_product(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_locations_by_product(typeproduct text) RETURNS TABLE(location text)
    LANGUAGE plpgsql
    AS $$BEGIN
    IF typeProduct = 'activities' THEN
        RETURN QUERY
        SELECT DISTINCT a.location
        FROM public.activities a
        ORDER BY a.location ASC;
    ELSIF typeProduct = 'hotels' THEN
        RETURN QUERY
        SELECT DISTINCT h.address AS location
        FROM public.hotels h
        ORDER BY h.address ASC;
    ELSIF typeProduct = 'transfers' THEN
        RETURN QUERY
        SELECT DISTINCT t.location
        FROM public.transfers t
        ORDER BY t.location ASC;
    ELSE
        RAISE EXCEPTION 'Invalid typeProduct: %', typeProduct;
    END IF;
END;$$;


--
-- Name: get_products(text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_products(typeproduct text, searchterm text, location_param text) RETURNS TABLE(id uuid, name text, description text, description_short text, location text, created_at timestamp with time zone, updated_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$DECLARE
    query TEXT;
BEGIN
    -- Construir la consulta según el valor de typeProduct
    IF typeProduct = 'activities' THEN
        query := 'SELECT a.id, a.name, a.description, a.description_short, a.location, a.created_at, a.updated_at, a.main_image
                  FROM public.activities a
                  WHERE 
                      (COALESCE($1, '''') = '''' OR 
                       a.name ILIKE ''%'' || COALESCE($1, '''') || ''%'' OR 
                       a.description ILIKE ''%'' || COALESCE($1, '''') || ''%'' OR 
                       a.description_short ILIKE ''%'' || COALESCE($1, '''') || ''%'')
                      AND 
                      (COALESCE($2, '''') = '''' OR 
                       a.location ILIKE ''%'' || COALESCE($2, '''') || ''%'')
                  ORDER BY a.created_at DESC;';

    ELSIF typeProduct = 'hotels' THEN
        query := 'SELECT h.id, h.name AS name, h.description AS description, h.description_short AS description_short, h.address AS location, h.created_at, h.updated_at
                  FROM public.hotels h
                  WHERE 
                      (COALESCE($1, '''') = '''' OR 
                       h.name ILIKE ''%'' || COALESCE($1, '''') || ''%'' OR 
                       h.description ILIKE ''%'' || COALESCE($1, '''') || ''%'' OR 
                       h.description_short ILIKE ''%'' || COALESCE($1, '''') || ''%'')
                      AND 
                      (COALESCE($2, '''') = '''' OR 
                       h.address ILIKE ''%'' || COALESCE($2, '''') || ''%'')
                  ORDER BY h.created_at DESC;';

    ELSIF typeProduct = 'transfers' THEN
        query := 'SELECT t.id, t.name, t.description, t.description_short, t.location, t.created_at, t.updated_at
                  FROM public.transfers t
                  WHERE 
                      (COALESCE($1, '''') = '''' OR 
                       t.name ILIKE ''%'' || COALESCE($1, '''') || ''%'' OR 
                       t.description ILIKE ''%'' || COALESCE($1, '''') || ''%'' OR 
                       t.description_short ILIKE ''%'' || COALESCE($1, '''') || ''%'')
                      AND 
                      (COALESCE($2, '''') = '''' OR 
                       t.location ILIKE ''%'' || COALESCE($2, '''') || ''%'')
                  ORDER BY t.created_at DESC;';

    ELSE
        RAISE EXCEPTION 'Tipo de producto no soportado';
    END IF;

    -- Ejecutar la consulta dinámica
    RETURN QUERY EXECUTE query USING searchTerm, location_param;
END;$_$;


--
-- Name: get_products_paginated_test(text, text, text, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_products_paginated_test(searchterm text, location_param text, typeproduct text, page_number integer, page_size integer) RETURNS TABLE(id uuid, name text, description text, description_short text, location text, created_at timestamp with time zone, updated_at timestamp with time zone, main_image text)
    LANGUAGE plpgsql
    AS $_$
DECLARE
    query TEXT;
BEGIN
    IF typeProduct = 'activities' THEN
        query := 'SELECT a.id, a.name, a.description, a.description_short, a.location, a.created_at, a.updated_at, a.main_image
                  FROM public.activities a
                  WHERE 
                      (COALESCE($1, '''') = '''' OR 
                       a.name ILIKE ''%'' || COALESCE($1, '''') || ''%'' OR 
                       a.description ILIKE ''%'' || COALESCE($1, '''') || ''%'' OR 
                       a.description_short ILIKE ''%'' || COALESCE($1, '''') || ''%'')
                      AND 
                      (COALESCE($2, '''') = '''' OR 
                       a.location ILIKE ''%'' || COALESCE($2, '''') || ''%'')
                  ORDER BY a.created_at DESC
                  LIMIT $3 OFFSET $4;';

    ELSIF typeProduct = 'hotels' THEN
        query := 'SELECT h.id, h.name, h.description, h.description_short, h.address AS location, h.created_at, h.updated_at, h.main_image
                  FROM public.hotels h
                  WHERE 
                      (COALESCE($1, '''') = '''' OR 
                       h.name ILIKE ''%'' || COALESCE($1, '''') || ''%'' OR 
                       h.description ILIKE ''%'' || COALESCE($1, '''') || ''%'' OR 
                       h.description_short ILIKE ''%'' || COALESCE($1, '''') || ''%'')
                      AND 
                      (COALESCE($2, '''') = '''' OR 
                       h.address ILIKE ''%'' || COALESCE($2, '''') || ''%'')
                  ORDER BY h.created_at DESC
                  LIMIT $3 OFFSET $4;';

    ELSIF typeProduct = 'transfers' THEN
        query := 'SELECT t.id, t.name, t.description, t.description_short, t.location, t.created_at, t.updated_at, t.main_image
                  FROM public.transfers t
                  WHERE 
                      (COALESCE($1, '''') = '''' OR 
                       t.name ILIKE ''%'' || COALESCE($1, '''') || ''%'' OR 
                       t.description ILIKE ''%'' || COALESCE($1, '''') || ''%'' OR 
                       t.description_short ILIKE ''%'' || COALESCE($1, '''') || ''%'')
                      AND 
                      (COALESCE($2, '''') = '''' OR 
                       t.location ILIKE ''%'' || COALESCE($2, '''') || ''%'')
                  ORDER BY t.created_at DESC
                  LIMIT $3 OFFSET $4;';

    ELSE
        RAISE EXCEPTION 'Tipo de producto no soportado';
    END IF;

    RETURN QUERY EXECUTE query USING searchTerm, location_param, page_size, (page_number * page_size);
END;
$_$;


--
-- Name: handle_pending_paid_changes(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.handle_pending_paid_changes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Verificar si pending_paid fue modificado y es menor o igual a 2000
  IF (OLD.pending_paid IS DISTINCT FROM NEW.pending_paid) AND (NEW.pending_paid <= 2000) THEN
    -- Para evitar bucles, verificamos que pending_paid no sea ya 0
    IF NEW.pending_paid <> 0 THEN
      -- Actualizar paid con el valor de total_amount
      NEW.paid = NEW.total_amount;
      -- Establecer pending_paid a 0
      NEW.pending_paid = 0;
    END IF;
  END IF;
  
  RETURN NEW;
END;
$$;


--
-- Name: hotel_pdf_generation(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.hotel_pdf_generation(p_hotel_id uuid) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
    edge_function_url TEXT := 'https://wzlxbpicdcdvxvdcvgas.supabase.co/functions/v1/create-hotel-pdf';
    supabase_service_key TEXT;
    request_body JSONB;
    request_id INT8; -- ID de la solicitud de pg_net
    vault_secret_name TEXT := 'supabase_service_key'; -- Nombre del secreto en Vault
BEGIN
    -- 1. Obtener la clave de servicio de forma segura desde Supabase Vault
    BEGIN
        SELECT decrypted_secret INTO supabase_service_key
        FROM vault.decrypted_secrets
        WHERE name = vault_secret_name;

        IF supabase_service_key IS NULL THEN
            RAISE EXCEPTION 'Secreto no encontrado en Vault (nombre: %). Verifica la configuración de Vault.', vault_secret_name;
        END IF;
    EXCEPTION WHEN others THEN
        RAISE EXCEPTION 'Error al obtener secreto de Vault: %. Asegúrate que la extensión Vault está habilitada, el secreto existe y SECURITY DEFINER está configurado en la función.', SQLERRM;
    END;

    -- 2. Construir el cuerpo JSON para la solicitud POST a la Edge Function
    request_body := jsonb_build_object(
        'hotelId', p_hotel_id -- La Edge Function espera este campo en el JSON
    );

    -- 3. Invocar la Edge Function de forma asíncrona usando pg_net
    RAISE LOG 'Enviando solicitud a Edge Function % para hotel %', edge_function_url, p_hotel_id;
    BEGIN
        SELECT net.http_post(
            url := edge_function_url,
            headers := jsonb_build_object(
                'Content-Type', 'application/json',
                'Authorization', 'Bearer ' || supabase_service_key -- Usar la clave obtenida de Vault
            ),
            body := request_body,
            timeout_milliseconds := 5000 -- Timeout para *enviar* la solicitud (no para completarla)
        ) INTO request_id;
    EXCEPTION WHEN others THEN
        RAISE EXCEPTION 'Fallo la ejecución de pg_net: %', SQLERRM;
    END;

    -- 4. Verificar si la solicitud fue despachada por pg_net
    IF request_id IS NULL THEN
       RAISE EXCEPTION 'pg_net no despachó la solicitud (request_id es NULL). URL: %', edge_function_url;
    END IF;

    -- 5. Devolver una respuesta inmediata indicando éxito en el envío (no en la generación)
    RAISE LOG 'Solicitud enviada exitosamente a Edge Function. Net Request ID: %', request_id;
    RETURN jsonb_build_object(
        'status', 'pdf_generation_queued',
        'message', 'Solicitud de generación de PDF enviada al proceso en segundo plano.',
        'hotel_id', p_hotel_id,
        'net_request_id', request_id -- ID de la tarea en pg_net (útil para logs/auditoría)
    );

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING '[hotel_pdf_generation] Error para hotel %: %', p_hotel_id, SQLERRM;
    RETURN jsonb_build_object(
        'status', 'error',
        'message', 'Fallo al iniciar la generación de PDF: ' || SQLERRM,
        'hotel_id', p_hotel_id
    );
END;
$$;


--
-- Name: normalize_phone_colombia_only(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.normalize_phone_colombia_only(phone_input text) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
  cleaned_phone text;
  original_cleaned text; -- Guardamos el valor limpio antes de añadir +57
BEGIN
  -- 1. Manejar NULL o vacío
  IF phone_input IS NULL OR TRIM(phone_input) = '' THEN
    RETURN NULL;
  END IF;

  -- 2. Limpieza básica: quitar "tel:", espacios, paréntesis, guiones
  cleaned_phone := TRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(phone_input, 'tel:', ''), ' ', ''), '(', ''), ')', ''), '-', ''));
  original_cleaned := cleaned_phone; -- Guardar antes de posible modificación

  -- 3. Validar si ya empieza con + (formato E.164 potencial)
  IF cleaned_phone LIKE '+%' THEN
    -- Validar que solo contenga dígitos después del + y tenga longitud mínima
    IF cleaned_phone ~ '^\+[0-9]{8,}$' THEN
      RETURN cleaned_phone; -- Ya está en formato E.164 correcto o similar, lo dejamos
    ELSE
       -- Si empieza con + pero tiene caracteres raros o es muy corto, mejor dejarlo como estaba limpio
       -- O podrías devolver NULL si prefieres marcarlo como inválido. Dejarlo limpio es más conservador.
      RETURN original_cleaned;
    END IF;
  END IF;

  -- 4. Validar si contiene caracteres no numéricos (después de la limpieza básica)
  IF cleaned_phone !~ '^[0-9]+$' THEN
     -- Contiene caracteres no numéricos (y no empezó con +), devolverlo como quedó tras la limpieza básica
     RETURN original_cleaned;
  END IF;

  -- 5. Regla específica Colombia: empieza por '3' y tiene 10 dígitos
  IF LENGTH(cleaned_phone) = 10 AND cleaned_phone LIKE '3%' THEN
    RETURN '+57' || cleaned_phone; -- Aplica la corrección a E.164
  END IF;

  -- 6. Otros casos numéricos: Si no cumplió la regla de Colombia,
  --    ni empezó con +, simplemente devuelve el número limpio como estaba.
  RETURN original_cleaned;

END;
$_$;


--
-- Name: request_openai_extraction_edge(uuid, uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.request_openai_extraction_edge(p_itinerary_id uuid, p_account_id uuid, p_text_to_analyze text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    edge_function_url TEXT := 'https://wzlxbpicdcdvxvdcvgas.supabase.co/functions/v1/process-flight-extraction';
    supabase_service_key TEXT;
    request_body JSONB;
    request_id INT8;
BEGIN
    -- Obtener la clave de servicio de forma segura desde Supabase Vault
    BEGIN
        SELECT decrypted_secret INTO supabase_service_key
        FROM vault.decrypted_secrets
        WHERE name = 'supabase_service_key';

        IF supabase_service_key IS NULL THEN
            RAISE EXCEPTION 'Supabase service key not found in Vault (secret name: supabase_service_key). Check Vault configuration.';
        END IF;
    EXCEPTION WHEN others THEN
        RAISE EXCEPTION 'Failed to retrieve secret from Vault: %. Ensure Vault extension is enabled and SECURITY DEFINER is set.', SQLERRM;
    END;

    -- Limpiar el texto para evitar problemas con caracteres especiales
    p_text_to_analyze := regexp_replace(p_text_to_analyze, E'[\\n\\r\\t]', ' ', 'g');

    -- Construir cuerpo de la solicitud para la Edge Function
    request_body := jsonb_build_object(
        'itinerary_id', p_itinerary_id,
        'account_id', p_account_id,
        'text_to_analyze', p_text_to_analyze
    );

    -- Invocar la Edge Function de forma asíncrona usando pg_net
    BEGIN
        SELECT net.http_post(
            url := edge_function_url,
            headers := jsonb_build_object(
                'Content-Type', 'application/json',
                'Authorization', 'Bearer ' || supabase_service_key
            ),
            body := request_body,
            timeout_milliseconds := 3000
        ) INTO request_id;
    EXCEPTION WHEN others THEN
        RAISE EXCEPTION 'pg_net execution failed: %', SQLERRM;
    END;

    -- Verificar si la solicitud fue enviada
    IF request_id IS NULL THEN
       RAISE EXCEPTION 'pg_net: Failed to dispatch request to Edge Function (request_id is NULL). URL: %', edge_function_url;
    END IF;

    -- Devolver respuesta inmediata al frontend indicando éxito en el envío
    RETURN jsonb_build_object(
        'status', 'queued_edge',
        'message', 'Flight extraction request sent successfully to background processor.',
        'request_net_id', request_id
    );

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error in request_openai_extraction_edge: %', SQLERRM;
    RETURN jsonb_build_object('status', 'error', 'message', 'Failed to process request: ' || SQLERRM);
END;
$$;


--
-- Name: set_id_fm(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.set_id_fm() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Concatenar el valor de id_fm recibido con el número de la secuencia y convertir a text
    NEW.id_fm := (NEW.id_fm || nextval('public.itineraries_id_fm_seq')::text);
    RETURN NEW;
END;
$$;


--
-- Name: sync_duffel_airlines(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.sync_duffel_airlines() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    response json;
    airline_record json;
    total_processed integer := 0;
    next_cursor text := null;
    retry_count integer := 0;
    max_retries integer := 3;  -- Maximum number of retries
BEGIN
    -- Loop to handle pagination
    LOOP
        -- Make HTTP request to Duffel API
        BEGIN
            SELECT 
                content::json INTO response
            FROM 
                extensions.http(
                    (
                        'GET',                                              
                        'https://api.duffel.com/air/airlines' || 
                        CASE 
                            WHEN next_cursor IS NOT NULL THEN '?after=' || next_cursor || '&limit=100'
                            ELSE '?limit=100'
                        END,
                        ARRAY[                                            
                            ('Accept-Encoding', 'gzip'),
                            ('Accept', 'application/json'),
                            ('Duffel-Version', 'v2'),
                            ('Authorization', 'Bearer DUFFEL_API_KEY_REMOVED')
                        ]::extensions.http_header[],
                        NULL,                                              
                        NULL                                                 
                    )::record
                );
            RAISE NOTICE 'Response from Duffel API: %', response;
            EXIT;  -- Exit block if request is successful
        EXCEPTION
            WHEN others THEN
                RAISE NOTICE 'Error fetching data from Duffel API: %', SQLERRM;
                retry_count := retry_count + 1;
                IF retry_count >= max_retries THEN
                    RETURN 'Error fetching data from Duffel API after retries';
                END IF;
                PERFORM pg_sleep(2);  -- Wait before retrying
                CONTINUE;  -- Retry the request
        END;

        -- Check if there's data in the response
        IF response->'data' IS NULL OR jsonb_array_length(response->'data') = 0 THEN
            RAISE NOTICE 'No data returned from Duffel API';
            EXIT;  -- Exit if no more data
        END IF;

        -- Process each airline from the current page
        FOR airline_record IN 
            SELECT * FROM json_array_elements(response->'data')
        LOOP
            -- Insert or update the airline
            INSERT INTO public.airlines (
                duffel_id,
                name,
                iata_code,
                conditions_of_carriage_url,
                logo_symbol_url,
                logo_lockup_url,
                updated_at
            ) 
            VALUES (
                airline_record->>'id',
                airline_record->>'name',
                airline_record->>'iata_code',
                airline_record->>'conditions_of_carriage_url',
                airline_record->>'logo_symbol_url',
                airline_record->>'logo_lockup_url',
                now()
            )
            ON CONFLICT (duffel_id) DO UPDATE SET
                name = excluded.name,
                iata_code = excluded.iata_code,
                conditions_of_carriage_url = excluded.conditions_of_carriage_url,
                logo_symbol_url = excluded.logo_symbol_url,
                logo_lockup_url = excluded.logo_lockup_url,
                updated_at = now();
                
            total_processed := total_processed + 1;
        END LOOP;

        -- Get cursor for next page
        next_cursor := response->'meta'->>'after';

        -- Exit loop if no more pages
        EXIT WHEN next_cursor IS NULL;

        -- Small pause to not overload the API
        PERFORM pg_sleep(0.5);
    END LOOP;

    RETURN 'Processed ' || total_processed || ' airlines';
END;
$$;


--
-- Name: sync_duffel_airports(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.sync_duffel_airports() RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
    response json;
    airport_record json;
    total_processed integer := 0;
    next_cursor text := null;
    latitude_value text;
    longitude_value text;
    retry_count integer := 0;
    max_retries integer := 3;
    http_status integer;
    http_response_body text;
    full_url text;
    page_limit integer := 200; -- Máximo número de registros por página permitido por Duffel
BEGIN
    -- Bucle para manejar la paginación
    LOOP
        -- Construir la URL completa para logging
        full_url := 'https://api.duffel.com/air/airports' || 
            CASE 
                WHEN next_cursor IS NOT NULL THEN '?after=' || next_cursor || '&limit=' || page_limit
                ELSE '?limit=' || page_limit
            END;
        
        RAISE NOTICE 'Attempting to fetch data from URL: %', full_url;

        -- Hacer la petición HTTP a la API de Duffel
        BEGIN
            SELECT 
                status,
                content::text,
                content::json 
            INTO 
                http_status,
                http_response_body,
                response
            FROM http((
                'GET',
                full_url,
                ARRAY[
                    ('Accept-Encoding', 'gzip'),
                    ('Accept', 'application/json'),
                    ('Duffel-Version', 'v1'),
                    ('Authorization', 'Bearer DUFFEL_API_KEY_REMOVED')
                ]::extensions.http_header[],
                NULL,
                NULL
            )::record);

            RAISE NOTICE 'HTTP Status: %, Response body: %', http_status, http_response_body;

            -- Verificar el estado HTTP
            IF http_status >= 400 THEN
                IF http_status = 504 THEN
                    RAISE EXCEPTION 'Gateway timeout error. The server took too long to respond.';
                ELSE
                    RAISE EXCEPTION 'HTTP error status: %, body: %', http_status, http_response_body;
                END IF;
            END IF;

            -- Verificar si la respuesta es válida
            IF response IS NULL THEN
                RAISE EXCEPTION 'Empty response from Duffel API';
            END IF;

            -- Si llegamos aquí, la petición fue exitosa
            retry_count := 0;  -- Reset retry count on success
            
        EXCEPTION
            WHEN others THEN
                RAISE NOTICE 'Attempt % failed with error: %', retry_count + 1, SQLERRM;
                retry_count := retry_count + 1;
                
                IF retry_count >= max_retries THEN
                    RETURN format('Error fetching data from Duffel API after %s retries. Last error: %s', 
                                max_retries, SQLERRM);
                END IF;
                
                PERFORM pg_sleep(power(2, retry_count));
                CONTINUE;
        END;

        -- Procesar cada aeropuerto
        FOR airport_record IN SELECT * FROM json_array_elements(response->'data')
        LOOP
            BEGIN
                -- Extraer y validar coordenadas
                latitude_value := airport_record->>'latitude';
                longitude_value := airport_record->>'longitude';

                -- Solo procesar si las coordenadas son válidas
                IF latitude_value IS NOT NULL 
                   AND longitude_value IS NOT NULL 
                   AND latitude_value ~ '^-?[0-9]*\.?[0-9]+$' 
                   AND longitude_value ~ '^-?[0-9]*\.?[0-9]+$' THEN
                    
                    INSERT INTO public.airports (
                        duffel_id,
                        name,
                        iata_code,
                        icao_code,
                        latitude,
                        longitude,
                        time_zone,
                        city_name,
                        iata_country_code,
                        iata_city_code,
                        updated_at
                    ) VALUES (
                        airport_record->>'id',
                        airport_record->>'name',
                        airport_record->>'iata_code',
                        airport_record->>'icao_code',
                        latitude_value::double precision,
                        longitude_value::double precision,
                        airport_record->>'time_zone',
                        airport_record->>'city_name',
                        airport_record->>'iata_country_code',
                        airport_record->>'iata_city_code',
                        now()
                    )
                    ON CONFLICT (duffel_id) DO UPDATE SET
                        name = EXCLUDED.name,
                        iata_code = EXCLUDED.iata_code,
                        icao_code = EXCLUDED.icao_code,
                        latitude = EXCLUDED.latitude,
                        longitude = EXCLUDED.longitude,
                        time_zone = EXCLUDED.time_zone,
                        city_name = EXCLUDED.city_name,
                        iata_country_code = EXCLUDED.iata_country_code,
                        iata_city_code = EXCLUDED.iata_city_code,
                        updated_at = now();
                    
                    total_processed := total_processed + 1;
                END IF;
            EXCEPTION
                WHEN others THEN
                    RAISE NOTICE 'Error processing airport %: %', airport_record->>'id', SQLERRM;
                    CONTINUE;
            END;
        END LOOP;

        -- Obtener el cursor para la siguiente página
        next_cursor := response->'meta'->>'after';
        
        -- Si no hay más páginas, salir del bucle
        IF next_cursor IS NULL THEN
            EXIT;
        END IF;

        RAISE NOTICE 'Moving to next page with cursor: %', next_cursor;
    END LOOP;

    RETURN 'Successfully processed ' || total_processed || ' airports';
END;
$_$;


--
-- Name: trigger_update_items_pending_paid_cost(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.trigger_update_items_pending_paid_cost() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Actualizar pending_paid_cost cuando total_cost cambia
    UPDATE itinerary_items
    SET pending_paid_cost = total_cost - paid_cost
    WHERE id = NEW.id;

    RETURN NEW;
END;
$$;


--
-- Name: trigger_update_itinerary(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.trigger_update_itinerary() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Solo actualizar si el tipo de transacción es 'ingreso'
    IF NEW.type = 'ingreso' THEN
        -- Actualizar el monto pagado y el estado del itinerario
        UPDATE public.itineraries
        SET 
            paid = COALESCE(paid, 0) + COALESCE(NEW.value, 0),  -- Suma el nuevo valor de la transacción al monto pagado existente
            pending_paid = total_amount - (COALESCE(paid, 0) + COALESCE(NEW.value, 0)),  -- Calcula el monto pendiente
            status = CASE 
                        WHEN status = 'Presupuesto' THEN 'Confirmado'  -- Cambia el estado a 'Confirmado' si estaba en 'Presupuesto'
                        ELSE status 
                     END  -- Mantiene el estado actual si no es 'Presupuesto'
        WHERE id = NEW.id_itinerary;  -- Coincide el itinerario por id
    END IF;

    RETURN NEW;  -- Retorna el nuevo registro de transacción
END;
$$;


--
-- Name: trigger_update_itinerary_items_cost(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.trigger_update_itinerary_items_cost() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    total_paid_cost NUMERIC;
BEGIN
    -- Solo proceder si el tipo de transacción es 'egreso'
    IF NEW.type = 'egreso' THEN
        -- Sumar el paid_cost actual con el nuevo valor de la transacción
        SELECT COALESCE(SUM(value), 0) INTO total_paid_cost
        FROM transactions
        WHERE id_item_itinerary = NEW.id_item_itinerary;

        -- Actualizar el paid_cost y pending_paid_cost en itinerary_items
        UPDATE itinerary_items
        SET paid_cost = total_paid_cost,
            pending_paid_cost = total_cost - total_paid_cost
        WHERE id = NEW.id_item_itinerary;
    END IF;

    RETURN NEW;
END;
$$;


--
-- Name: trigger_update_itinerary_on_transaction_insert(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.trigger_update_itinerary_on_transaction_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Solo actualizar si el tipo de transacción es 'ingreso'
    IF NEW.type = 'ingreso' THEN
        -- Actualizar el monto pagado y el estado del itinerario
        UPDATE public.itineraries
        SET 
            paid = COALESCE(paid, 0) + COALESCE(NEW.value, 0),  -- Suma el nuevo valor de la transacción al monto pagado existente
            pending_paid = total_amount - (COALESCE(paid, 0) + COALESCE(NEW.value, 0)),  -- Calcula el monto pendiente
            status = CASE 
                        WHEN status = 'Presupuesto' THEN 'Confirmado'  -- Cambia el estado a 'Confirmado' si estaba en 'Presupuesto'
                        ELSE status 
                     END  -- Mantiene el estado actual si no es 'Presupuesto'
        WHERE id = NEW.id_itinerary;  -- Coincide el itinerario por id
    END IF;

    RETURN NEW;  -- Retorna el nuevo registro de transacción
END;
$$;


--
-- Name: update_account_currency(uuid, jsonb[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_account_currency(account_id uuid, new_currency jsonb[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE public.accounts
    SET currency = new_currency
    WHERE id = account_id;
END;
$$;


--
-- Name: update_confirmation_date(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_confirmation_date() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ 
BEGIN 
  IF NEW.status = 'Confirmado' THEN 
    IF NEW.confirmation_date IS NULL THEN 
      NEW.confirmation_date := CURRENT_DATE; -- Solo guarda la fecha actual sin hora
    END IF; 
  END IF; 
  RETURN NEW; 
END; 
$$;


--
-- Name: update_itinerary_on_transaction(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_itinerary_on_transaction() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Solo actualizar si el tipo de transacción es 'ingreso'
    IF NEW.type = 'ingreso' THEN
        -- Actualizar el monto pagado y el estado del itinerario
        UPDATE public.itineraries
        SET 
            paid = COALESCE(paid, 0) + COALESCE(NEW.value, 0),  -- Suma el nuevo valor de la transacción al monto pagado existente
            pending_paid = total_amount - (COALESCE(paid, 0) + COALESCE(NEW.value, 0)),  -- Calcula el monto pendiente
            status = CASE 
                        WHEN status = 'Presupuesto' THEN 'Confirmado'  -- Cambia el estado a 'Confirmado' si estaba en 'Presupuesto'
                        ELSE status 
                     END  -- Mantiene el estado actual si no es 'Presupuesto'
        WHERE id = NEW.id_itinerary;  -- Coincide el itinerario por id
    END IF;

    RETURN NEW;  -- Retorna el nuevo registro de transacción
END;
$$;


--
-- Name: update_itinerary_total_cost(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_itinerary_total_cost() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    new_total_cost numeric;
BEGIN
    -- Agregar información de depuración
    RAISE NOTICE 'Trigger ejecutado: operación = %, id_itinerary = %', 
                 TG_OP, 
                 CASE 
                    WHEN TG_OP = 'DELETE' THEN OLD.id_itinerary 
                    ELSE NEW.id_itinerary 
                 END;

    -- En caso de actualización
    IF TG_OP = 'UPDATE' THEN
        RAISE NOTICE 'UPDATE detectado: OLD.total_cost = %, NEW.total_cost = %', 
                     OLD.total_cost, NEW.total_cost;
        
        -- Calcular la suma total actualizada
        SELECT SUM(total_cost) INTO new_total_cost
        FROM itinerary_items
        WHERE id_itinerary = NEW.id_itinerary;
        
        RAISE NOTICE 'Nuevo total calculado: %', new_total_cost;
        
        -- Actualizar la tabla itineraries con el nuevo total_cost
        UPDATE itineraries
        SET total_cost = COALESCE(new_total_cost, 0)
        WHERE id = NEW.id_itinerary;
        
        RAISE NOTICE 'itineraries actualizado para id = %', NEW.id_itinerary;
    
    -- En caso de inserción
    ELSIF TG_OP = 'INSERT' THEN
        -- Calcular la suma total actualizada
        SELECT SUM(total_cost) INTO new_total_cost
        FROM itinerary_items
        WHERE id_itinerary = NEW.id_itinerary;
        
        -- Actualizar la tabla itineraries con el nuevo total_cost
        UPDATE itineraries
        SET total_cost = COALESCE(new_total_cost, 0)
        WHERE id = NEW.id_itinerary;

    -- En caso de eliminación
    ELSIF TG_OP = 'DELETE' THEN
        -- Calcular la suma total actualizada (sin el elemento eliminado)
        SELECT SUM(total_cost) INTO new_total_cost
        FROM itinerary_items
        WHERE id_itinerary = OLD.id_itinerary;
        
        -- Actualizar la tabla itineraries con el nuevo total_cost
        UPDATE itineraries
        SET total_cost = COALESCE(new_total_cost, 0)
        WHERE id = OLD.id_itinerary;
    END IF;

    -- Retornar el registro apropiado según la operación
    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    ELSE
        RETURN NEW;
    END IF;
END;
$$;


--
-- Name: update_itinerary_totals(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_itinerary_totals() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    price_difference numeric;
BEGIN
    -- Calcular la diferencia de precio para INSERT y UPDATE
    IF TG_OP = 'INSERT' THEN
        price_difference := NEW.total_price;  -- Solo tomamos el nuevo valor
    ELSIF TG_OP = 'UPDATE' THEN
        IF OLD.total_price IS NULL THEN
            price_difference := NEW.total_price;  -- Si OLD es NULL, solo tomamos el nuevo valor
        ELSIF NEW.total_price IS NULL THEN
            price_difference := -OLD.total_price;  -- Si NEW es NULL, restamos el viejo valor
        ELSE
            price_difference := NEW.total_price - OLD.total_price;  -- Caso normal
        END IF;
    ELSIF TG_OP = 'DELETE' THEN
        price_difference := -OLD.total_price;  -- Restamos el viejo valor en caso de eliminación
    END IF;

    -- Actualizar la tabla itineraries según el tipo de producto
    IF TG_OP IN ('INSERT', 'UPDATE') THEN
        IF NEW.product_type = 'Hoteles' THEN
            UPDATE itineraries
            SET total_hotels = COALESCE(total_hotels, 0) + price_difference
            WHERE id = NEW.id_itinerary;
        ELSIF NEW.product_type = 'Transporte' THEN
            UPDATE itineraries
            SET total_transfer = COALESCE(total_transfer, 0) + price_difference
            WHERE id = NEW.id_itinerary;
        ELSIF NEW.product_type = 'Vuelos' THEN
            UPDATE itineraries
            SET total_flights = COALESCE(total_flights, 0) + price_difference
            WHERE id = NEW.id_itinerary;
        ELSIF NEW.product_type = 'Servicios' THEN
            UPDATE itineraries
            SET total_activities = COALESCE(total_activities, 0) + price_difference
            WHERE id = NEW.id_itinerary;
        END IF;
    ELSIF TG_OP = 'DELETE' THEN
        IF OLD.product_type = 'Hoteles' THEN
            UPDATE itineraries
            SET total_hotels = COALESCE(total_hotels, 0) + price_difference
            WHERE id = OLD.id_itinerary;
        ELSIF OLD.product_type = 'Transporte' THEN
            UPDATE itineraries
            SET total_transfer = COALESCE(total_transfer, 0) + price_difference
            WHERE id = OLD.id_itinerary;
        ELSIF OLD.product_type = 'Vuelos' THEN
            UPDATE itineraries
            SET total_flights = COALESCE(total_flights, 0) + price_difference
            WHERE id = OLD.id_itinerary;
        ELSIF OLD.product_type = 'Servicios' THEN
            UPDATE itineraries
            SET total_activities = COALESCE(total_activities, 0) + price_difference
            WHERE id = OLD.id_itinerary;
        END IF;
    END IF;

    RETURN NEW;
END;
$$;


--
-- Name: update_modified_column(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_modified_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;


--
-- Name: update_pending_paid_on_total_amount_change(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_pending_paid_on_total_amount_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Recalcular el pending_paid al cambiar total_amount
  UPDATE itineraries
  SET 
    pending_paid = NEW.total_amount - paid
  WHERE id = NEW.id;

  RETURN NEW;
END;
$$;


--
-- Name: update_price_and_profit(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_price_and_profit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Recalcular el precio si el costo unitario ha cambiado
    IF NEW.unit_cost IS DISTINCT FROM OLD.unit_cost THEN
        NEW.price := ROUND(NEW.unit_cost * (1 + NEW.profit / 100), 0);
    END IF;

    -- Recalcular el precio si el profit ha cambiado
    IF NEW.profit IS DISTINCT FROM OLD.profit THEN
        NEW.price := ROUND(NEW.unit_cost * (1 + NEW.profit / 100), 0);
    END IF;

    -- Recalcular el profit si el precio ha cambiado
    IF NEW.price IS DISTINCT FROM OLD.price AND NEW.unit_cost IS NOT NULL THEN
        NEW.profit := ROUND((NEW.price / NEW.unit_cost - 1) * 100, 0);
    END IF;

    RETURN NEW;
END; 
$$;


--
-- Name: update_price_and_profit_itinerary_items(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_price_and_profit_itinerary_items() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Recalcular el total_price si unit_price, hotel_nights o quantity han cambiado
    IF NEW.unit_price IS DISTINCT FROM OLD.unit_price OR
       NEW.hotel_nights IS DISTINCT FROM OLD.hotel_nights OR
       NEW.quantity IS DISTINCT FROM OLD.quantity THEN
        NEW.total_price := ROUND(NEW.unit_price * NEW.hotel_nights * NEW.quantity, 0);
    END IF;

    -- Recalcular el profit si unit_cost o total_price han cambiado
    IF NEW.unit_cost IS DISTINCT FROM OLD.unit_cost AND NEW.unit_cost IS NOT NULL THEN
        NEW.profit := ROUND((NEW.total_price / NEW.unit_cost - 1) * 100, 0);
    ELSIF NEW.total_price IS DISTINCT FROM OLD.total_price AND NEW.unit_cost IS NOT NULL THEN
        NEW.profit := ROUND((NEW.total_price / NEW.unit_cost - 1) * 100, 0);
    END IF;

    RETURN NEW;
END;
$$;


--
-- Name: update_total_amount_on_request_type_change(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_total_amount_on_request_type_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    new_total_amount numeric;
    rate numeric;
BEGIN
    -- Calcular el nuevo total_amount
    new_total_amount := COALESCE(NEW.total_hotels, 0) + 
                        COALESCE(NEW.total_flights, 0) + 
                        COALESCE(NEW.total_activities, 0) + 
                        COALESCE(NEW.total_transfer, 0);

    -- Verificar si types_increase es un arreglo JSON válido
    IF NEW.types_increase IS NOT NULL AND jsonb_typeof(NEW.types_increase) = 'array' THEN
        -- Consultar el rate desde types_increase
        SELECT (value->>'rate')::numeric INTO rate
        FROM jsonb_array_elements(NEW.types_increase) AS value
        WHERE LOWER(value->>'name') = LOWER(NEW.request_type);

        -- Ajustar total_amount con el rate
        IF rate IS NOT NULL THEN
            new_total_amount := new_total_amount * (1 + rate / 100);
        END IF;
    END IF;

    -- Redondear total_amount a 1 decimal
    new_total_amount := ROUND(new_total_amount, 1);

    -- Actualizar total_amount en la tabla itineraries
    UPDATE itineraries
    SET total_amount = new_total_amount
    WHERE id = NEW.id;

    -- Calcular y actualizar total_markup
    IF new_total_amount > 0 THEN
        UPDATE itineraries
        SET total_markup = ROUND((new_total_amount - COALESCE(NEW.total_cost, 0)), 1) 
        WHERE id = NEW.id;
    ELSE
        UPDATE itineraries
        SET total_markup = 0
        WHERE id = NEW.id;
    END IF;

    RETURN NEW;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.accounts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    name text NOT NULL,
    status text,
    id_fm integer NOT NULL,
    logo_image text,
    type_id text,
    number_id text,
    phone text,
    phone2 text,
    mail text,
    location uuid,
    website text,
    cancellation_policy text,
    privacy_policy text,
    terms_conditions text,
    currency jsonb[] DEFAULT '{}'::jsonb[],
    types_increase jsonb[] DEFAULT '{}'::jsonb[],
    payment_methods jsonb[] DEFAULT '{}'::jsonb[]
);


--
-- Name: accounts_id_fm_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.accounts ALTER COLUMN id_fm ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.accounts_id_fm_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: activities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.activities (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    name text NOT NULL,
    description text,
    type text,
    booking_type text,
    duration_minutes integer,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    description_short text,
    inclutions text,
    exclutions text,
    recomendations text,
    instructions text,
    id_contact uuid,
    experience_type text,
    main_image text,
    account_id uuid,
    location uuid,
    schedule_data jsonb[],
    social_image text
);


--
-- Name: activities_rates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.activities_rates (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    unit_cost numeric,
    profit numeric,
    price numeric,
    id_product uuid,
    account_id uuid,
    CONSTRAINT check_price_decimal CHECK (((price IS NULL) OR (price = round(price, 2)))),
    CONSTRAINT check_unit_cost_decimal CHECK (((unit_cost IS NULL) OR (unit_cost = round(unit_cost, 2))))
);


--
-- Name: contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contacts (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    name text NOT NULL,
    last_name text,
    email text,
    phone text,
    managed_by_user_id uuid,
    additional_info jsonb,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    nationality text,
    type_id text,
    number_id text,
    id_itinerary uuid,
    birth_date date,
    id_fm text,
    user_id uuid,
    user_rol text,
    website text,
    id_related_contact uuid,
    is_company boolean,
    is_provider boolean,
    phone2 text,
    user_image text,
    is_client boolean,
    account_id uuid,
    location uuid,
    "position" text,
    notify boolean
);


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.locations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    latlng text,
    name text,
    address text,
    city text,
    state text,
    country text,
    zip_code text,
    account_id uuid NOT NULL,
    type_entity text NOT NULL
);


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roles (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    role_name text
);


--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_roles (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_id uuid,
    role_id bigint,
    account_id uuid
);


--
-- Name: activities_view; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.activities_view AS
 SELECT a.id,
    a.name,
    a.description,
    a.description_short,
    a.main_image,
    l.address AS city,
    a.created_at,
    a.updated_at,
    a.id_contact,
    a.inclutions,
    a.exclutions,
    a.recomendations,
    a.instructions,
    c.name AS name_provider
   FROM ((public.activities a
     LEFT JOIN public.locations l ON ((a.location = l.id)))
     LEFT JOIN public.contacts c ON ((a.id_contact = c.id)))
  WHERE (EXISTS ( SELECT 1
           FROM (public.user_roles
             JOIN public.roles ON ((user_roles.role_id = roles.id)))
          WHERE ((user_roles.user_id = auth.uid()) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text) OR (roles.role_name = 'agent'::text)) AND (user_roles.account_id = a.account_id))));


--
-- Name: airlines; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.airlines (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    duffel_id text NOT NULL,
    name text NOT NULL,
    iata_code text,
    conditions_of_carriage_url text,
    logo_symbol_url text,
    logo_lockup_url text,
    updated_at timestamp with time zone DEFAULT now(),
    account_id uuid,
    feature boolean,
    logo_png text
);


--
-- Name: airports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.airports (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    duffel_id text NOT NULL,
    name text,
    icao_code text,
    iata_code text,
    iata_country_code text,
    iata_city_code text,
    city_name text,
    longitude double precision,
    latitude double precision,
    time_zone text,
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: airports_view; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.airports_view AS
 SELECT airports.id,
    ((airports.iata_code || ' - '::text) || airports.city_name) AS name
   FROM public.airports;


--
-- Name: flights; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.flights (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    airline text NOT NULL,
    flight_number text NOT NULL,
    departure_airport text NOT NULL,
    arrival_airport text NOT NULL,
    departure_time timestamp with time zone NOT NULL,
    arrival_time timestamp with time zone NOT NULL,
    estimated_price numeric(10,2),
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    provider_name text,
    status text,
    provider_specific_data jsonb,
    price double precision,
    currency text,
    account_id uuid
);


--
-- Name: hotel_rates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hotel_rates (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    hotel_id uuid NOT NULL,
    name text,
    capacity integer,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    unit_cost numeric,
    profit numeric,
    price numeric,
    currency text,
    description text,
    is_active boolean DEFAULT true,
    account_id uuid,
    CONSTRAINT check_price_decimal CHECK (((price IS NULL) OR (price = round(price, 2)))),
    CONSTRAINT check_unit_cost_decimal CHECK (((unit_cost IS NULL) OR (unit_cost = round(unit_cost, 2))))
);


--
-- Name: hotels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hotels (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    name text NOT NULL,
    star_rating integer,
    description text,
    check_in_time time without time zone,
    check_out_time time without time zone,
    region_id bigint,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    provider_id uuid,
    type text,
    booking_type text,
    metadata jsonb,
    description_short text,
    inclutions text,
    exclutions text,
    recomendations text,
    instructions text,
    id_contact uuid,
    main_image text,
    account_id uuid,
    location uuid,
    social_image text,
    pdf_image text
);


--
-- Name: hotels_view; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.hotels_view AS
 SELECT h.id,
    h.name,
    h.description,
    h.description_short,
    h.main_image,
    l.address AS city,
    l.name AS name_location,
    h.created_at,
    h.updated_at,
    h.id_contact,
    h.inclutions,
    h.exclutions,
    h.recomendations,
    h.instructions,
    c.name AS name_provider
   FROM ((public.hotels h
     LEFT JOIN public.locations l ON ((h.location = l.id)))
     LEFT JOIN public.contacts c ON ((h.id_contact = c.id)))
  WHERE (EXISTS ( SELECT 1
           FROM (public.user_roles
             JOIN public.roles ON ((user_roles.role_id = roles.id)))
          WHERE ((user_roles.user_id = auth.uid()) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text) OR (roles.role_name = 'agent'::text)) AND (user_roles.account_id = h.account_id))));


--
-- Name: images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.images (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    entity_id uuid,
    url text,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    account_id uuid
);


--
-- Name: itineraries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.itineraries (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    id_created_by uuid,
    name text,
    start_date date NOT NULL,
    end_date date NOT NULL,
    status text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
    id_contact uuid,
    passenger_count numeric,
    currency_type text,
    valid_until date,
    request_type text,
    total_amount numeric DEFAULT '0'::numeric,
    total_markup numeric DEFAULT '0'::numeric,
    total_cost numeric DEFAULT '0'::numeric,
    agent text,
    total_provider_payment numeric DEFAULT '0'::numeric,
    id_fm text,
    language text DEFAULT ''::text,
    account_id uuid,
    total_hotels numeric DEFAULT '0'::numeric,
    total_flights numeric DEFAULT '0'::numeric,
    total_activities numeric DEFAULT '0'::numeric,
    total_transfer numeric DEFAULT '0'::numeric,
    paid numeric DEFAULT '0'::numeric,
    pending_paid numeric DEFAULT '0'::numeric,
    currency jsonb,
    itinerary_visibility boolean DEFAULT true,
    rates_visibility boolean DEFAULT false,
    types_increase jsonb,
    total_amount_rate numeric DEFAULT '0'::numeric,
    personalized_message text DEFAULT ''::text,
    main_image text DEFAULT ''::text,
    confirmation_date date,
    CONSTRAINT check_paid_decimal CHECK (((paid IS NULL) OR (paid = round(paid, 2)))),
    CONSTRAINT check_pending_paid_decimal CHECK (((pending_paid IS NULL) OR (pending_paid = round(pending_paid, 2)))),
    CONSTRAINT check_total_activities_decimal CHECK (((total_activities IS NULL) OR (total_activities = round(total_activities, 2)))),
    CONSTRAINT check_total_amount_decimal CHECK (((total_amount IS NULL) OR (total_amount = round(total_amount, 2)))),
    CONSTRAINT check_total_cost_decimal CHECK (((total_cost IS NULL) OR (total_cost = round(total_cost, 2)))),
    CONSTRAINT check_total_flights_decimal CHECK (((total_flights IS NULL) OR (total_flights = round(total_flights, 2)))),
    CONSTRAINT check_total_hotels_decimal CHECK (((total_hotels IS NULL) OR (total_hotels = round(total_hotels, 2)))),
    CONSTRAINT check_total_markup_decimal CHECK (((total_markup IS NULL) OR (total_markup = round(total_markup, 2)))),
    CONSTRAINT check_total_provider_payment_decimal CHECK (((total_provider_payment IS NULL) OR (total_provider_payment = round(total_provider_payment, 2)))),
    CONSTRAINT check_total_transfer_decimal CHECK (((total_transfer IS NULL) OR (total_transfer = round(total_transfer, 2))))
);


--
-- Name: itineraries_id_fm_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.itineraries_id_fm_seq
    START WITH 5000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: itinerary_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.itinerary_items (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    id_itinerary uuid,
    start_time timestamp with time zone,
    end_time timestamp with time zone,
    day_number integer,
    "order" integer,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    unit_cost numeric,
    quantity numeric,
    total_cost numeric,
    date date,
    destination text,
    product_name text,
    rate_name text,
    product_type text,
    hotel_nights integer,
    profit_percentage numeric,
    profit numeric,
    total_price numeric,
    flight_departure text,
    flight_arrival text,
    departure_time text,
    arrival_time text,
    flight_number text,
    airline uuid,
    unit_price numeric,
    id_product uuid,
    account_id uuid,
    paid_cost numeric DEFAULT '0'::numeric,
    pending_paid_cost numeric,
    reservation_status boolean DEFAULT false NOT NULL,
    personalized_message text DEFAULT ''::text,
    reservation_messages jsonb[],
    CONSTRAINT check_paid_cost_decimal CHECK (((paid_cost IS NULL) OR (paid_cost = round(paid_cost, 2)))),
    CONSTRAINT check_pending_paid_cost_decimal CHECK (((pending_paid_cost IS NULL) OR (pending_paid_cost = round(pending_paid_cost, 2)))),
    CONSTRAINT check_profit_decimal CHECK (((profit IS NULL) OR (profit = round(profit, 1)))),
    CONSTRAINT check_quantity_decimal CHECK (((quantity IS NULL) OR (quantity = round(quantity, 1)))),
    CONSTRAINT check_total_cost_decimal CHECK (((total_cost IS NULL) OR (total_cost = round(total_cost, 2)))),
    CONSTRAINT check_total_price_decimal CHECK (((total_price IS NULL) OR (total_price = round(total_price, 2)))),
    CONSTRAINT check_unit_cost_decimal CHECK (((unit_cost IS NULL) OR (unit_cost = round(unit_cost, 2)))),
    CONSTRAINT check_unit_price_decimal CHECK (((unit_price IS NULL) OR (unit_price = round(unit_price, 2))))
);


--
-- Name: nationalities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nationalities (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


--
-- Name: nationalities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.nationalities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: nationalities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.nationalities_id_seq OWNED BY public.nationalities.id;


--
-- Name: notes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notes (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    itinerary_item_id uuid,
    content text NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    account_id uuid
);


--
-- Name: passenger; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.passenger (
    id bigint NOT NULL,
    name text NOT NULL,
    last_name text NOT NULL,
    type_id text NOT NULL,
    number_id text NOT NULL,
    nationality text NOT NULL,
    birth_date date NOT NULL,
    itinerary_id uuid DEFAULT auth.uid() NOT NULL,
    account_id uuid
);


--
-- Name: passenger_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.passenger ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.passenger_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: points_of_interest; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.points_of_interest (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    name text NOT NULL,
    city text NOT NULL,
    description text,
    estimated_entrance_fee numeric(10,2),
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    account_id uuid
);


--
-- Name: regions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regions (
    id bigint NOT NULL,
    name text NOT NULL,
    country_code text,
    type text,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    account_id uuid
);


--
-- Name: regions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.regions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.regions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.roles ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transactions (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    id_itinerary uuid,
    date date,
    value numeric,
    payment_method text,
    account_id uuid,
    type text NOT NULL,
    voucher_url text,
    id_item_itinerary uuid,
    reference text,
    CONSTRAINT check_value_decimal CHECK (((value IS NULL) OR (value = round(value, 2))))
);


--
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.transactions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: transfer_rates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transfer_rates (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    unit_cost numeric,
    profit numeric,
    price numeric,
    id_transfer uuid,
    account_id uuid,
    CONSTRAINT check_price_decimal CHECK (((price IS NULL) OR (price = round(price, 2)))),
    CONSTRAINT check_unit_cost_decimal CHECK (((unit_cost IS NULL) OR (unit_cost = round(unit_cost, 2))))
);


--
-- Name: transfers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transfers (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    type text,
    from_location text,
    to_location text,
    departure_time timestamp with time zone,
    arrival_time timestamp with time zone,
    estimated_price numeric(10,2),
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    provider_id uuid,
    name text,
    description text,
    booking_type text,
    duration_minutes integer,
    metadata jsonb,
    description_short text,
    inclutions text,
    exclutions text,
    recomendations text,
    instructions text,
    id_contact uuid,
    experience_type text,
    main_image text,
    account_id uuid,
    location uuid
);


--
-- Name: transfers_view; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.transfers_view AS
 SELECT t.id,
    t.name,
    t.description,
    t.description_short,
    t.main_image,
    l.address AS city,
    t.created_at,
    t.updated_at,
    t.id_contact,
    t.inclutions,
    t.exclutions,
    t.recomendations,
    t.instructions,
    c.name AS name_provider
   FROM ((public.transfers t
     LEFT JOIN public.locations l ON ((t.location = l.id)))
     LEFT JOIN public.contacts c ON ((t.id_contact = c.id)))
  WHERE (EXISTS ( SELECT 1
           FROM (public.user_roles
             JOIN public.roles ON ((user_roles.role_id = roles.id)))
          WHERE ((user_roles.user_id = auth.uid()) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text) OR (roles.role_name = 'agent'::text)) AND (user_roles.account_id = t.account_id))));


--
-- Name: user_contact_info; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.user_contact_info AS
 SELECT contacts.name,
    contacts.email,
    contacts.phone,
    contacts.user_rol,
    contacts.account_id,
    contacts.last_name,
    ur.id AS id_user_rol,
    contacts.id
   FROM ((auth.users
     JOIN public.contacts ON ((users.id = contacts.user_id)))
     LEFT JOIN public.user_roles ur ON (((contacts.user_id = ur.user_id) AND (contacts.account_id = ur.account_id))))
  WHERE (EXISTS ( SELECT 1
           FROM (public.user_roles
             JOIN public.roles ON ((user_roles.role_id = roles.id)))
          WHERE ((user_roles.user_id = auth.uid()) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text)) AND (user_roles.account_id = contacts.account_id))));


--
-- Name: user_contact_info_admin; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.user_contact_info_admin AS
 SELECT contacts.name,
    contacts.email,
    contacts.phone,
    contacts.user_rol,
    contacts.account_id,
    contacts.last_name,
    ur.id AS id_user_rol,
    contacts.id
   FROM ((auth.users
     JOIN public.contacts ON ((users.id = contacts.user_id)))
     LEFT JOIN public.user_roles ur ON (((contacts.user_id = ur.user_id) AND (contacts.account_id = ur.account_id))));


--
-- Name: user_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.user_roles ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.user_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: user_roles_view; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.user_roles_view AS
 SELECT ur.user_id,
    string_agg(r.role_name, ', '::text) AS role_names
   FROM (public.user_roles ur
     JOIN public.roles r ON ((ur.role_id = r.id)))
  GROUP BY ur.user_id;


--
-- Name: view_activities_wp_sync; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.view_activities_wp_sync AS
 SELECT a.id,
    a.name,
    a.description_short,
    a.description,
    a.main_image,
    l.name AS city,
    a.account_id,
    a.experience_type,
    ( SELECT jsonb_agg(jsonb_build_object('url', i.url)) AS jsonb_agg
           FROM public.images i
          WHERE (i.entity_id = a.id)) AS gallery,
    a.inclutions,
    a.exclutions,
    a.recomendations,
    'activity'::text AS product_type
   FROM (public.activities a
     LEFT JOIN public.locations l ON ((a.location = l.id)));


--
-- Name: view_hotels_wp_sync; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.view_hotels_wp_sync AS
 SELECT h.id,
    h.name,
    h.description_short,
    h.description,
    h.main_image,
    l.name AS city,
    h.account_id,
    h.star_rating,
    ( SELECT jsonb_agg(jsonb_build_object('url', i.url)) AS jsonb_agg
           FROM public.images i
          WHERE (i.entity_id = h.id)) AS gallery,
    h.inclutions,
    h.exclutions,
    h.recomendations,
    'hotel'::text AS product_type
   FROM (public.hotels h
     LEFT JOIN public.locations l ON ((h.location = l.id)));


--
-- Name: nationalities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nationalities ALTER COLUMN id SET DEFAULT nextval('public.nationalities_id_seq'::regclass);


--
-- Name: accounts accounts_id_fm_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_id_fm_key UNIQUE (id_fm);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: activities activities_main_image_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_main_image_key UNIQUE (main_image);


--
-- Name: activities activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (id);


--
-- Name: airlines airlines_duffel_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.airlines
    ADD CONSTRAINT airlines_duffel_id_key UNIQUE (duffel_id);


--
-- Name: airlines airlines_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.airlines
    ADD CONSTRAINT airlines_pkey PRIMARY KEY (id);


--
-- Name: airports airports_duffel_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.airports
    ADD CONSTRAINT airports_duffel_id_key UNIQUE (duffel_id);


--
-- Name: airports airports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.airports
    ADD CONSTRAINT airports_pkey PRIMARY KEY (id);


--
-- Name: contacts contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);


--
-- Name: flights flights_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flights
    ADD CONSTRAINT flights_pkey PRIMARY KEY (id);


--
-- Name: hotels hotels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hotels
    ADD CONSTRAINT hotels_pkey PRIMARY KEY (id);


--
-- Name: images images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.images
    ADD CONSTRAINT images_pkey PRIMARY KEY (id);


--
-- Name: images images_url_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.images
    ADD CONSTRAINT images_url_key UNIQUE (url);


--
-- Name: itineraries itineraries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.itineraries
    ADD CONSTRAINT itineraries_pkey PRIMARY KEY (id);


--
-- Name: itinerary_items itinerary_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.itinerary_items
    ADD CONSTRAINT itinerary_items_pkey PRIMARY KEY (id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: nationalities nationalities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nationalities
    ADD CONSTRAINT nationalities_pkey PRIMARY KEY (id);


--
-- Name: notes notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (id);


--
-- Name: passenger passenger_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.passenger
    ADD CONSTRAINT passenger_pkey PRIMARY KEY (id);


--
-- Name: points_of_interest points_of_interest_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.points_of_interest
    ADD CONSTRAINT points_of_interest_pkey PRIMARY KEY (id);


--
-- Name: activities_rates rates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities_rates
    ADD CONSTRAINT rates_pkey PRIMARY KEY (id);


--
-- Name: regions regions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: hotel_rates rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hotel_rates
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (id);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: transfer_rates transfer_rates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transfer_rates
    ADD CONSTRAINT transfer_rates_pkey PRIMARY KEY (id);


--
-- Name: transfers transportation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transfers
    ADD CONSTRAINT transportation_pkey PRIMARY KEY (id);


--
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);


--
-- Name: idx_itinerary_item_itinerary_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_itinerary_item_itinerary_id ON public.itinerary_items USING btree (id_itinerary);


--
-- Name: idx_itinerary_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_itinerary_user_id ON public.itineraries USING btree (id_created_by);


--
-- Name: itineraries calculated_total_markup_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER calculated_total_markup_trigger AFTER UPDATE OF total_hotels, total_flights, total_activities, total_transfer, total_cost ON public.itineraries FOR EACH ROW EXECUTE FUNCTION public.calculated_total_markup();


--
-- Name: itineraries check_pending_paid; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER check_pending_paid BEFORE UPDATE ON public.itineraries FOR EACH ROW EXECUTE FUNCTION public.handle_pending_paid_changes();


--
-- Name: activities handle_newlines; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER handle_newlines BEFORE INSERT OR UPDATE ON public.activities FOR EACH ROW EXECUTE FUNCTION public.escape_newlines();

ALTER TABLE public.activities DISABLE TRIGGER handle_newlines;


--
-- Name: itinerary_items itinerary_items_cost_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER itinerary_items_cost_update AFTER UPDATE OF total_cost ON public.itinerary_items FOR EACH ROW EXECUTE FUNCTION public.update_itinerary_total_cost();

ALTER TABLE public.itinerary_items DISABLE TRIGGER itinerary_items_cost_update;


--
-- Name: itinerary_items itinerary_items_cost_update_; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER itinerary_items_cost_update_ AFTER UPDATE ON public.itinerary_items FOR EACH ROW EXECUTE FUNCTION public.update_itinerary_total_cost();


--
-- Name: itinerary_items itinerary_items_delete_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER itinerary_items_delete_update AFTER DELETE ON public.itinerary_items FOR EACH ROW EXECUTE FUNCTION public.update_itinerary_total_cost();


--
-- Name: itinerary_items itinerary_items_insert_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER itinerary_items_insert_update AFTER INSERT ON public.itinerary_items FOR EACH ROW EXECUTE FUNCTION public.update_itinerary_total_cost();


--
-- Name: itinerary_items itinerary_items_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER itinerary_items_update AFTER INSERT OR DELETE OR UPDATE ON public.itinerary_items FOR EACH ROW EXECUTE FUNCTION public.update_itinerary_totals();


--
-- Name: itineraries set_confirmation_date; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_confirmation_date BEFORE UPDATE OF status ON public.itineraries FOR EACH ROW WHEN (((new.status = 'Confirmado'::text) AND (old.status <> 'Confirmado'::text))) EXECUTE FUNCTION public.update_confirmation_date();


--
-- Name: itineraries set_id_fm_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_id_fm_trigger BEFORE INSERT ON public.itineraries FOR EACH ROW EXECUTE FUNCTION public.set_id_fm();


--
-- Name: itinerary_items total_cost_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER total_cost_trigger BEFORE INSERT OR UPDATE ON public.itinerary_items FOR EACH ROW EXECUTE FUNCTION public.calculate_total_cost();


--
-- Name: activities_rates trg_update_price_and_profit; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_update_price_and_profit BEFORE UPDATE ON public.activities_rates FOR EACH ROW EXECUTE FUNCTION public.update_price_and_profit();

ALTER TABLE public.activities_rates DISABLE TRIGGER trg_update_price_and_profit;


--
-- Name: itinerary_items trg_update_price_and_profit; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_update_price_and_profit BEFORE UPDATE ON public.itinerary_items FOR EACH ROW EXECUTE FUNCTION public.update_price_and_profit_itinerary_items();

ALTER TABLE public.itinerary_items DISABLE TRIGGER trg_update_price_and_profit;


--
-- Name: transactions trigger_after_transaction_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_after_transaction_insert AFTER INSERT ON public.transactions FOR EACH ROW EXECUTE FUNCTION public.trigger_update_itinerary();

ALTER TABLE public.transactions DISABLE TRIGGER trigger_after_transaction_insert;


--
-- Name: itinerary_items trigger_calculate_item_pending_paid_cost; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_calculate_item_pending_paid_cost BEFORE INSERT ON public.itinerary_items FOR EACH ROW EXECUTE FUNCTION public.function_calculate_item_pending_paid_cost();


--
-- Name: transactions trigger_update_paid_on_transaction; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_update_paid_on_transaction AFTER INSERT ON public.transactions FOR EACH ROW EXECUTE FUNCTION public.update_itinerary_on_transaction();

ALTER TABLE public.transactions DISABLE TRIGGER trigger_update_paid_on_transaction;


--
-- Name: itineraries trigger_update_pending_paid_on_total_amount_change; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_update_pending_paid_on_total_amount_change AFTER UPDATE OF total_amount ON public.itineraries FOR EACH ROW EXECUTE FUNCTION public.update_pending_paid_on_total_amount_change();


--
-- Name: itineraries trigger_update_total_amount_on_request_type_change; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_update_total_amount_on_request_type_change AFTER UPDATE OF request_type ON public.itineraries FOR EACH ROW EXECUTE FUNCTION public.update_total_amount_on_request_type_change();


--
-- Name: activities update_activities_modtime; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_activities_modtime BEFORE UPDATE ON public.activities FOR EACH ROW EXECUTE FUNCTION public.update_modified_column();

ALTER TABLE public.activities DISABLE TRIGGER update_activities_modtime;


--
-- Name: itinerary_items update_item_pending_paid_cost_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_item_pending_paid_cost_trigger AFTER UPDATE OF total_cost, paid_cost, quantity, unit_cost ON public.itinerary_items FOR EACH ROW EXECUTE FUNCTION public.trigger_update_items_pending_paid_cost();


--
-- Name: transactions update_itinerary_items_cost_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_itinerary_items_cost_trigger AFTER INSERT OR UPDATE ON public.transactions FOR EACH ROW EXECUTE FUNCTION public.trigger_update_itinerary_items_cost();


--
-- Name: transactions update_itinerary_on_transaction_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_itinerary_on_transaction_insert AFTER INSERT ON public.transactions FOR EACH ROW EXECUTE FUNCTION public.update_itinerary_on_transaction();


--
-- Name: activities_rates update_rates_modtime; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_rates_modtime BEFORE UPDATE ON public.activities_rates FOR EACH ROW EXECUTE FUNCTION public.update_modified_column();

ALTER TABLE public.activities_rates DISABLE TRIGGER update_rates_modtime;


--
-- Name: accounts accounts_location_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_location_fkey FOREIGN KEY (location) REFERENCES public.locations(id);


--
-- Name: activities activities_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: activities activities_id_contact_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_id_contact_fkey FOREIGN KEY (id_contact) REFERENCES public.contacts(id);


--
-- Name: activities activities_location_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_location_fkey FOREIGN KEY (location) REFERENCES public.locations(id) ON DELETE SET NULL;


--
-- Name: activities activities_main_image_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_main_image_fkey FOREIGN KEY (main_image) REFERENCES public.images(url) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: activities_rates activities_rates_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities_rates
    ADD CONSTRAINT activities_rates_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: activities_rates activities_rates_id_product_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities_rates
    ADD CONSTRAINT activities_rates_id_product_fkey FOREIGN KEY (id_product) REFERENCES public.activities(id) ON DELETE CASCADE;


--
-- Name: airlines airlines_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.airlines
    ADD CONSTRAINT airlines_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE;


--
-- Name: contacts contacts_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts
    ADD CONSTRAINT contacts_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: contacts contacts_id_itinerary_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts
    ADD CONSTRAINT contacts_id_itinerary_fkey FOREIGN KEY (id_itinerary) REFERENCES public.itineraries(id) ON DELETE SET NULL;


--
-- Name: contacts contacts_id_related_contact_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts
    ADD CONSTRAINT contacts_id_related_contact_fkey FOREIGN KEY (id_related_contact) REFERENCES public.contacts(id) ON DELETE SET NULL;


--
-- Name: contacts contacts_location_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts
    ADD CONSTRAINT contacts_location_fkey FOREIGN KEY (location) REFERENCES public.locations(id) ON DELETE SET NULL;


--
-- Name: contacts contacts_managed_by_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts
    ADD CONSTRAINT contacts_managed_by_user_id_fkey FOREIGN KEY (managed_by_user_id) REFERENCES auth.users(id);


--
-- Name: contacts contacts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts
    ADD CONSTRAINT contacts_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE SET NULL;


--
-- Name: hotels fk_region; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hotels
    ADD CONSTRAINT fk_region FOREIGN KEY (region_id) REFERENCES public.regions(id) ON DELETE SET NULL;


--
-- Name: hotel_rates fk_room_hotel; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hotel_rates
    ADD CONSTRAINT fk_room_hotel FOREIGN KEY (hotel_id) REFERENCES public.hotels(id) ON DELETE CASCADE;


--
-- Name: flights flights_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flights
    ADD CONSTRAINT flights_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: hotel_rates hotel_rates_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hotel_rates
    ADD CONSTRAINT hotel_rates_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: hotels hotels_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hotels
    ADD CONSTRAINT hotels_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: hotels hotels_id_contact_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hotels
    ADD CONSTRAINT hotels_id_contact_fkey FOREIGN KEY (id_contact) REFERENCES public.contacts(id) ON DELETE CASCADE;


--
-- Name: hotels hotels_location_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hotels
    ADD CONSTRAINT hotels_location_fkey FOREIGN KEY (location) REFERENCES public.locations(id) ON DELETE SET NULL;


--
-- Name: hotels hotels_main_image_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hotels
    ADD CONSTRAINT hotels_main_image_fkey FOREIGN KEY (main_image) REFERENCES public.images(url) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: images images_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.images
    ADD CONSTRAINT images_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: itineraries itineraries_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.itineraries
    ADD CONSTRAINT itineraries_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: itineraries itineraries_id_contact_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.itineraries
    ADD CONSTRAINT itineraries_id_contact_fkey FOREIGN KEY (id_contact) REFERENCES public.contacts(id) ON DELETE CASCADE;


--
-- Name: itineraries itineraries_id_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.itineraries
    ADD CONSTRAINT itineraries_id_created_by_fkey FOREIGN KEY (id_created_by) REFERENCES auth.users(id) ON DELETE SET NULL;


--
-- Name: itinerary_items itinerary_items_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.itinerary_items
    ADD CONSTRAINT itinerary_items_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: itinerary_items itinerary_items_airline_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.itinerary_items
    ADD CONSTRAINT itinerary_items_airline_fkey FOREIGN KEY (airline) REFERENCES public.airlines(id) ON DELETE SET NULL;


--
-- Name: itinerary_items itinerary_items_id_itinerary_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.itinerary_items
    ADD CONSTRAINT itinerary_items_id_itinerary_fkey FOREIGN KEY (id_itinerary) REFERENCES public.itineraries(id) ON DELETE CASCADE;


--
-- Name: locations locations_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE;


--
-- Name: notes notes_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT notes_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: notes notes_itinerary_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT notes_itinerary_item_id_fkey FOREIGN KEY (itinerary_item_id) REFERENCES public.itinerary_items(id) ON DELETE CASCADE;


--
-- Name: passenger passenger_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.passenger
    ADD CONSTRAINT passenger_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE;


--
-- Name: passenger passenger_itinerary_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.passenger
    ADD CONSTRAINT passenger_itinerary_id_fkey FOREIGN KEY (itinerary_id) REFERENCES public.itineraries(id) ON DELETE CASCADE;


--
-- Name: points_of_interest points_of_interest_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.points_of_interest
    ADD CONSTRAINT points_of_interest_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: regions regions_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: transactions transactions_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE;


--
-- Name: transactions transactions_id_item_itinerary_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_id_item_itinerary_fkey FOREIGN KEY (id_item_itinerary) REFERENCES public.itinerary_items(id);


--
-- Name: transactions transactions_id_itinerary_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_id_itinerary_fkey FOREIGN KEY (id_itinerary) REFERENCES public.itineraries(id);


--
-- Name: transactions transactions_id_itineray_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_id_itineray_fkey FOREIGN KEY (id_itinerary) REFERENCES public.itineraries(id) ON DELETE CASCADE;


--
-- Name: transfer_rates transfer_rates_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transfer_rates
    ADD CONSTRAINT transfer_rates_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: transfer_rates transfer_rates_id_transfer_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transfer_rates
    ADD CONSTRAINT transfer_rates_id_transfer_fkey FOREIGN KEY (id_transfer) REFERENCES public.transfers(id) ON DELETE CASCADE;


--
-- Name: transfers transfers_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transfers
    ADD CONSTRAINT transfers_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: transfers transfers_id_contact_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transfers
    ADD CONSTRAINT transfers_id_contact_fkey FOREIGN KEY (id_contact) REFERENCES public.contacts(id) ON DELETE CASCADE;


--
-- Name: transfers transfers_location_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transfers
    ADD CONSTRAINT transfers_location_fkey FOREIGN KEY (location) REFERENCES public.locations(id) ON DELETE SET NULL;


--
-- Name: transfers transfers_main_image_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transfers
    ADD CONSTRAINT transfers_main_image_fkey FOREIGN KEY (main_image) REFERENCES public.images(url) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: user_roles user_roles_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: user_roles user_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: user_roles user_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: activities Enable delete super_admin, admin, operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable delete super_admin, admin, operations" ON public.activities FOR DELETE USING ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text)) AND (user_roles.account_id = activities.account_id)))));


--
-- Name: activities_rates Enable delete super_admin, admin, operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable delete super_admin, admin, operations" ON public.activities_rates FOR DELETE USING ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text)) AND (user_roles.account_id = activities_rates.account_id)))));


--
-- Name: contacts Enable delete super_admin, admin, operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable delete super_admin, admin, operations" ON public.contacts FOR DELETE USING ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text)) AND (user_roles.account_id = contacts.account_id)))));


--
-- Name: hotel_rates Enable delete super_admin, admin, operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable delete super_admin, admin, operations" ON public.hotel_rates FOR DELETE USING ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text)) AND (user_roles.account_id = hotel_rates.account_id)))));


--
-- Name: hotels Enable delete super_admin, admin, operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable delete super_admin, admin, operations" ON public.hotels FOR DELETE USING ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text)) AND (user_roles.account_id = hotels.account_id)))));


--
-- Name: transfer_rates Enable delete super_admin, admin, operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable delete super_admin, admin, operations" ON public.transfer_rates FOR DELETE USING ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text)) AND (user_roles.account_id = transfer_rates.account_id)))));


--
-- Name: transfers Enable delete super_admin, admin, operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable delete super_admin, admin, operations" ON public.transfers FOR DELETE USING ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text)) AND (user_roles.account_id = transfers.account_id)))));


--
-- Name: images Enable delete super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable delete super_admin, admin, operations, agent" ON public.images FOR DELETE USING ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text) OR (roles.role_name = 'agent'::text)) AND (user_roles.account_id = images.account_id)))));


--
-- Name: itineraries Enable delete super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable delete super_admin, admin, operations, agent" ON public.itineraries FOR DELETE USING ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND (((roles.role_name = 'agent'::text) AND (itineraries.id_created_by = ( SELECT auth.uid() AS uid))) OR (roles.role_name = ANY (ARRAY['super_admin'::text, 'admin'::text, 'operations'::text]))) AND (user_roles.account_id = itineraries.account_id)))));


--
-- Name: itinerary_items Enable delete super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable delete super_admin, admin, operations, agent" ON public.itinerary_items FOR DELETE USING ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text) OR (roles.role_name = 'agent'::text)) AND (user_roles.account_id = itinerary_items.account_id)))));


--
-- Name: passenger Enable delete super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable delete super_admin, admin, operations, agent" ON public.passenger FOR DELETE USING ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text) OR (roles.role_name = 'agent'::text)) AND (user_roles.account_id = passenger.account_id)))));


--
-- Name: transactions Enable delete super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable delete super_admin, admin, operations, agent" ON public.transactions FOR DELETE USING ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text)) AND (user_roles.account_id = transactions.account_id)))));


--
-- Name: activities Enable insert super_admin, admin, operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable insert super_admin, admin, operations" ON public.activities FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text)) AND (user_roles.account_id = activities.account_id)))));


--
-- Name: hotels Enable insert super_admin, admin, operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable insert super_admin, admin, operations" ON public.hotels FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text)) AND (user_roles.account_id = hotels.account_id)))));


--
-- Name: transfers Enable insert super_admin, admin, operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable insert super_admin, admin, operations" ON public.transfers FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text)) AND (user_roles.account_id = transfers.account_id)))));


--
-- Name: activities_rates Enable insert super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable insert super_admin, admin, operations, agent" ON public.activities_rates FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text)) AND (user_roles.account_id = activities_rates.account_id)))));


--
-- Name: contacts Enable insert super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable insert super_admin, admin, operations, agent" ON public.contacts FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text) OR (roles.role_name = 'agent'::text)) AND (user_roles.account_id = contacts.account_id)))));


--
-- Name: hotel_rates Enable insert super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable insert super_admin, admin, operations, agent" ON public.hotel_rates FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text)) AND (user_roles.account_id = hotel_rates.account_id)))));


--
-- Name: images Enable insert super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable insert super_admin, admin, operations, agent" ON public.images FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text) OR (roles.role_name = 'agent'::text)) AND (user_roles.account_id = images.account_id)))));


--
-- Name: itineraries Enable insert super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable insert super_admin, admin, operations, agent" ON public.itineraries FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text) OR (roles.role_name = 'agent'::text)) AND (user_roles.account_id = itineraries.account_id)))));


--
-- Name: itinerary_items Enable insert super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable insert super_admin, admin, operations, agent" ON public.itinerary_items FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text) OR (roles.role_name = 'agent'::text)) AND (user_roles.account_id = itinerary_items.account_id)))));


--
-- Name: passenger Enable insert super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable insert super_admin, admin, operations, agent" ON public.passenger FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text) OR (roles.role_name = 'agent'::text)) AND (user_roles.account_id = passenger.account_id)))));


--
-- Name: transactions Enable insert super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable insert super_admin, admin, operations, agent" ON public.transactions FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text) OR (roles.role_name = 'agent'::text)) AND (user_roles.account_id = transactions.account_id)))));


--
-- Name: transfer_rates Enable insert super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable insert super_admin, admin, operations, agent" ON public.transfer_rates FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text)) AND (user_roles.account_id = transfer_rates.account_id)))));


--
-- Name: activities Enable public read access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable public read access" ON public.activities FOR SELECT USING ((auth.uid() IS NULL));


--
-- Name: airlines Enable public read access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable public read access" ON public.airlines FOR SELECT USING ((auth.uid() IS NULL));


--
-- Name: contacts Enable public read access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable public read access" ON public.contacts FOR SELECT USING ((auth.uid() IS NULL));


--
-- Name: hotels Enable public read access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable public read access" ON public.hotels FOR SELECT USING ((auth.uid() IS NULL));


--
-- Name: images Enable public read access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable public read access" ON public.images FOR SELECT USING ((auth.uid() IS NULL));


--
-- Name: itineraries Enable public read access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable public read access" ON public.itineraries FOR SELECT USING ((auth.uid() IS NULL));


--
-- Name: itinerary_items Enable public read access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable public read access" ON public.itinerary_items FOR SELECT USING ((auth.uid() IS NULL));


--
-- Name: activities Enable read super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable read super_admin, admin, operations, agent" ON public.activities FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text) OR (roles.role_name = 'agent'::text)) AND (user_roles.account_id = activities.account_id)))));


--
-- Name: activities_rates Enable read super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable read super_admin, admin, operations, agent" ON public.activities_rates FOR SELECT USING ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text) OR (roles.role_name = 'agent'::text)) AND (user_roles.account_id = activities_rates.account_id)))));


--
-- Name: airlines Enable read super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable read super_admin, admin, operations, agent" ON public.airlines FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text) OR (roles.role_name = 'agent'::text)) AND (user_roles.account_id = airlines.account_id)))));


--
-- Name: contacts Enable read super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable read super_admin, admin, operations, agent" ON public.contacts FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'agent'::text) OR (roles.role_name = 'operations'::text)) AND (user_roles.account_id = contacts.account_id)))));


--
-- Name: hotel_rates Enable read super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable read super_admin, admin, operations, agent" ON public.hotel_rates FOR SELECT USING ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text) OR (roles.role_name = 'agent'::text)) AND (user_roles.account_id = hotel_rates.account_id)))));


--
-- Name: hotels Enable read super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable read super_admin, admin, operations, agent" ON public.hotels FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text) OR (roles.role_name = 'agent'::text)) AND (user_roles.account_id = hotels.account_id)))));


--
-- Name: images Enable read super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable read super_admin, admin, operations, agent" ON public.images FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text) OR (roles.role_name = 'agent'::text)) AND (user_roles.account_id = images.account_id)))));


--
-- Name: itineraries Enable read super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable read super_admin, admin, operations, agent" ON public.itineraries FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text) OR (roles.role_name = 'agent'::text)) AND (user_roles.account_id = itineraries.account_id)))));


--
-- Name: itinerary_items Enable read super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable read super_admin, admin, operations, agent" ON public.itinerary_items FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text) OR (roles.role_name = 'agent'::text)) AND (user_roles.account_id = itinerary_items.account_id)))));


--
-- Name: passenger Enable read super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable read super_admin, admin, operations, agent" ON public.passenger FOR SELECT USING ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text) OR (roles.role_name = 'agent'::text)) AND (user_roles.account_id = passenger.account_id)))));


--
-- Name: transactions Enable read super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable read super_admin, admin, operations, agent" ON public.transactions FOR SELECT USING ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text) OR (roles.role_name = 'agent'::text)) AND (user_roles.account_id = transactions.account_id)))));


--
-- Name: transfer_rates Enable read super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable read super_admin, admin, operations, agent" ON public.transfer_rates FOR SELECT USING ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text) OR (roles.role_name = 'agent'::text)) AND (user_roles.account_id = transfer_rates.account_id)))));


--
-- Name: transfers Enable read super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable read super_admin, admin, operations, agent" ON public.transfers FOR SELECT USING ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text) OR (roles.role_name = 'agent'::text)) AND (user_roles.account_id = transfers.account_id)))));


--
-- Name: activities Enable update super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable update super_admin, admin, operations, agent" ON public.activities FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text)) AND (user_roles.account_id = activities.account_id))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text)) AND (user_roles.account_id = activities.account_id)))));


--
-- Name: activities_rates Enable update super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable update super_admin, admin, operations, agent" ON public.activities_rates FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text)) AND (user_roles.account_id = activities_rates.account_id))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text)) AND (user_roles.account_id = activities_rates.account_id)))));


--
-- Name: contacts Enable update super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable update super_admin, admin, operations, agent" ON public.contacts FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text) OR (roles.role_name = 'agent'::text)) AND (user_roles.account_id = contacts.account_id))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text) OR (roles.role_name = 'agent'::text)) AND (user_roles.account_id = contacts.account_id)))));


--
-- Name: hotel_rates Enable update super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable update super_admin, admin, operations, agent" ON public.hotel_rates FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text)) AND (user_roles.account_id = hotel_rates.account_id))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text)) AND (user_roles.account_id = hotel_rates.account_id)))));


--
-- Name: hotels Enable update super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable update super_admin, admin, operations, agent" ON public.hotels FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text) OR (roles.role_name = 'agent'::text)) AND (user_roles.account_id = hotels.account_id))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text) OR (roles.role_name = 'agent'::text)) AND (user_roles.account_id = hotels.account_id)))));


--
-- Name: images Enable update super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable update super_admin, admin, operations, agent" ON public.images FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text) OR (roles.role_name = 'agent'::text)) AND (user_roles.account_id = images.account_id))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text) OR (roles.role_name = 'agent'::text)) AND (user_roles.account_id = images.account_id)))));


--
-- Name: itineraries Enable update super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable update super_admin, admin, operations, agent" ON public.itineraries FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND (((roles.role_name = 'agent'::text) AND (itineraries.id_created_by = ( SELECT auth.uid() AS uid))) OR (roles.role_name = ANY (ARRAY['super_admin'::text, 'admin'::text, 'operations'::text]))) AND (user_roles.account_id = itineraries.account_id))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND (((roles.role_name = 'agent'::text) AND (itineraries.id_created_by = ( SELECT auth.uid() AS uid))) OR (roles.role_name = ANY (ARRAY['super_admin'::text, 'admin'::text, 'operations'::text]))) AND (user_roles.account_id = itineraries.account_id)))));


--
-- Name: itinerary_items Enable update super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable update super_admin, admin, operations, agent" ON public.itinerary_items FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text) OR (roles.role_name = 'agent'::text)) AND (user_roles.account_id = itinerary_items.account_id))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text) OR (roles.role_name = 'agent'::text)) AND (user_roles.account_id = itinerary_items.account_id)))));


--
-- Name: passenger Enable update super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable update super_admin, admin, operations, agent" ON public.passenger FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text) OR (roles.role_name = 'agent'::text)) AND (user_roles.account_id = passenger.account_id))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text) OR (roles.role_name = 'agent'::text)) AND (user_roles.account_id = passenger.account_id)))));


--
-- Name: transactions Enable update super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable update super_admin, admin, operations, agent" ON public.transactions FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text)) AND (user_roles.account_id = transactions.account_id))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text)) AND (user_roles.account_id = transactions.account_id)))));


--
-- Name: transfer_rates Enable update super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable update super_admin, admin, operations, agent" ON public.transfer_rates FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text)) AND (user_roles.account_id = transfer_rates.account_id))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text)) AND (user_roles.account_id = transfer_rates.account_id)))));


--
-- Name: transfers Enable update super_admin, admin, operations, agent; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable update super_admin, admin, operations, agent" ON public.transfers FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text) OR (roles.role_name = 'agent'::text)) AND (user_roles.account_id = transfers.account_id))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.user_roles
     JOIN public.roles ON ((user_roles.role_id = roles.id)))
  WHERE ((user_roles.user_id = ( SELECT auth.uid() AS uid)) AND ((roles.role_name = 'super_admin'::text) OR (roles.role_name = 'admin'::text) OR (roles.role_name = 'operations'::text) OR (roles.role_name = 'agent'::text)) AND (user_roles.account_id = transfers.account_id)))));


--
-- Name: activities; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.activities ENABLE ROW LEVEL SECURITY;

--
-- Name: activities_rates; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.activities_rates ENABLE ROW LEVEL SECURITY;

--
-- Name: contacts; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.contacts ENABLE ROW LEVEL SECURITY;

--
-- Name: hotel_rates; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.hotel_rates ENABLE ROW LEVEL SECURITY;

--
-- Name: hotels; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.hotels ENABLE ROW LEVEL SECURITY;

--
-- Name: images; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.images ENABLE ROW LEVEL SECURITY;

--
-- Name: itineraries; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.itineraries ENABLE ROW LEVEL SECURITY;

--
-- Name: itinerary_items; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.itinerary_items ENABLE ROW LEVEL SECURITY;

--
-- Name: transactions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;

--
-- Name: transfer_rates; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.transfer_rates ENABLE ROW LEVEL SECURITY;

--
-- Name: transfers; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.transfers ENABLE ROW LEVEL SECURITY;

--
-- PostgreSQL database dump complete
--

