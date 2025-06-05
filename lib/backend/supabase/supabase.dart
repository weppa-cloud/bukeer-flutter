import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;
import '../../flutter_flow/flutter_flow_util.dart';
import '../../config/app_config.dart';

export 'database/database.dart';
export 'storage/storage.dart';

class SupaFlow {
  SupaFlow._();

  static SupaFlow? _instance;
  static SupaFlow get instance => _instance ??= SupaFlow._();

  final _supabase = Supabase.instance.client;
  static SupabaseClient get client => instance._supabase;

  static Future initialize() {
    // Log configuration in debug mode
    AppConfig.logConfig();
    
    // Validate configuration before initializing
    if (!AppConfig.isConfigValid) {
      throw Exception('Invalid Supabase configuration. Check your environment variables.');
    }
    
    return Supabase.initialize(
      url: AppConfig.supabaseUrl,
      headers: {
        'X-Client-Info': 'flutterflow',
      },
      anonKey: AppConfig.supabaseAnonKey,
      debug: AppConfig.debugMode,
      authOptions:
          FlutterAuthClientOptions(authFlowType: AuthFlowType.implicit),
    );
  }
}
