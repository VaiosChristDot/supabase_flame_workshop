class Env {
  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://tjftgzhlvhjskhxcrvvg.supabase.co',
  );

  static const supabaseKey = String.fromEnvironment(
    'SUPABASE_KEY',
    defaultValue: 'sb_publishable_WNkW5mUgnN6-IirToTz6cw_r-wvlGxu',
  );

  static const room = String.fromEnvironment('ROOM', defaultValue: 'main');
}
