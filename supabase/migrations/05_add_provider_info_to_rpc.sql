-- Update RPC function to include provider information and main image
CREATE OR REPLACE FUNCTION get_complete_itinerary_details(p_itinerary_id UUID)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    result JSON;
BEGIN
    WITH itinerary_data AS (
        SELECT 
            i.*,
            c.name as contact_name,
            c.email as contact_email,
            c.phone as contact_phone,
            json_build_object(
                'id', c.id,
                'name', c.name,
                'email', c.email,
                'phone', c.phone
            ) as contact_data
        FROM itineraries i
        LEFT JOIN contacts c ON i.id_contact = c.id
        WHERE i.id = p_itinerary_id
    ),
    items_data AS (
        SELECT 
            json_agg(
                json_build_object(
                    'id', ii.id,
                    'product_type', ii.product_type,
                    'product_name', ii.product_name,
                    'rate_name', ii.rate_name,
                    'date', ii.date,
                    'destination', ii.destination,
                    'unit_cost', ii.unit_cost,
                    'unit_price', ii.unit_price,
                    'quantity', ii.quantity,
                    'total_cost', ii.total_cost,
                    'total_price', ii.total_price,
                    'profit', ii.profit,
                    'profit_percentage', ii.profit_percentage,
                    'hotel_nights', ii.hotel_nights,
                    'flight_departure', ii.flight_departure,
                    'flight_arrival', ii.flight_arrival,
                    'departure_time', ii.departure_time,
                    'arrival_time', ii.arrival_time,
                    'flight_number', ii.flight_number,
                    'airline', ii.airline,
                    'reservation_status', ii.reservation_status,
                    'start_time', ii.start_time,
                    'end_time', ii.end_time,
                    'day_number', ii.day_number,
                    'order', ii.order,
                    'id_product', ii.id_product,
                    -- Get main_image from the related product
                    'main_image', CASE 
                        WHEN ii.product_type = 'Hoteles' THEN (SELECT main_image FROM hotels WHERE id = ii.id_product)
                        WHEN ii.product_type = 'Servicios' THEN (SELECT main_image FROM activities WHERE id = ii.id_product)
                        WHEN ii.product_type = 'Transporte' THEN (SELECT main_image FROM transfers WHERE id = ii.id_product)
                        ELSE NULL
                    END,
                    -- Get provider information
                    'provider_name', CASE 
                        WHEN ii.product_type = 'Hoteles' THEN (
                            SELECT c.name 
                            FROM hotels h 
                            LEFT JOIN contacts c ON h.id_contact = c.id 
                            WHERE h.id = ii.id_product
                        )
                        WHEN ii.product_type = 'Servicios' THEN (
                            SELECT c.name 
                            FROM activities a 
                            LEFT JOIN contacts c ON a.id_contact = c.id 
                            WHERE a.id = ii.id_product
                        )
                        WHEN ii.product_type = 'Transporte' THEN (
                            SELECT c.name 
                            FROM transfers t 
                            LEFT JOIN contacts c ON t.id_contact = c.id 
                            WHERE t.id = ii.id_product
                        )
                        ELSE NULL
                    END,
                    'provider_id', CASE 
                        WHEN ii.product_type = 'Hoteles' THEN (SELECT id_contact FROM hotels WHERE id = ii.id_product)
                        WHEN ii.product_type = 'Servicios' THEN (SELECT id_contact FROM activities WHERE id = ii.id_product)
                        WHEN ii.product_type = 'Transporte' THEN (SELECT id_contact FROM transfers WHERE id = ii.id_product)
                        ELSE NULL
                    END
                ) ORDER BY ii.date, ii.order
            ) as all_items
        FROM itinerary_items ii
        WHERE ii.id_itinerary = p_itinerary_id
    ),
    items_grouped AS (
        SELECT 
            json_build_object(
                'all_items', COALESCE((SELECT all_items FROM items_data), '[]'::json),
                'flights', COALESCE((
                    SELECT json_agg(item) 
                    FROM itinerary_items ii,
                    LATERAL (
                        SELECT json_build_object(
                            'id', ii.id,
                            'product_name', ii.product_name,
                            'date', ii.date,
                            'airline', ii.airline,
                            'flight_number', ii.flight_number,
                            'flight_departure', ii.flight_departure,
                            'flight_arrival', ii.flight_arrival,
                            'departure_time', ii.departure_time,
                            'arrival_time', ii.arrival_time,
                            'quantity', ii.quantity,
                            'unit_price', ii.unit_price,
                            'total_price', ii.total_price,
                            'reservation_status', ii.reservation_status
                        ) as item
                    ) items
                    WHERE ii.id_itinerary = p_itinerary_id 
                    AND ii.product_type = 'Vuelos'
                ), '[]'::json),
                'hotels', COALESCE((
                    SELECT json_agg(item)
                    FROM itinerary_items ii
                    LEFT JOIN hotels h ON ii.id_product = h.id
                    LEFT JOIN contacts c ON h.id_contact = c.id,
                    LATERAL (
                        SELECT json_build_object(
                            'id', ii.id,
                            'product_name', ii.product_name,
                            'rate_name', ii.rate_name,
                            'date', ii.date,
                            'destination', ii.destination,
                            'hotel_nights', ii.hotel_nights,
                            'quantity', ii.quantity,
                            'unit_cost', ii.unit_cost,
                            'unit_price', ii.unit_price,
                            'total_price', ii.total_price,
                            'profit_percentage', ii.profit_percentage,
                            'reservation_status', ii.reservation_status,
                            'main_image', h.main_image,
                            'provider_name', c.name,
                            'provider_id', h.id_contact
                        ) as item
                    ) items
                    WHERE ii.id_itinerary = p_itinerary_id 
                    AND ii.product_type = 'Hoteles'
                ), '[]'::json),
                'activities', COALESCE((
                    SELECT json_agg(item)
                    FROM itinerary_items ii
                    LEFT JOIN activities a ON ii.id_product = a.id
                    LEFT JOIN contacts c ON a.id_contact = c.id,
                    LATERAL (
                        SELECT json_build_object(
                            'id', ii.id,
                            'product_name', ii.product_name,
                            'date', ii.date,
                            'destination', ii.destination,
                            'start_time', ii.start_time,
                            'quantity', ii.quantity,
                            'unit_price', ii.unit_price,
                            'total_price', ii.total_price,
                            'reservation_status', ii.reservation_status,
                            'rate_name', ii.rate_name,
                            'unit_cost', ii.unit_cost,
                            'profit_percentage', ii.profit_percentage,
                            'main_image', a.main_image,
                            'provider_name', c.name,
                            'provider_id', a.id_contact
                        ) as item
                    ) items
                    WHERE ii.id_itinerary = p_itinerary_id 
                    AND ii.product_type = 'Servicios'
                ), '[]'::json),
                'transfers', COALESCE((
                    SELECT json_agg(item)
                    FROM itinerary_items ii
                    LEFT JOIN transfers t ON ii.id_product = t.id
                    LEFT JOIN contacts c ON t.id_contact = c.id,
                    LATERAL (
                        SELECT json_build_object(
                            'id', ii.id,
                            'product_name', ii.product_name,
                            'date', ii.date,
                            'start_time', ii.start_time,
                            'quantity', ii.quantity,
                            'unit_price', ii.unit_price,
                            'total_price', ii.total_price,
                            'reservation_status', ii.reservation_status,
                            'destination', ii.destination,
                            'rate_name', ii.rate_name,
                            'unit_cost', ii.unit_cost,
                            'profit_percentage', ii.profit_percentage,
                            'main_image', t.main_image,
                            'provider_name', c.name,
                            'provider_id', t.id_contact
                        ) as item
                    ) items
                    WHERE ii.id_itinerary = p_itinerary_id 
                    AND ii.product_type = 'Transporte'
                ), '[]'::json)
            ) as grouped_items
    ),
    totals_data AS (
        SELECT 
            json_build_object(
                'flights', COALESCE(SUM(CASE WHEN product_type = 'Vuelos' THEN total_price ELSE 0 END), 0),
                'hotels', COALESCE(SUM(CASE WHEN product_type = 'Hoteles' THEN total_price ELSE 0 END), 0),
                'activities', COALESCE(SUM(CASE WHEN product_type = 'Servicios' THEN total_price ELSE 0 END), 0),
                'transfers', COALESCE(SUM(CASE WHEN product_type = 'Transporte' THEN total_price ELSE 0 END), 0),
                'total', COALESCE(SUM(total_price), 0),
                'total_cost', COALESCE(SUM(total_cost), 0),
                'total_profit', COALESCE(SUM(profit), 0)
            ) as totals
        FROM itinerary_items
        WHERE id_itinerary = p_itinerary_id
    ),
    passengers_data AS (
        SELECT 
            COALESCE(json_agg(
                json_build_object(
                    'id', p.id,
                    'name', p.name,
                    'last_name', p.last_name,
                    'full_name', p.name || ' ' || p.last_name,
                    'type_id', p.type_id,
                    'number_id', p.number_id,
                    'nationality', p.nationality,
                    'birth_date', p.birth_date
                ) ORDER BY p.name
            ), '[]'::json) as passengers
        FROM passenger p
        WHERE p.itinerary_id = p_itinerary_id
    ),
    transactions_data AS (
        SELECT 
            COALESCE(json_agg(
                json_build_object(
                    'id', t.id,
                    'type', t.type,
                    'value', t.value,
                    'date', t.date,
                    'created_at', t.created_at
                ) ORDER BY t.created_at DESC
            ), '[]'::json) as transactions,
            COALESCE(SUM(CASE WHEN t.type = 'ingreso' THEN t.value ELSE 0 END), 0) as total_paid,
            COALESCE(SUM(CASE WHEN t.type = 'egreso' THEN t.value ELSE 0 END), 0) as total_paid_to_providers
        FROM transactions t
        WHERE t.id_itinerary = p_itinerary_id
    )
    SELECT json_build_object(
        'itinerary', row_to_json(itinerary_data),
        'items_grouped', (SELECT grouped_items FROM items_grouped),
        'totals', (SELECT totals FROM totals_data),
        'passengers', (SELECT passengers FROM passengers_data),
        'transactions', (SELECT transactions FROM transactions_data),
        'payment_summary', json_build_object(
            'total_paid', (SELECT total_paid FROM transactions_data),
            'total_paid_to_providers', (SELECT total_paid_to_providers FROM transactions_data),
            'balance', (SELECT i.total_amount - COALESCE((SELECT total_paid FROM transactions_data), 0) 
                       FROM itineraries i WHERE i.id = p_itinerary_id)
        ),
        'summary', json_build_object(
            'has_flights', EXISTS(SELECT 1 FROM itinerary_items WHERE id_itinerary = p_itinerary_id AND product_type = 'Vuelos'),
            'has_hotels', EXISTS(SELECT 1 FROM itinerary_items WHERE id_itinerary = p_itinerary_id AND product_type = 'Hoteles'),
            'has_activities', EXISTS(SELECT 1 FROM itinerary_items WHERE id_itinerary = p_itinerary_id AND product_type = 'Servicios'),
            'has_transfers', EXISTS(SELECT 1 FROM itinerary_items WHERE id_itinerary = p_itinerary_id AND product_type = 'Transporte'),
            'total_items', (SELECT COUNT(*) FROM itinerary_items WHERE id_itinerary = p_itinerary_id),
            'total_passengers', (SELECT COUNT(*) FROM passenger WHERE itinerary_id = p_itinerary_id),
            'total_transactions', (SELECT COUNT(*) FROM transactions WHERE id_itinerary = p_itinerary_id)
        )
    ) INTO result
    FROM itinerary_data;
    
    RETURN result;
END;
$$;