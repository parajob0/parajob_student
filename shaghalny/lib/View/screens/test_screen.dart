import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mrx_charts/mrx_charts.dart';
import '/color_const.dart';

import '../components/balance_screen/doted_line.dart';

class test extends StatefulWidget {
  const test({Key? key}) : super(key: key);

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {

  List<ChartLineDataItem> values = [
    ChartLineDataItem(value: 966, x: (0 * (DateTime(2021, 12).millisecondsSinceEpoch - DateTime(2021, 1).millisecondsSinceEpoch) / 4.0)
        + DateTime(2021, 1).millisecondsSinceEpoch),
    ChartLineDataItem(value: 800, x: (1 * (DateTime(2021, 12).millisecondsSinceEpoch - DateTime(2021, 1).millisecondsSinceEpoch) / 4.0)
        + DateTime(2021, 1).millisecondsSinceEpoch),
    ChartLineDataItem(value: 0, x: (2 * (DateTime(2021, 12).millisecondsSinceEpoch - DateTime(2021, 1).millisecondsSinceEpoch) / 4.0)
        + DateTime(2021, 1).millisecondsSinceEpoch),
    ChartLineDataItem(value: 0, x: (3 * (DateTime(2021, 12).millisecondsSinceEpoch - DateTime(2021, 1).millisecondsSinceEpoch) / 4.0)
        + DateTime(2021, 1).millisecondsSinceEpoch),
    ChartLineDataItem(value: 1455, x: (4 * (DateTime(2021, 12).millisecondsSinceEpoch - DateTime(2021, 1).millisecondsSinceEpoch) / 4.0)
        + DateTime(2021, 1).millisecondsSinceEpoch),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 20.0,
            ),
            child: GestureDetector(
              onTap: () => setState(() {}),
              child: const Icon(
                Icons.refresh,
                size: 26.0,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: const Text('Line'),
      ),
      backgroundColor: primary,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxHeight: 400.0,
            maxWidth: 600.0,
          ),
          padding: const EdgeInsets.all(24.0),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Chart(
                layers: layers(),
                padding: const EdgeInsets.symmetric(horizontal: 30.0).copyWith(
                  bottom: 25.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  List<ChartLayer> layers() {
    final from = DateTime(2021, 1);
    final to = DateTime(2021, 12);
    final frequency =
        (to.millisecondsSinceEpoch - from.millisecondsSinceEpoch) / 4.0;
    return [
      ChartHighlightLayer(
        shape: () => ChartHighlightLineShape<ChartLineDataItem>(
          backgroundColor: primary,
          currentPos: (item) => item.currentValuePos,
          radius: const BorderRadius.all(Radius.circular(8.0)),
          width: 60.0,
        ),
      ),
      ChartAxisLayer(
        settings: ChartAxisSettings(
          x: ChartAxisSettingsAxis(
            frequency: frequency,
            max: to.millisecondsSinceEpoch.toDouble(),
            min: from.millisecondsSinceEpoch.toDouble(),
            textStyle: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 10.0,
            ),
          ),
          y: ChartAxisSettingsAxis(
            frequency: 500.0,
            max: 1500.0,
            min: 0.0,
            textStyle: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 10.0,
            ),
          ),
        ),
        labelX: (value) => DateFormat('MMM')
            .format(DateTime.fromMillisecondsSinceEpoch(value.toInt())),
        labelY: (value) => value.toInt().toString(),
      ),
      ChartLineLayer(
        // items: List.generate(
        //   5,
        //       (index) => ChartLineDataItem(
        //     x: (index * frequency) + from.millisecondsSinceEpoch,
        //     value: Random().nextInt(1500) + 20,
        //   ),
        // ),
        items: values,
        settings: const ChartLineSettings(
          color: secondary,
          thickness: 2.0,
        ),
      ),
      ChartTooltipLayer(
        shape: () => ChartTooltipLineShape<ChartLineDataItem>(
          backgroundColor: Colors.white,
          circleBackgroundColor: Colors.white,
          circleBorderColor: const Color(0xFF331B6D),
          circleSize: 4.0,
          circleBorderThickness: 2.0,
          currentPos: (item) => item.currentValuePos,
          onTextValue: (item) => 'EGP ${item.value.toString()}',
          marginBottom: 2.0,
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 8.0,
          ),
          radius: 6.0,
          textStyle: const TextStyle(
            color: Color(0xFF8043F9),
            letterSpacing: 0.2,
            fontSize: 14.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ];
  }

}
