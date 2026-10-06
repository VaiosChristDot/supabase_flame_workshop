import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/code_pane.dart';
import '../widgets/side_bullets.dart';

class SchemaSlide extends FlutterDeckSlideWidget {
  const SchemaSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/schema',
          title: 'What does your game need to store?',
          speakerNotes:
              '- Moment to moment state travels over Broadcast and Presence '
              'and is never stored, so it needs no tables\n'
              '- The database is for what should outlive a round: scores, '
              'profiles, match history, unlocks\n'
              '- The scores table from the repository may already be all '
              'you need\n'
              '- If your game needs more, write it as a new migration and '
              'push, the GitHub integration applies it\n'
              '- Key rows to the auth user id and turn on row level '
              'security for every table, the publishable key is public\n'
              '- Never let a client write its own result: on the right every '
              'player votes for the winner they saw, one vote each, and the '
              'view only reports a winner that more than half agree on\n'
              '- Nobody can read the raw votes, there is no select policy, '
              'only the view is exposed\n'
              '- It is still an example: a real game would also check that '
              'the voters actually played that match',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.split(
      leftBuilder: (context) => const SideBullets(
        items: [
          'Live state rides on Realtime and needs no tables',
          'Postgres holds what outlives a round',
          'Row level security on every table, keyed to the auth user id',
          'Do not trust one client: let the majority decide the winner',
          'A new migration file, pushed, and GitHub applies it',
        ],
      ),
      rightBuilder: (context) => const CodePane(
        fileName: 'supabase/migrations/0002_match_votes.sql',
        code: '''
create table public.match_votes (
  match_id uuid not null,
  voter uuid not null references auth.users (id),
  winner uuid not null references auth.users (id),
  primary key (match_id, voter)
);

alter table public.match_votes enable row level security;

create policy "Players cast their own vote"
  on public.match_votes for insert
  with check (auth.uid() = voter);

create view public.match_winners as
  select match_id, winner
  from public.match_votes
  group by match_id, winner
  having count(*) > (
    select count(*) / 2.0 from public.match_votes v
    where v.match_id = match_votes.match_id
  );''',
      ),
    );
  }
}
