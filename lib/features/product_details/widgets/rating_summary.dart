import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


class RatingSummary extends StatelessWidget {
  const RatingSummary({
    super.key,
    required this.counter,
    this.average = 0.0,
    this.showAverage = true,
    this.averageStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 40,
    ),
    this.counterFiveStars = 0,
    this.counterFourStars = 0,
    this.counterThreeStars = 0,
    this.counterTwoStars = 0,
    this.counterOneStars = 0,
    this.labelCounterFiveStars = '5',
    this.labelCounterFourStars = '4',
    this.labelCounterThreeStars = '3',
    this.labelCounterTwoStars = '2',
    this.labelCounterOneStars = '1',
    this.labelCounterFiveStarsStyle =
        const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    this.labelCounterFourStarsStyle =
        const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    this.labelCounterThreeStarsStyle =
        const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    this.labelCounterTwoStarsStyle =
        const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    this.labelCounterOneStarsStyle =
        const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    this.label = 'Ratings',
    this.labelStyle = const TextStyle(fontWeight: FontWeight.w600),
    this.color = Colors.amber,
    this.backgroundColor = const Color(0xFFEEEEEE),
  });

  /// The total number of ratings.
  ///
  /// This is the number of ratings that will be displayed in the [label].
  final int counter;

  /// The average rating.
  ///
  /// This is the average rating that will be displayed when [showAverage] is true.
  /// You can use the [averageStyle] to customize the look of the average rating.
  /// The default value is 0.0.
  /// This value will NOT be calculated from the given parameters.
  final double average;

  /// Whether to show the average rating.
  ///
  /// If true, the average rating will be displayed. If not specified, the default value is true.
  final bool showAverage;

  /// The style of the [average] rating.
  ///
  /// You can use this to customize the look of it.
  /// The default value is a bold font size of 40.
  final TextStyle averageStyle;

  /// The number of ratings with 5 stars.
  ///
  /// This is the number of ratings with 5 stars that will be displayed in the [_ReviewBar].
  /// The default value is 0.
  final int counterFiveStars;

  /// The number of ratings with 4 stars.
  ///
  /// This is the number of ratings with 4 stars that will be displayed in the [_ReviewBar].
  /// The default value is 0.
  final int counterFourStars;

  /// The number of ratings with 3 stars.
  ///
  /// This is the number of ratings with 3 stars that will be displayed in the [_ReviewBar].
  /// The default value is 0.
  final int counterThreeStars;

  /// The number of ratings with 2 stars.
  ///
  /// This is the number of ratings with 2 stars that will be displayed in the [_ReviewBar].
  /// The default value is 0.
  final int counterTwoStars;

  /// The number of ratings with 1 stars.
  ///
  /// This is the number of ratings with 1 stars that will be displayed in the [_ReviewBar].
  final int counterOneStars;

  /// The label of the [counterFiveStars].
  ///
  /// It will be displayed left of the [_ReviewBar] with 5 stars. The default value is '5'.
  final String labelCounterFiveStars;

  /// The label of the [counterFourStars].
  ///
  /// It will be displayed left of the [_ReviewBar] with 4 stars. The default value is '4'.
  final String labelCounterFourStars;

  /// The label of the [counterThreeStars].
  ///
  /// It will be displayed left of the [_ReviewBar] with 3 stars. The default value is '3'.
  final String labelCounterThreeStars;

  /// The label of the [counterTwoStars].
  ///
  /// It will be displayed left of the [_ReviewBar] with 2 stars. The default value is '2'.
  final String labelCounterTwoStars;

  /// The label of the [counterOneStars].
  ///
  /// It will be displayed left of the [_ReviewBar] with 1 stars. The default value is '1'.
  final String labelCounterOneStars;

  /// The style of the [labelCounterFiveStars].
  ///
  /// You can use this to customize the look of it. The default value is a bold font size of 14.
  final TextStyle labelCounterFiveStarsStyle;

  /// The style of the [labelCounterFourStars].
  ///
  /// You can use this to customize the look of it. The default value is a bold font size of 14.
  final TextStyle labelCounterFourStarsStyle;

  /// The style of the [labelCounterThreeStars].
  ///
  /// You can use this to customize the look of it. The default value is a bold font size of 14.
  final TextStyle labelCounterThreeStarsStyle;

  /// The style of the [labelCounterTwoStars].
  ///
  /// You can use this to customize the look of it. The default value is a bold font size of 14.
  final TextStyle labelCounterTwoStarsStyle;

  /// The style of the [labelCounterOneStars].
  ///
  /// You can use this to customize the look of it. The default value is a bold font size of 14.
  final TextStyle labelCounterOneStarsStyle;

  /// The label of the [counter]
  ///
  /// It will be displayed below the [average] counter with stars. It only appears when [showAverage] is true.
  final String label;

  /// The style of the [label].
  ///
  /// You can use this to customize the look of it. The default value is a semi-bold font.
  final TextStyle labelStyle;

  /// The color of the stars and the horizontal bar [_ReviewBar].
  ///
  /// The default value is Colors.amber.
  final Color color;

  /// The color of the unused stars and the background of the horizontal bar [_ReviewBar].
  ///
  /// The default value is Color(0xFFEEEEEE).
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ReviewBar(
                label: labelCounterFiveStars,
                labelStyle: labelCounterFiveStarsStyle,
                value: counter==0? 0: counterFiveStars / counter,
                color: color,
                backgroundColor: backgroundColor,
              ),
              _ReviewBar(
                label: labelCounterFourStars,
                labelStyle: labelCounterFourStarsStyle,
                value: counter==0? 0:  counterFourStars / counter,
                color: color,
                backgroundColor: backgroundColor,
              ),
              _ReviewBar(
                label: labelCounterThreeStars,
                labelStyle: labelCounterThreeStarsStyle,
                value: counter==0? 0:  counterThreeStars / counter,
                color: color,
                backgroundColor: backgroundColor,
              ),
              _ReviewBar(
                label: labelCounterTwoStars,
                labelStyle: labelCounterTwoStarsStyle,
                value: counter==0? 0:  counterTwoStars / counter,
                color: color,
                backgroundColor: backgroundColor,
              ),
              _ReviewBar(
                label: labelCounterOneStars,
                labelStyle: labelCounterOneStarsStyle,
                value: counter==0? 0:  counterOneStars / counter,
                color: color,
                backgroundColor: backgroundColor,
              ),
            ],
          ),
        ),
        if (showAverage) ...[
          const SizedBox(width: 30),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(average.toStringAsFixed(2), style: averageStyle),
                RatingBarIndicator(
                  rating: average,
                  itemSize: 28,
                  unratedColor: backgroundColor,
                  itemBuilder: (context, index) {
                    return Icon(Icons.star, color: color);
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  "$counter $label",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.fade,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// A widget that displays a horizontal bar with a label.
///
/// Example:
/// ```dart
///  _ReviewBar(
///    label: "5",
///    value: counterFiveStars / counter,
///    color: color,
///    secondaryColor: secondaryColor,
///  )
/// ```
class _ReviewBar extends StatelessWidget {
  const _ReviewBar({
    required this.label,
    required this.value,
    this.color = Colors.amber,
    this.backgroundColor = const Color(0xFFEEEEEE),
    this.labelStyle =
        const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
  });

  /// The label of the bar.
  ///
  /// It will be displayed on the left side of the bar.
  final String label;

  /// Style of the label.
  ///
  /// The default value is a bold font size of 14.
  final TextStyle labelStyle;

  /// The progress value of the bar.
  ///
  /// It must be between 0.0 and 1.0.
  final double value;

  /// The color of the bar.
  ///
  /// The default value is Colors.amber.
  final Color color;

  /// The backgroundcolor of the bar.
  ///
  /// The default value is Color(0xFFEEEEEE).
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: labelStyle,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 10,
                child: LinearProgressIndicator(
                  value: value,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  backgroundColor: backgroundColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}