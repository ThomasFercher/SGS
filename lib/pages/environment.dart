import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/general/appBarHeader.dart';
import 'package:sgs/customwidgets/climate/activeClimateControlItem.dart';
import 'package:sgs/customwidgets/climate/climateControlItem.dart';
import 'package:sgs/customwidgets/general/popupMenu.dart';
import 'package:sgs/customwidgets/general/sectionTitle.dart';
import 'package:sgs/objects/appTheme.dart';
import 'package:sgs/objects/climateControl.dart';
import 'package:sgs/objects/popupMenuOption.dart';
import 'package:sgs/providers/dataProvider.dart';
import 'package:sgs/providers/settingsProvider.dart';
import 'package:weather_icons/weather_icons.dart';

import '../styles.dart';
import 'editEnvironment.dart';

class Environment extends StatelessWidget {
  List<Widget> getEnvList(
      List<ClimateControl> climates, ClimateControl active, context) {
    List<Widget> cardlist = [];

    climates.forEach((element) {
      if (element.getID != active.getID)
        cardlist.add(ClimateControlItem(settings: element));
    });
    return cardlist;
  }

  List<PopupMenuOption> options = [
    PopupMenuOption(
        "Edit",
        Icon(
          Icons.edit,
          color: primaryColor,
        )),
  ];

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<SettingsProvider>(context).getTheme();
    return Consumer<DataProvider>(builder: (context, d, child) {
      List<ClimateControl> climates = d.climates;
      ClimateControl activeClimate = d.activeClimate;
      var temp = activeClimate.temperature;
      var hum = activeClimate.humidity;
      var soil = activeClimate.soilMoisture;
      var sun = activeClimate.suntime;
      var water = activeClimate.waterConsumption;
      return AppBarHeader(
        isPage: true,
        title: "Climate Control",
        contentPadding: false,
        body: [
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 20.0),
            child: sectionTitle(
                context,
                "Others",
                theme.name == "light"
                    ? theme.secondaryTextColor
                    : theme.headlineColor),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 500 > 400
                ? MediaQuery.of(context).size.height - 500
                : 400,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: getEnvList(climates, d.activeClimate, context),
            ),
          )
        ],
        actionButton: OpenContainer(
          closedBuilder: (_, openContainer) {
            return FloatingActionButton(
              onPressed: openContainer,
              backgroundColor: theme.cardColor,
              child: Icon(Icons.add, color: primaryColor),
              elevation: 2.0,
            );
          },
          closedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(100))),
          closedColor: theme.background,
          openBuilder: (_, closeContainer) {
            return EditEnvironment(
              initialSettings: new ClimateControl(
                name: "",
                temperature: 0,
                humidity: 0,
                soilMoisture: 0,
                suntime: "06:00 - 18:00",
                waterConsumption: 0,
              ),
              create: true,
            );
          },
        ),
        appbarBottom: PreferredSize(
          preferredSize: Size.fromHeight(360),
          child: OpenContainer(
              closedElevation: 0.0,
              closedColor: primaryColor,
              openBuilder: (_, closeContainer) {
                return EditEnvironment(
                  initialSettings: activeClimate,
                  create: false,
                );
              },
              closedBuilder: (_, openContainer) {
                return Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 30, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SectionTitle(
                              title: activeClimate.name,
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            PopupMenu(
                              color: Colors.white,
                              options: options,
                              onSelected: (val) {
                                switch (val) {
                                  case 'Edit':
                                    openContainer();
                                    break;

                                  default:
                                }
                              },
                            )
                          ],
                        ),
                      ),
                      ActiveClimateControlItem(
                        icon: WeatherIcons.thermometer,
                        lable: "Temperature",
                        value: "$temp°C",
                      ),
                      ActiveClimateControlItem(
                        icon: WeatherIcons.humidity,
                        lable: "Humidity",
                        value: "$hum%",
                      ),
                      ActiveClimateControlItem(
                        icon: WeatherIcons.barometer,
                        lable: "Soil Moisture",
                        value: "$soil",
                      ),
                      ActiveClimateControlItem(
                        icon: WeatherIcons.day_sunny,
                        lable: "Suntime",
                        value: sun,
                      ),
                      ActiveClimateControlItem(
                        icon: WeatherIcons.rain,
                        lable: "Water Consumption",
                        value: "$water" + "l/d",
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                      )
                    ],
                  ),
                );
              }),
        ),
      );
    });
  }
}
