-- Script para crear usuario de test en Staging de Bukeer
-- Proyecto: wrgkiastpqituocblopg.supabase.co
-- IMPORTANTE: Ejecutar en el ambiente de STAGING, NO en producción

-- 1. Crear usuario de test para Maestro
INSERT INTO auth.users (
  instance_id,
  id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  created_at,
  updated_at,
  raw_app_meta_data,
  raw_user_meta_data
) VALUES (
  '00000000-0000-0000-0000-000000000000',
  gen_random_uuid(),
  'authenticated',
  'authenticated',
  'maestro_test@bukeer.com',
  crypt('MaestroTest2024!', gen_salt('bf')),
  NOW(),
  NOW(),
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{}'
) ON CONFLICT (email) DO NOTHING;

-- 2. Obtener el ID del usuario
DO $$
DECLARE
  test_user_id uuid;
  admin_role_id int;
BEGIN
  -- Obtener ID del usuario
  SELECT id INTO test_user_id FROM auth.users WHERE email = 'maestro_test@bukeer.com';
  
  -- Obtener ID del rol admin
  SELECT id INTO admin_role_id FROM public.roles WHERE name = 'admin';
  
  -- 3. Asignar rol admin al usuario
  INSERT INTO public.user_roles (user_id, role_id)
  VALUES (test_user_id, admin_role_id)
  ON CONFLICT DO NOTHING;
  
  -- 4. Crear información de contacto del usuario
  INSERT INTO public.user_contact_info (
    user_id,
    name,
    email,
    phone
  ) VALUES (
    test_user_id,
    'Maestro Test User',
    'maestro_test@bukeer.com',
    '+1234567890'
  ) ON CONFLICT (user_id) DO UPDATE SET
    name = EXCLUDED.name,
    email = EXCLUDED.email;
  
  -- 5. Crear algunos datos de prueba iniciales
  
  -- Crear un itinerario de prueba
  INSERT INTO public.itineraries (
    id,
    name,
    description,
    start_date,
    end_date,
    user_id,
    created_at,
    updated_at
  ) VALUES (
    gen_random_uuid(),
    'Test Itinerary - Maestro Automation',
    'Itinerario de prueba para tests automatizados E2E',
    CURRENT_DATE + INTERVAL '7 days',
    CURRENT_DATE + INTERVAL '10 days',
    test_user_id,
    NOW(),
    NOW()
  );
  
  -- Crear algunos contactos de prueba
  INSERT INTO public.contacts (
    user_id,
    name,
    email,
    phone,
    type,
    created_at
  )
  SELECT 
    test_user_id,
    'Test Contact ' || num,
    'test.contact' || num || '@example.com',
    '+123456789' || num,
    'client',
    NOW()
  FROM generate_series(1, 3) AS num;
  
  RAISE NOTICE 'Usuario de test creado exitosamente con ID: %', test_user_id;
  
END $$;

-- 6. Verificar que el usuario se creó correctamente
SELECT 
  u.id,
  u.email,
  u.created_at,
  r.name as role_name,
  uci.name as full_name
FROM auth.users u
LEFT JOIN user_roles ur ON u.id = ur.user_id
LEFT JOIN roles r ON ur.role_id = r.id
LEFT JOIN user_contact_info uci ON u.id = uci.user_id
WHERE u.email = 'maestro_test@bukeer.com';

-- 7. Crear segundo usuario de test (opcional)
INSERT INTO auth.users (
  instance_id,
  id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  created_at,
  updated_at,
  raw_app_meta_data,
  raw_user_meta_data
) VALUES (
  '00000000-0000-0000-0000-000000000000',
  gen_random_uuid(),
  'authenticated',
  'authenticated',
  'maestro_test2@bukeer.com',
  crypt('MaestroTest2024!', gen_salt('bf')),
  NOW(),
  NOW(),
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{}'
) ON CONFLICT (email) DO NOTHING;

-- Mensaje final
SELECT 'Usuarios de test creados:' AS mensaje
UNION ALL
SELECT '- maestro_test@bukeer.com (Password: MaestroTest2024!)'
UNION ALL
SELECT '- maestro_test2@bukeer.com (Password: MaestroTest2024!)'
UNION ALL
SELECT ''
UNION ALL
SELECT 'Ejecuta los tests con: npm run test:e2e';