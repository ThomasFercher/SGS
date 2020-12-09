import 'dart:async';
import 'dart:collection';
import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/appBarHeader.dart';
import 'package:sgs/customwidgets/datachart.dart';
import 'package:sgs/providers/dashboardProvider.dart';
import '../styles.dart';

class Advanced extends StatelessWidget {
  List<Widget> getItems(DashboardProvider d) {
    return [
      Padding(padding: EdgeInsets.only(top: borderRadius)),
      Container(
        key: const Key("temp"),
        child: DataChart(
          title: "TEMPERATURES",
          data: d.getTemperatures(),
          gradientColors: temperatureGradient,
          unit: "°C",
        ),
      ),
      Container(
        key: const Key("humi"),
        child: DataChart(
          title: "HUMIDITIES",
          data: d.getHumiditys(),
          gradientColors: humidityGradient,
          unit: "%",
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, d, child) {
        return AppBarHeader(
          title: "Advanced Data",
          isPage: true,
          theme: getTheme(),
          body: getItems(d),
          contentPadding: false,
        );
      },
    );
  }
}
