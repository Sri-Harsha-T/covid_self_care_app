import 'dart:convert';

import 'package:covid_self_care_app/data/models/daily_data.dart';
import 'package:covid_self_care_app/data/models/my_state_data.dart';
import 'package:covid_self_care_app/data/models/my_state_single_value.dart';
import 'package:covid_self_care_app/data/models/single_day_data.dart';
import 'package:http/http.dart' as http;


abstract class PatientRepository {
  Future<Map<String, List>> fetchPatientData();
  Future<Map<String, List<MyStateSingleValue>>> fetchStatePatientDailyData(String stateCode);
  Future<List<MyStateData>> fetchDistrictWiseData(String stateCode);
}

class CovidPatientRepository extends PatientRepository {
  static const String CLASS_TAG = "PatientRepository";
  @override
  Future<Map<String, List>> fetchPatientData() async {
    Map<String, List> patientDataMap = Map();
    List<MyStateData> stateDataList = [];
    List<DailyData> dailyDataList = [];
    String url = "https://api.covid19india.org/data.json";
    var res = await http.get(Uri.parse(Uri.encodeFull(url)), headers: {
      "Accept": "appplication/json"
    });

    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      var stateWise = data["statewise"] as List;
      var dailyData = data["cases_time_series"] as List;
      stateDataList = stateWise.map<MyStateData>((json) => MyStateData.fromJson(json)).toList();
      patientDataMap["state_wise_data"] = stateDataList;
      dailyDataList = dailyData.map<DailyData>((json) => DailyData.fromJson(json)).toList();
      dailyDataList = dailyDataList.reversed.toList();
      print(dailyDataList[0].totalConfirmed);
      patientDataMap["daily_data"] = dailyDataList;
    } else {
      print("Error Thrown");
      throw Error();
    }
    print("List length: ${stateDataList.length}");
    print(stateDataList[0]);

    return patientDataMap;
  }

  @override
  Future<Map<String, List<MyStateSingleValue>>> fetchStatePatientDailyData(String stateCode) async {
    Map<String, List<MyStateSingleValue>> statePatientDataMap = Map();
    List<MyStateData> statePatientDataList = [];
    List<DailyData> statePatientDailyDataList = [];
    String stateDailyDataUrl = "https://api.covid19india.org/states_daily.json";

    var stateDailyRes = await http.get(Uri.parse(Uri.encodeFull(stateDailyDataUrl)), headers: {
      "Accept": "appplication/json",
    });

    if (stateDailyRes.statusCode == 200) {
      var jsonData = json.decode(stateDailyRes.body);
      var dailyStateData = jsonData["states_daily"] as List;
      var confirmedDailyData = dailyStateData.where((item) => item["status"] == "Confirmed").toList();
      var recoveredDailyData = dailyStateData.where((item) => item["status"] == "Recovered").toList();
      var deathsDailyData = dailyStateData.where((item) => item["status"] == "Deceased").toList();

      var cnfStateDataList = confirmedDailyData.map((item) {
        String date = item["date"];
        List<String> dateStringList = date.split("-");
        dateStringList[dateStringList.length - 1] = "2020";
        date = dateStringList.join("-");
        return MyStateSingleValue(
          stateCode: stateCode,
          status: "Confirmed",
          value: int.tryParse(item[stateCode.toLowerCase()])!.toInt(),
          dateString: date,
        );
      }).toList();
      var rcvrdStateDataList = recoveredDailyData.map((item) {
        String date = item["date"];
        List<String> dateStringList = date.split("-");
        dateStringList[dateStringList.length - 1] = "2020";
        date = dateStringList.join("-");
        return MyStateSingleValue(
          stateCode: stateCode,
          status: "Recovered",
          value: int.tryParse(item[stateCode.toLowerCase()])!.toInt(),
          dateString: date,
        );
      }).toList();
      var deathsStateDataList = deathsDailyData.map((item) {
        String date = item["date"];
        List<String> dateStringList = date.split("-");
        dateStringList[dateStringList.length - 1] = "2020";
        date = dateStringList.join("-");
        return MyStateSingleValue(
          stateCode: stateCode,
          status: "Deaths",
          value: int.tryParse(item[stateCode.toLowerCase()])!.toInt(),
          dateString: date,
        );
      }).toList();
      List<MyStateSingleValue> activeStateDataList = [];
      List<MyStateSingleValue> cnfStateCumulativeDataList = [];
      List<MyStateSingleValue> rcvrdStateCumulativeDataList = [];
      List<MyStateSingleValue> deathsStateCumulativeDataList = [];
      List<MyStateSingleValue> activeStateCumulativeDataList = [];
      int cumulativeCnfValue = 0;
      int cumulativeRcvrdValue = 0;
      int cumulativeDeathsValue = 0;
      int cumulativeActiveValue = 0;
      for (int index = 0; index < cnfStateDataList.length; index++) {
        MyStateSingleValue cnfStateData = cnfStateDataList[index];
        MyStateSingleValue rcvrdStateData = rcvrdStateDataList.firstWhere((item) => item.dateEquals(cnfStateData.dateString));
        MyStateSingleValue deathsStateData = deathsStateDataList.firstWhere((item) => item.dateEquals(cnfStateData.dateString));
        MyStateSingleValue activeStateData = MyStateSingleValue(stateCode: stateCode, status: "Active", dateString: cnfStateData.dateString, value: (cnfStateData.value - rcvrdStateData.value - deathsStateData.value));

        cumulativeCnfValue += cnfStateData.value;
        cumulativeRcvrdValue += rcvrdStateData.value;
        cumulativeDeathsValue += deathsStateData.value;
        cumulativeActiveValue += activeStateData.value;
        activeStateDataList.add(activeStateData);
        cnfStateCumulativeDataList.add(MyStateSingleValue(stateCode: stateCode, status: "Confirmed", dateString: cnfStateData.dateString, value: cumulativeCnfValue));
        rcvrdStateCumulativeDataList.add(MyStateSingleValue(stateCode: stateCode, status: "Recovered", dateString: cnfStateData.dateString, value: cumulativeRcvrdValue));
        deathsStateCumulativeDataList.add(MyStateSingleValue(stateCode: stateCode, status: "Deaths", dateString: cnfStateData.dateString, value: cumulativeDeathsValue));
        activeStateCumulativeDataList.add(MyStateSingleValue(stateCode: stateCode, status: "Active", dateString: cnfStateData.dateString, value: cumulativeActiveValue));
      }

      print("List is: " + activeStateDataList.toString());
      statePatientDataMap["cnf_state_daily_data"] = cnfStateDataList.reversed.toList();
      statePatientDataMap["rcvrd_state_daily_data"] = rcvrdStateDataList.reversed.toList();
      statePatientDataMap["deaths_state_daily_data"] = deathsStateDataList.reversed.toList();
      statePatientDataMap["active_state_daily_data"] = activeStateDataList.reversed.toList();
      statePatientDataMap["cnf_state_cumulative_data"] = cnfStateCumulativeDataList.reversed.toList();
      statePatientDataMap["rcvrd_state_cumulative_data"] = rcvrdStateCumulativeDataList.reversed.toList();
      statePatientDataMap["deaths_state_cumulative_data"] = deathsStateCumulativeDataList.reversed.toList();
      statePatientDataMap["active_state_cumulative_data"] = activeStateCumulativeDataList.reversed.toList();
    } else {
      print("Status Code is not Okay.");
      throw Error();
    }

    return statePatientDataMap;
  }

  @override
  Future<List<MyStateData>> fetchDistrictWiseData(String stateCode) async {
    List<MyStateData> districtWiseData = [];
    String districtWiseUrl = "https://api.covid19india.org/v2/state_district_wise.json";
    var districtWiseRes = await http.get(Uri.parse(Uri.encodeFull(districtWiseUrl)), headers: {
      "Accept": "appplication/json",
    });

    if (districtWiseRes.statusCode == 200) {
      var jsonData = json.decode(districtWiseRes.body) as List;

      var stateData = jsonData.firstWhere((item) => item["statecode"] == stateCode.toUpperCase() || item["statecode"] == stateCode.toLowerCase());
      var districtData = stateData["districtData"] as List;
      districtWiseData = districtData.map<MyStateData>((json) => MyStateData.fromDistrictJson(json)).toList();
    } else {}

    print("District Data Is: ${districtWiseData.toString()}");
    return districtWiseData;
  }
}
