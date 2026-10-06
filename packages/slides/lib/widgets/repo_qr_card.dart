import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../deck_theme.dart';

class RepoQrCard extends StatelessWidget {
  const RepoQrCard({
    required this.label,
    required this.url,
    this.displayUrl,
    this.qrSize = 190,
    this.textScale = 1,
    super.key,
  });

  final String label;
  final String url;
  final String? displayUrl;
  final double qrSize;
  final double textScale;

  @override
  Widget build(BuildContext context) {
    final textTheme = FlutterDeckTheme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(color: deckAccent, width: 3),
        borderRadius: BorderRadius.circular(24),
        color: deckAccent.withValues(alpha: 0.06),
      ),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: QrImageView(
                data: url,
                size: qrSize,
                backgroundColor: Colors.white,
                padding: EdgeInsets.zero,
                errorCorrectionLevel: QrErrorCorrectLevel.Q,
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: Color(0xFF11111A),
                ),
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: Color(0xFF11111A),
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: textTheme.bodyMedium.copyWith(
                    color: deckAccent,
                    fontSize: 22 * textScale,
                  ),
                ),
                const SizedBox(height: 12),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    displayUrl ?? url.replaceFirst('https://', ''),
                    maxLines: 1,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 26 * textScale,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
