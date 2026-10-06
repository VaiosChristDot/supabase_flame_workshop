import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_deck_web_client/flutter_deck_web_client.dart';
import 'package:google_fonts/google_fonts.dart';

import 'deck_theme.dart';
import 'slides/s01_title.dart';
import 'slides/s02_speakers.dart';
import 'slides/s03_agenda.dart';
import 'slides/s04_why_serverless.dart';
import 'slides/s05_architecture.dart';
import 'slides/s06_credits.dart';
import 'slides/s07_typed_v3.dart';
import 'slides/s08_v2_vs_v3.dart';
import 'slides/s09_setup.dart';
import 'slides/s10_install_cli.dart';
import 'slides/s11_github_sync.dart';
import 'slides/s12_migration.dart';
import 'slides/s13_skeleton.dart';
import 'slides/s14_run_the_game.dart';
import 'slides/s15_exercise_setup.dart';
import 'slides/s16_flame_intro.dart';
import 'slides/s17_components.dart';
import 'slides/s18_game_loop.dart';
import 'slides/s19_player.dart';
import 'slides/s20_input.dart';
import 'slides/s21_camera.dart';
import 'slides/s22_exercise_move.dart';
import 'slides/s23_shared_seed.dart';
import 'slides/s24_obstacles.dart';
import 'slides/s25_exercise_world.dart';
import 'slides/s26_realtime.dart';
import 'slides/s27_connect.dart';
import 'slides/s28_events.dart';
import 'slides/s29_exercise_connect.dart';
import 'slides/s30_state_sync.dart';
import 'slides/s31_dead_reckoning.dart';
import 'slides/s32_exercise_sync.dart';
import 'slides/s33_presence.dart';
import 'slides/s34_phases.dart';
import 'slides/s35_round_start.dart';
import 'slides/s36_exercise_lobby.dart';
import 'slides/s37_shooting.dart';
import 'slides/s38_victim_auth.dart';
import 'slides/s39_death.dart';
import 'slides/s40_win.dart';
import 'slides/s41_exercise_combat.dart';
import 'slides/s42_disconnects.dart';
import 'slides/s43_exercise_disconnects.dart';
import 'slides/s44_typegen.dart';
import 'slides/s45_typed_tables.dart';
import 'slides/s46_typed_stream.dart';
import 'slides/s47_exercise_leaderboard.dart';
import 'slides/s48_demo.dart';
import 'slides/s49_stretch.dart';
import 'slides/s50_thanks.dart';

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  runApp(const WorkshopSlides());
}

class WorkshopSlides extends StatelessWidget {
  const WorkshopSlides({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterDeckApp(
      client: FlutterDeckWebClient(),
      configuration: FlutterDeckConfiguration(
        footer: const FlutterDeckFooterConfiguration(
          showSlideNumbers: true,
          showSocialHandle: true,
        ),
        header: const FlutterDeckHeaderConfiguration(showHeader: false),
        slideSize: FlutterDeckSlideSize.fromAspectRatio(
          aspectRatio: const FlutterDeckAspectRatio.ratio16x9(),
          resolution: const FlutterDeckResolution.fhd(),
        ),
        transition: const FlutterDeckTransition.fade(),
      ),
      lightTheme: buildDeckTheme(),
      darkTheme: buildDeckTheme(),
      themeMode: ThemeMode.dark,
      slides: const [
        TitleSlide(),
        SpeakersSlide(),
        AgendaSlide(),
        WhyServerlessSlide(),
        ArchitectureSlide(),
        CreditsSlide(),
        TypedV3Slide(),
        V2VersusV3Slide(),
        SetupSlide(),
        InstallCliSlide(),
        GithubSyncSlide(),
        MigrationSlide(),
        SkeletonSlide(),
        RunTheGameSlide(),
        ExerciseSetupSlide(),
        FlameIntroSlide(),
        ComponentsSlide(),
        GameLoopSlide(),
        PlayerSlide(),
        InputSlide(),
        CameraSlide(),
        ExerciseMoveSlide(),
        SharedSeedSlide(),
        ObstaclesSlide(),
        ExerciseWorldSlide(),
        RealtimeSlide(),
        ConnectSlide(),
        EventsSlide(),
        ExerciseConnectSlide(),
        StateSyncSlide(),
        DeadReckoningSlide(),
        ExerciseSyncSlide(),
        PresenceSlide(),
        PhasesSlide(),
        RoundStartSlide(),
        ExerciseLobbySlide(),
        ShootingSlide(),
        VictimAuthSlide(),
        DeathSlide(),
        WinSlide(),
        ExerciseCombatSlide(),
        DisconnectsSlide(),
        ExerciseDisconnectsSlide(),
        TypegenSlide(),
        TypedTablesSlide(),
        TypedStreamSlide(),
        ExerciseLeaderboardSlide(),
        DemoSlide(),
        StretchSlide(),
        ThanksSlide(),
      ],
    );
  }
}
