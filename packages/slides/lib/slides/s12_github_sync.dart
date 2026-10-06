import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/code_pane.dart';
import '../widgets/side_bullets.dart';

class GithubSyncSlide extends FlutterDeckSlideWidget {
  const GithubSyncSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/github-sync',
          title: 'Let GitHub apply your migrations',
          speakerNotes:
              '- The point: nobody should be running supabase db push by '
              'hand during the workshop\n'
              '- In the dashboard, open the project, go to Integrations and '
              'connect GitHub\n'
              '- Authorise the Supabase app, pick your fork, and point it at '
              'the supabase directory in the repository root\n'
              '- Choose which git branch is the production branch, main for '
              'us\n'
              '- From then on every push to that branch applies the new '
              'files in supabase/migrations to the project\n'
              '- Migrations run in file name order and each one runs once, '
              'so always add a new file instead of editing an old one\n'
              '- Mention that branching needs to be enabled for the project, '
              'and that supabase link plus supabase db push is still the '
              'manual fallback if the integration is unavailable',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.split(
      leftBuilder: (context) => const SideBullets(
        items: [
          'Connect your GitHub fork to your Supabase project',
          'Point it at the supabase directory and pick main as the '
              'production branch',
          'Every push to main applies the new migration files',
          'Never edit an applied migration, add a new one',
        ],
      ),
      rightBuilder: (context) => const CodePane(
        fileName: 'a schema change, start to finish',
        code: '''
# 1. Add a migration file
supabase migration new add_players

# 2. Write the change
#    supabase/migrations/0002_add_players.sql

# 3. Try it locally
supabase db reset

# 4. Push, and Supabase applies it for you
git add supabase/migrations
git commit -m "Add the players table"
git push

# No supabase link, no supabase db push.''',
      ),
    );
  }
}
