import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

class TitleSlide extends FlutterDeckSlideWidget {
  const TitleSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/title',
          title: 'Title',
          speakerNotes:
              '- Welcome everyone\n'
              '- Today we build a real multiplayer game, live\n'
              '- Everything runs on Flutter and Supabase, no game servers',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.custom(
      builder: (context) {
        final theme = FlutterDeckTitleSlideTheme.of(context);
        final configuration = context.flutterDeck.configuration;

        return FlutterDeckSlideBase(
          contentBuilder: (context) => Padding(
            padding: const EdgeInsets.all(64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  const TextSpan(
                    children: [
                      TextSpan(text: 'Building a Real-Time Multiplayer '),
                      TextSpan(
                        text: 'Space',
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      TextSpan(text: ' Game'),
                    ],
                  ),
                  style: theme.titleTextStyle,
                ),
                const SizedBox(height: 8),
                Text('with Flame and Supabase', style: theme.subtitleTextStyle),
              ],
            ),
          ),
          footerBuilder: configuration.footer.showFooter
              ? (context) => FlutterDeckFooter.fromConfiguration(
                  configuration: configuration.footer,
                )
              : null,
          headerBuilder: configuration.header.showHeader
              ? (context) => FlutterDeckHeader.fromConfiguration(
                  configuration: configuration.header,
                )
              : null,
        );
      },
    );
  }
}
