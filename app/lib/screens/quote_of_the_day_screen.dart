import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// Full-screen destination for the split-flap "quote of the day" board,
/// reached by tapping the [QuoteTeaserCard] on the home screen. The board
/// fills the available width (16px padding on either side), centered on
/// the page beneath a title.
class QuoteOfTheDayScreen extends StatelessWidget {
  const QuoteOfTheDayScreen({
    super.key,
    required this.quoteText,
    this.splitFlapDuration = const Duration(milliseconds: 350),
  });

  final String quoteText;

  /// Overridable mainly so tests aren't stuck waiting out the full
  /// reference scramble length.
  final Duration splitFlapDuration;

  static const double _horizontalPadding = AppSpacing.md; // 16
  static const double _titleGap = AppSpacing.lg; // 24

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: _horizontalPadding,
          ),
          // Centers vertically when the board fits; falls back to
          // scrolling instead of overflowing on shorter screens, since
          // the board's height scales with its width (12x4 grid at a
          // fixed tile aspect ratio) and can outgrow a short viewport.
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Quote of the day',
                        textAlign: TextAlign.center,
                        style: AppTypography.title.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: _titleGap),
                      SplitFlapBoard(
                        text: quoteText,
                        duration: splitFlapDuration,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
