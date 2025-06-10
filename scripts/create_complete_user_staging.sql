-- Limpiar datos anteriores
DELETE FROM public.user_roles WHERE user_id = 'a08ae0ff-24c0-4895-b552-96a4bead229e';
DELETE FROM public.contacts WHERE user_id = 'a08ae0ff-24c0-4895-b552-96a4bead229e';
DELETE FROM auth.identities WHERE user_id = 'a08ae0ff-24c0-4895-b552-96a4bead229e';
DELETE FROM auth.users WHERE id = 'a08ae0ff-24c0-4895-b552-96a4bead229e';

-- Verificar que los roles existen
SELECT * FROM public.roles;

-- Crear usuario en auth.users
INSERT INTO auth.users (
    id,
    instance_id,
    email,
    encrypted_password,
    email_confirmed_at,
    created_at,
    updated_at,
    raw_app_meta_data,
    raw_user_meta_data,
    aud,
    role,
    confirmation_token,
    recovery_token,
    email_change_token_new,
    email_change
) VALUES (
    'a08ae0ff-24c0-4895-b552-96a4bead229e',
    '00000000-0000-0000-0000-000000000000',
    'admin@staging.com',
    crypt('password123', gen_salt('bf')),
    now(),
    now(),
    now(),
    jsonb_build_object('provider', 'email', 'providers', array['email']),
    jsonb_build_object(),
    'authenticated',
    'authenticated',
    '',
    '',
    '',
    ''
);

-- Crear identidad
INSERT INTO auth.identities (
    id,
    provider_id,
    user_id,
    identity_data,
    provider,
    last_sign_in_at,
    created_at,
    updated_at
) VALUES (
    gen_random_uuid(),
    'admin@staging.com',
    'a08ae0ff-24c0-4895-b552-96a4bead229e',
    jsonb_build_object(
        'email', 'admin@staging.com',
        'email_verified', true,
        'phone_verified', false,
        'sub', 'a08ae0ff-24c0-4895-b552-96a4bead229e'
    ),
    'email',
    now(),
    now(),
    now()
);

-- Crear contacto (necesario para la relación)
INSERT INTO public.contacts (
    id,
    name,
    last_name,
    email,
    phone,
    user_id,
    created_at,
    updated_at,
    account_id,
    is_client,
    is_provider,
    is_company
) VALUES (
    gen_random_uuid(),
    'Admin',
    'Staging',
    'admin@staging.com',
    '+57 300 000 0000',
    'a08ae0ff-24c0-4895-b552-96a4bead229e',
    now(),
    now(),
    '9fc24733-b127-4184-aa22-12f03b98927a', -- ColombiaTours.Travel
    false,
    false,
    false
);

-- Asignar rol super_admin (id = 1)
INSERT INTO public.user_roles (
    user_id,
    role_id,
    created_at,
    account_id
) VALUES (
    'a08ae0ff-24c0-4895-b552-96a4bead229e',
    1, -- super_admin
    now(),
    '9fc24733-b127-4184-aa22-12f03b98927a'
);

-- Verificar creación
SELECT 
    u.email,
    u.id as user_id,
    c.name || ' ' || c.last_name as full_name,
    r.role_name,
    a.name as account_name
FROM auth.users u
JOIN public.contacts c ON c.user_id = u.id
JOIN public.user_roles ur ON ur.user_id = u.id
JOIN public.roles r ON r.id = ur.role_id
JOIN public.accounts a ON a.id = ur.account_id
WHERE u.email = 'admin@staging.com';