import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/code_pane.dart';
import '../widgets/repo_qr_card.dart';

class InstallCliSlide extends FlutterDeckSlideWidget {
  const InstallCliSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/install-cli',
          title: 'Installing the Supabase CLI',
          speakerNotes:
              '- We use the CLI for migrations now and for generating the '
              'typed models later\n'
              '- Homebrew on macOS and Linux, Scoop on Windows\n'
              '- No package manager? npx supabase runs it without '
              'installing, it only needs Node\n'
              '- supabase login opens the browser and stores an access '
              'token, the type generator reuses it\n'
              '- Docker is only needed for the local stack with supabase '
              'start, a hosted project works without it\n'
              '- Ask everyone to run supabase --version before moving on, '
              'generating Dart types needs a recent CLI, 2.120 has it',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.split(
      leftBuilder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(32, 32, 32, 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FlutterDeckBulletList(
              items: [
                'One binary for migrations, the local stack, and type '
                    'generation',
                'Homebrew on macOS and Linux, Scoop on Windows',
                'supabase login connects it to your account',
                'Docker is only needed for the local stack',
              ],
            ),
            const SizedBox(height: 40),
            const RepoQrCard(
              label: 'Installation guide',
              url:
                  'https://supabase.com/docs/guides/local-development/cli/'
                  'getting-started?queryGroups=platform&platform=npm'
                  '#installing-the-supabase-cli',
              displayUrl: 'supabase.com/docs/guides/local-development/cli',
            ),
          ],
        ),
      ),
      rightBuilder: (context) => const CodePane(
        fileName: 'install.sh',
        code: '''
# macOS and Linux
brew install supabase/tap/supabase

# Windows
scoop bucket add supabase \\
    https://github.com/supabase/scoop-bucket.git
scoop install supabase

# Or run it through Node without installing
npx supabase --version

# Check it works, then sign in
supabase --version
supabase login''',
      ),
    );
  }
}
