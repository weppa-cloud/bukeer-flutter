// Runtime configuration template for Bukeer application
// Copy this file to config.js and update with your actual values
// IMPORTANT: Never commit config.js to version control

window.BukeerConfig = {
  // Supabase Configuration
  // Get these values from your Supabase project settings
  supabaseUrl: 'https://your-project.supabase.co',
  supabaseAnonKey: 'your-supabase-anon-key',
  
  // API Configuration
  // Your backend API base URL
  apiBaseUrl: 'https://your-api.example.com/api',
  
  // Google Maps Configuration
  // Get this from Google Cloud Console
  googleMapsApiKey: 'your-google-maps-api-key',
  
  // Environment
  // Options: 'development' | 'staging' | 'production'
  environment: 'development',
  
  // Feature Flags (optional)
  // Control feature availability without code changes
  features: {
    enableAnalytics: false,      // Enable/disable analytics tracking
    enableDebugLogs: true,       // Enable/disable debug logging
    enableOfflineMode: false     // Enable/disable offline functionality
  },
  
  // Additional Configuration (optional)
  settings: {
    sessionTimeout: 3600000,     // Session timeout in milliseconds (default: 1 hour)
    maxRetries: 3,               // Maximum API retry attempts
    requestTimeout: 30000        // API request timeout in milliseconds (default: 30 seconds)
  }
};

// Freeze the configuration object to prevent modifications
Object.freeze(window.BukeerConfig);
Object.freeze(window.BukeerConfig.features);
Object.freeze(window.BukeerConfig.settings);

/* 
 * SETUP INSTRUCTIONS:
 * 
 * 1. Copy this file to config.js in the same directory
 *    cp config.example.js config.js
 * 
 * 2. Update config.js with your actual values
 * 
 * 3. Add config.js to .gitignore to prevent committing sensitive data
 *    echo "web/config.js" >> .gitignore
 * 
 * 4. For production deployments:
 *    - Create config.js on the server with production values
 *    - Or use environment-specific config files (config.prod.js, config.dev.js)
 *    - Or inject values during CI/CD pipeline
 * 
 * 5. The application will validate all required fields on startup
 *    and provide helpful error messages if configuration is missing
 */