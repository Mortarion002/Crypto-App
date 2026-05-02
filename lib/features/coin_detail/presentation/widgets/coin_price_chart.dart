import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:crypto_pulse/features/coin_detail/domain/entities/kline_point.dart';
import 'package:crypto_pulse/core/theme/app_colors.dart';
import 'package:crypto_pulse/core/theme/app_radius.dart';

class CoinPriceChart extends StatelessWidget {
  final List<KlinePoint> klines;
  final bool isBullish;

  const CoinPriceChart({
    super.key,
    required this.klines,
    required this.isBullish,
  });

  @override
  Widget build(BuildContext context) {
    if (klines.isEmpty) {
      return const SizedBox(height: 300, child: Center(child: Text('No chart data')));
    }

    final color = isBullish ? AppColors.mint : AppColors.vibrantCoral;
    
    // Find min and max for Y axis scaling
    double minPrice = klines.first.low;
    double maxPrice = klines.first.high;
    for (final point in klines) {
      if (point.low < minPrice) minPrice = point.low;
      if (point.high > maxPrice) maxPrice = point.high;
    }

    // Add some padding to min/max
    final priceDiff = maxPrice - minPrice;
    minPrice -= priceDiff * 0.1;
    maxPrice += priceDiff * 0.1;

    final spots = klines.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.close);
    }).toList();

    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.canvasLevel1,
        borderRadius: AppRadius.lgRadius,
      ),
      padding: const EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
      child: LineChart(
        LineChartData(
          minY: minPrice,
          maxY: maxPrice,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: priceDiff == 0 ? 1 : priceDiff / 4,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: AppColors.surfaceBright.withOpacity(0.5),
                strokeWidth: 1,
                dashArray: [5, 5],
              );
            },
          ),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => AppColors.surfaceContainerHigh,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    '\$${spot.y.toStringAsFixed(2)}',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: color,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: color.withOpacity(0.1),
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.3), color.withOpacity(0.0)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
