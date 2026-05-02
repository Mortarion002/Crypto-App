// Run with: flutter run --dart-define-from-file=.env.json
// Copy .env.example.json → .env.json and fill in your values.
class Env {
  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://vhnkcjubcmerwebfteoq.supabase.co',
  );
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
}
