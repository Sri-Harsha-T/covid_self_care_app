import 'package:covid_self_care_app/data/models/custom_radio_model.dart';
import 'package:covid_self_care_app/data/models/my_state_single_value.dart';
import 'package:covid_self_care_app/data/models/single_day_data.dart';
import 'package:covid_self_care_app/misc/helper.dart';
import 'package:covid_self_care_app/ui/widgets/custom_radio_button.dart';
import 'package:covid_self_care_app/ui/widgets/date_value.dart';
import 'package:covid_self_care_app/ui/widgets/touched_data_capsule.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StateCombinedChart extends StatefulWidget {
  final Map<String, List<MyStateSingleValue>> statePatientDataMap;
  final accentColor = Colors.blueAccent;
  final cnfChartColor = Colors.blueAccent;
  final activeChartColor = Colors.amberAccent[700];
  final rcvrdChartColor = Colors.greenAccent[700];
  final deathsChartColor = Colors.redAccent;

  List<MyStateSingleValue> confirmedCumulativeList = [];
  List<MyStateSingleValue> activeCumulativeList = [];
  List<MyStateSingleValue> recoveredCumulativeList = [];
  List<MyStateSingleValue> deathsCumulativeList = [];
  List<MyStateSingleValue> confirmedDailyList = [];
  List<MyStateSingleValue> activeDailyList = [];
  List<MyStateSingleValue> recoveredDailyList = [];
  List<MyStateSingleValue> deathsDailyList = [];

  StateCombinedChart({required Key key, required this.statePatientDataMap}) : super(key: key) {
    confirmedCumulativeList = this.statePatientDataMap["cnf_state_cumulative_data"]!;
    activeCumulativeList = this.statePatientDataMap["active_state_cumulative_data"]!;
    recoveredCumulativeList = this.statePatientDataMap["rcvrd_state_cumulative_data"]!;
    deathsCumulativeList = this.statePatientDataMap["deaths_state_cumulative_data"]!;
    confirmedDailyList = this.statePatientDataMap["cnf_state_daily_data"]!;
    activeDailyList = this.statePatientDataMap["active_state_daily_data"]!;
    recoveredDailyList = this.statePatientDataMap["rcvrd_state_daily_data"]!;
    deathsDailyList = this.statePatientDataMap["deaths_state_daily_data"]!;
  }

  @override
  _StateCombinedChartState createState() => _StateCombinedChartState();
}

class _StateCombinedChartState extends State<StateCombinedChart> {
  static const int CUMULATIVE_CHART = 0;
  static const int DAILY_CHART = 1;
  static const int ONE_WEEK = 7;
  static const int TWO_WEEKS = 14;
  static const int ONE_MONTH = 30;
  static const int BEGINNING = 0;
  int valueDivider = 10000;
  double valueMultiplier = 10;
  late int chartLength;
  late int selectedValue;
  late String selectedDate;
  late int selectedCnfValue;
  late int selectedActiveValue;
  late int selectedRcvrdValue;
  late int selectedDeathsValue;
  late Color accentColor;
  late double touchedSpotXValue;
  late bool isSpotSelected;
  late int selectedChartType;
  List<MyStateSingleValue> mCnfStateDataList = [];
  List<MyStateSingleValue> mActiveStateDataList = [];
  List<MyStateSingleValue> mRcvrdStateDataList = [];
  List<MyStateSingleValue> mDeathsStateDataList = [];
  @override
  void initState() {
    super.initState();
    chartLength = 14;
    selectedValue = TWO_WEEKS;
    accentColor = Colors.blueAccent;
    mCnfStateDataList = buildLineChartData(widget.confirmedCumulativeList, chartLength);
    mActiveStateDataList = buildLineChartData(widget.activeCumulativeList, chartLength);
    mRcvrdStateDataList = buildLineChartData(widget.recoveredCumulativeList, chartLength);
    mDeathsStateDataList = buildLineChartData(widget.deathsCumulativeList, chartLength);

    selectedCnfValue = mCnfStateDataList.last.value;
    selectedActiveValue = mActiveStateDataList.last.value;
    selectedRcvrdValue = mRcvrdStateDataList.last.value;
    selectedDeathsValue = mDeathsStateDataList.last.value;
    selectedDate = Helper.formateDateDDMMMYY(mCnfStateDataList.last.date);
    touchedSpotXValue = (chartLength - 1).toDouble();
    selectedChartType = CUMULATIVE_CHART;
    isSpotSelected = true;
    updateValueDividerAndMultiplier(widget.confirmedCumulativeList.first.value);
  }

  @override
  Widget build(BuildContext context) {
    return showChart(context);
  }

  Widget showChart(BuildContext context) {
    //todo: show chart here

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            top: 10,
            left: 16,
            right: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                selectedDate,
                style: TextStyle(
                  color: accentColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 18.0,
                ),
              ),
              Spacer(),
              Text(
                "Cumulative",
                style: TextStyle(
                  color: accentColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 8,
            left: 16,
            right: 16,
            bottom: 8.0,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TouchedDataCapsule(
                  title: "Confirmed",
                  value: selectedCnfValue,
                  color: Colors.blueAccent, key: ObjectKey("tdc"),
                ),
              ),
              Expanded(
                child: TouchedDataCapsule(
                  title: "Active",
                  value: selectedActiveValue,
                  color: Colors.amberAccent[700]!, key: ObjectKey("tdc"),
                ),
              ),
              Expanded(
                child: TouchedDataCapsule(
                  title: "Recovered",
                  value: selectedRcvrdValue,
                  color: Colors.greenAccent[700]!, key: ObjectKey("tdc"),
                ),
              ),
              Expanded(
                child: TouchedDataCapsule(
                  title: "Deaths",
                  value: selectedDeathsValue,
                  color: Colors.redAccent, key: ObjectKey("tdc"),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 8,
            left: 20,
            right: 20,
          ),
          child: Container(
            height: 240,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(),
            child: IntrinsicHeight(
              child: LineChart(
                buildLineChart(
                  cnfStateDataList: mCnfStateDataList,
                  activeStateDataList: mActiveStateDataList,
                  rcvrdStateDataList: mRcvrdStateDataList,
                  deathsStateDataList: mDeathsStateDataList,
                  context: context,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 8,
            bottom: 16,
            left: 16,
            right: 16,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CustomRadioButton(
                customRadioModel: CustomRadioModel(
                  value: 0,
                  title: "Beginning",
                  bgColor: accentColor,
                  selectedValue: selectedValue, isSelected: false,
                ),
                onChanged: () {
                  setState(() {
                    this.chartLength = widget.confirmedCumulativeList.length;
                    this.selectedValue = BEGINNING;
                    isSpotSelected = false;
                    mCnfStateDataList = buildLineChartData(widget.confirmedCumulativeList, chartLength);
                    mActiveStateDataList = buildLineChartData(widget.activeCumulativeList, chartLength);
                    mRcvrdStateDataList = buildLineChartData(widget.recoveredCumulativeList, chartLength);
                    mDeathsStateDataList = buildLineChartData(widget.deathsCumulativeList, chartLength);
                  });
                }, key: ObjectKey("crb"),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: CustomRadioButton(
                  customRadioModel: CustomRadioModel(
                    value: 30,
                    title: "1 Month",
                    bgColor: accentColor,
                    selectedValue: selectedValue, isSelected: false,
                  ),
                  onChanged: () {
                    setState(() {
                      this.chartLength = 30;
                      this.selectedValue = ONE_MONTH;
                      isSpotSelected = false;
                      mCnfStateDataList = buildLineChartData(widget.confirmedCumulativeList, chartLength);
                      mActiveStateDataList = buildLineChartData(widget.activeCumulativeList, chartLength);
                      mRcvrdStateDataList = buildLineChartData(widget.recoveredCumulativeList, chartLength);
                      mDeathsStateDataList = buildLineChartData(widget.deathsCumulativeList, chartLength);
                    });
                  }, key: ObjectKey("crb2"),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: CustomRadioButton(
                  customRadioModel: CustomRadioModel(
                    value: 14,
                    title: "2 Weeks",
                    bgColor: accentColor,
                    selectedValue: selectedValue, isSelected: false,
                  ),
                  onChanged: () {
                    setState(() {
                      this.chartLength = 14;
                      this.selectedValue = TWO_WEEKS;
                      isSpotSelected = false;
                      mCnfStateDataList = buildLineChartData(widget.confirmedCumulativeList, chartLength);
                      mActiveStateDataList = buildLineChartData(widget.activeCumulativeList, chartLength);
                      mRcvrdStateDataList = buildLineChartData(widget.recoveredCumulativeList, chartLength);
                      mDeathsStateDataList = buildLineChartData(widget.deathsCumulativeList, chartLength);
                    });
                  }, key: ObjectKey("crb3"),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: CustomRadioButton(
                  customRadioModel: CustomRadioModel(
                    value: 7,
                    title: "1 Week",
                    bgColor: accentColor,
                    selectedValue: selectedValue, isSelected: false,
                  ),
                  onChanged: () {
                    setState(() {
                      this.chartLength = 7;
                      this.selectedValue = ONE_WEEK;
                      isSpotSelected = false;
                      mCnfStateDataList = buildLineChartData(widget.confirmedCumulativeList, chartLength);
                      mActiveStateDataList = buildLineChartData(widget.activeCumulativeList, chartLength);
                      mRcvrdStateDataList = buildLineChartData(widget.recoveredCumulativeList, chartLength);
                      mDeathsStateDataList = buildLineChartData(widget.deathsCumulativeList, chartLength);
                    });
                  }, key: ObjectKey("crb4"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  LineChartData buildLineChart({required List<MyStateSingleValue> cnfStateDataList, required List<MyStateSingleValue> activeStateDataList, required List<MyStateSingleValue> rcvrdStateDataList, required List<MyStateSingleValue> deathsStateDataList, required BuildContext context}) {
    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: false,
        handleBuiltInTouches: false,
        touchCallback: (FlTouchEvent touchEvent, touchResponse) {
          //todo: show detailed data
          print("TouchInputOffset: " + touchResponse!.lineBarSpots!.first.toString());
          if (touchResponse.lineBarSpots!.length > 0) {
            print("LineBarSpots More than 0");
            MyStateSingleValue cnfSingleValue = cnfStateDataList[touchResponse.lineBarSpots!.first.spotIndex];
            MyStateSingleValue activeSingleValue = activeStateDataList[touchResponse.lineBarSpots!.first.spotIndex];
            MyStateSingleValue rcvrdSingleValue = rcvrdStateDataList[touchResponse.lineBarSpots!.first.spotIndex];
            MyStateSingleValue deathsSingleValue = deathsStateDataList[touchResponse.lineBarSpots!.first.spotIndex];
            print("Date is: " + cnfSingleValue.date.toString());
            setState(() {
              print(touchResponse.lineBarSpots!.first.spotIndex);
              isSpotSelected = true;
              selectedCnfValue = cnfSingleValue.value;
              selectedActiveValue = activeSingleValue.value;
              selectedRcvrdValue = rcvrdSingleValue.value;
              selectedDeathsValue = deathsSingleValue.value;
              selectedDate = Helper.formateDateDDMMMYY(cnfSingleValue.date);
              touchedSpotXValue = touchResponse.lineBarSpots!.first.x;
            });
          } else {
            print("LineBarSpots are equal to 0");
          }
        },
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: widget.accentColor,
          tooltipPadding: EdgeInsets.all(8),
          tooltipRoundedRadius: 8,
          // getTooltipItems: (lineBarSpotList) {
          //   List<LineTooltipItem> lineToolTipItems = List();
          //   lineBarSpotList.forEach(
          //     (lineBarSpot) {
          //       lineToolTipItems.add(
          //         LineTooltipItem(
          //           Helper.formatNumber(singleDayData[lineBarSpot.spotIndex].value),
          //           TextStyle(
          //             color: Colors.white,
          //             fontWeight: FontWeight.w600,
          //             fontSize: 14,
          //             fontFamily: "Niramit",
          //           ),
          //         ),
          //       );
          //     },
          //   );
          //   return lineToolTipItems;
          // },
        ),
      ),
      gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: true,
          getDrawingVerticalLine: (index) {
            return FlLine(
              color: widget.accentColor.withOpacity(0.25),
              strokeWidth: 1,
            );
          },
          getDrawingHorizontalLine: (index) {
            return FlLine(
              color: widget.accentColor.withOpacity(0.25),
              strokeWidth: 1,
            );
          }),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          margin: 8,
          getTextStyles: (context, value){
            return TextStyle(
              color: widget.accentColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: "Niramit",
            );
          },
          getTitles: (value) => getBottomTitle(index: value, numDays: chartLength, data: cnfStateDataList),
        ),
        leftTitles: SideTitles(
          showTitles: true,
          margin: 8,
          getTitles: (value) => getLeftTitle(index: value, data: cnfStateDataList),
          getTextStyles: (context, value){
            return TextStyle(
              color: widget.accentColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: "Niramit",
            );
          },
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(
          color: widget.accentColor,
          style: BorderStyle.solid,
          width: 1,
        ),
      ),
      minX: 0,
      minY: 0,
      maxY: cnfStateDataList[chartLength - 1].value.toDouble() / valueDivider,
      maxX: (chartLength - 1).toDouble(),
      clipData: FlClipData.none(),
      lineBarsData: [
        buildLineChartBarData(dataList: cnfStateDataList, chartColor: widget.cnfChartColor),
        buildLineChartBarData(dataList: activeStateDataList, chartColor: widget.activeChartColor!),
        buildLineChartBarData(dataList: rcvrdStateDataList, chartColor: widget.rcvrdChartColor!),
        buildLineChartBarData(dataList: deathsStateDataList, chartColor: widget.deathsChartColor),
      ],
    );
  }

  List<MyStateSingleValue> buildLineChartData(List<MyStateSingleValue> fullDataList, int _chartLength) {
    print("=====================Function Called======================");
    List<MyStateSingleValue> tempList = [];
    for (int index = 0; index < _chartLength; index++) {
      tempList.add(fullDataList[index]);
    }
    return tempList.reversed.toList();
  }

  LineChartBarData buildLineChartBarData({
    required List<MyStateSingleValue> dataList,
    required Color chartColor,
  }) {
    return LineChartBarData(
      spots: buildFlSpots(dataList),
      isCurved: true,
      colors: [
        chartColor.withOpacity(0.8)
      ],
      dotData: FlDotData(
        show: true,
        //dotSize: 6,
        //strokeWidth: 2,
        //getStrokeColor: (_, __, ___) {
        //  return chartColor;
        //},
        //getDotColor: (_, __, ___) {
        //  return chartColor;
        //},
        checkToShowDot: (FlSpot flSpot, LineChartBarData lineChartBarData) {
          return touchedSpotXValue == flSpot.x && isSpotSelected;
        },
          getDotPainter: (FlSpot flSpot, __, LineChartBarData lineChartBarData, ___){
            FlDotCirclePainter p = FlDotCirclePainter();
            p.color = chartColor;
            p.strokeWidth = 2;
            p.radius = 6;
            p.strokeColor = chartColor;
            return p;
          }
      ),
      barWidth: 6,
      isStrokeCapRound: true,
      shadow: Shadow(blurRadius: 0, color: Colors.transparent, offset: Offset(0, 0)),
      belowBarData: BarAreaData(
        show: true,
        colors: [
          chartColor.withOpacity(0.40),
          chartColor.withOpacity(0.0),
        ],
        gradientColorStops: [
          0.5,
          0.9
        ],
        gradientFrom: Offset(0, 0),
        gradientTo: Offset(0.3, 1),
        spotsLine: BarAreaSpotsLine(
          show: true,
          flLineStyle: FlLine(
            color: chartColor.withOpacity(0.5),
            strokeWidth: 4,
            dashArray: [
              8,
              4
            ],
          ),
          checkToShowSpotLine: (FlSpot flSpot) {
            return touchedSpotXValue == flSpot.x && isSpotSelected;
          },
        ),
      ),
    );
  }

  List<FlSpot> buildFlSpots(List<MyStateSingleValue> singleDayData) {
    List<FlSpot> flSpots = [];
    for (int i = 0; i < singleDayData.length; i++) {
      MyStateSingleValue item = singleDayData[i];
      flSpots.add(FlSpot(i.toDouble(), item.value.toDouble() / valueDivider));
    }
    return flSpots;
  }

  String getBottomTitle({required double index, required int numDays, required List<MyStateSingleValue> data}) {
    if (numDays == 14) {
      if ([
        0,
        3,
        6,
        9,
        12
      ].contains(index.toInt())) {
        return Helper.formateDateDDMMMYY(data[index.toInt()].date);
      }
      return "";
    } else if (numDays == 7) {
      if ([
        1,
        3,
        5
      ].contains(index.toInt())) {
        return Helper.formateDateDDMMMYY(data[index.toInt()].date);
      }
      return "";
    } else if (numDays == 30) {
      if ([
        0,
        7,
        14,
        21,
        28
      ].contains(index.toInt())) {
        return Helper.formateDateDDMMMYY(data[index.toInt()].date);
      }
      return "";
    } else if (numDays == widget.confirmedCumulativeList.length) {
      num numberToSubtract = widget.confirmedCumulativeList.length / 25;
      num numberToDivide = widget.confirmedCumulativeList.length - numberToSubtract.round();
      num numberSteps = double.tryParse((numberToDivide / 4).toString().split(".")[0]) as num;
      if ((numberToDivide) == index.toInt() || index.toInt() == 0) {
        return Helper.formateDateDDMMMYY(data[index.toInt()].date);
      } else if (numberSteps != null && (index.toInt() == numberSteps || index.toInt() == numberSteps * 2 || index.toInt() == numberSteps * 3)) {
        return Helper.formateDateDDMMMYY(data[index.toInt()].date);
      }
    }
    return "";
  }

  String getLeftTitle({required double index, required List<MyStateSingleValue> data}) {
    if (index > 0 && index % .5 == 0) {
      int maxValue = data.last.value;
      String title;
      double value = index * valueMultiplier;
      if (maxValue < 600) {
        title = (value).toDouble().toStringAsFixed(0);
      } else if (maxValue < 3000) {
        title = (value).toDouble().toStringAsFixed(1) + "K";
      } else {
        title = (value).toDouble().toStringAsFixed(0) + "K";
      }
      return title;
    }
    return "";
  }

  void updateValueDividerAndMultiplier(int totalValue) {
    if (totalValue < 120) {
      valueDivider = 20;
      valueMultiplier = 20;
    } else if (totalValue < 600) {
      valueDivider = 100;
      valueMultiplier = 100;
    } else if (totalValue < 1200) {
      valueDivider = 200;
      valueMultiplier = 0.2;
    } else if (totalValue < 3000) {
      valueDivider = 500;
      valueMultiplier = 0.5;
    } else if (totalValue < 6000) {
      valueDivider = 1000;
      valueMultiplier = 1;
    } else if (totalValue < 12000) {
      valueDivider = 2000;
      valueMultiplier = 2;
    } else if (totalValue < 30000) {
      valueDivider = 5000;
      valueMultiplier = 5;
    } else if (totalValue < 60000) {
      valueDivider = 10000;
      valueMultiplier = 10;
    } else if (totalValue < 120000) {
      valueDivider = 20000;
      valueMultiplier = 20;
    } else if (totalValue < 300000) {
      valueDivider = 50000;
      valueMultiplier = 50;
    } else if (totalValue < 600000) {
      valueDivider = 100000;
      valueMultiplier = 100;
    } else if (totalValue < 1200000) {
      valueDivider = 200000;
      valueMultiplier = 200;
    } else if (totalValue < 3000000) {
      valueDivider = 500000;
      valueMultiplier = 500;
    } else if (totalValue < 6000000) {
      valueDivider = 1000000;
      valueMultiplier = 1000;
    }
  }
}