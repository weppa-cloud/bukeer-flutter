#!/bin/bash

echo "🧪 Ejecutando tests que compilan correctamente..."
echo "================================================"

# Lista de tests que sabemos que funcionan
WORKING_TESTS=(
  "test/services/authorization_service_test.dart"
  "test/services/contact_service_test.dart"
  "test/services/user_service_test.dart"
  "test/services/ui_state_service_test.dart"
  "test/api/api_calls_test.dart"
  "test/api/api_manager_test.dart"
  "test/custom_actions/calculate_functions_test.dart"
  "test/custom_actions/calculate_total_test.dart"
)

PASSED=0
FAILED=0

for test in "${WORKING_TESTS[@]}"; do
  echo ""
  echo "▶️  Ejecutando: $test"
  if flutter test "$test" --no-pub > /dev/null 2>&1; then
    echo "✅ PASSED: $test"
    ((PASSED++))
  else
    echo "❌ FAILED: $test"
    ((FAILED++))
  fi
done

echo ""
echo "================================================"
echo "📊 Resumen de Tests:"
echo "   ✅ Passed: $PASSED"
echo "   ❌ Failed: $FAILED"
echo "   📋 Total: $((PASSED + FAILED))"
echo "================================================"