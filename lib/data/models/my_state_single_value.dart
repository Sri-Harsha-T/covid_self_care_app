import 'package:covid_self_care_app/misc/helper.dart';
import 'package:flutter/cupertino.dart';

class MyStateSingleValue {
  Map<String, String> stateNamesMap = {
    "AN": "Andaman and Nicobar Islands",
    "AP": "Andhra Pradesh",
    "AR": "Arunachal Pradesh",
    "AS": "Assam",
    "BR": "Bihar",
    "CH": "Chandigarh",
    "CT": "Chhattisgarh",
    "DD": "Daman and Diu",
    "DL": "Delhi",
    "DN": "Dadra and Nagar Heveli",
    "GA": "Goa",
    "GJ": "Gujarat",
    "HP": "Himachal Pradesh",
    "HR": "Haryana",
    "JH": "Jharkhand",
    "JK": "Jammu and Kashmir",
    "KA": "Karnataka",
    "KL": "Kerala",
    "LA": "Ladakh",
    "LD": "Lakshadweep",
    "MH": "Maharashtra",
    "ML": "Meghalaya",
    "MN": "Manipur",
    "MP": "Madhya Pradesh",
    "MZ": "Mizoram",
    "NL": "Nagaland",
    "OR": "Odisha",
    "PB": "Punjab",
    "PY": "Puduchery",
    "RJ": "Rajasthan",
    "SK": "Sikkim",
    "TG": "Telangana",
    "TN": "Tamil Nadu",
    "TR": "Tripura",
    "TT": "Total",
    "UP": "Uttar Pradesh",
    "UT": "Uttarakhand",
    "WB": "West Bengal",
  };

  late String _stateCode;
  late String _status;
  late String _stateName;
  late int _value;
  late String _dateString;
  late DateTime _date;

  MyStateSingleValue({required String stateCode, required String status, required int value, required String dateString}) {
    _stateCode = stateCode;
    _stateName = stateNamesMap[stateCode.toUpperCase()].toString();
    _status = status;
    _value = value != null ? value : 0;
    _dateString = dateString;
    _date = Helper.parseDateTimeDDMMMYY(dateString);
  }

  set stateCode(String stateCode) => _stateCode = stateCode;
  set status(String status) => _status = status;
  set statename(String stateCode) => _stateName = stateNamesMap[stateCode.toUpperCase()].toString();
  set value(int value) => _value = value;
  set dateString(String dateString) => _dateString = dateString;
  set date(DateTime date) => _date = date;

  String get stateCode => _stateCode;
  String get stateName => _stateName;
  String get status => _status;
  int get value => _value;
  String get dateString => _dateString;
  DateTime get date => _date;

  bool equals({required String stateCode}) {
    if (stateCode.toUpperCase() == _stateCode || stateCode.toLowerCase() == _stateCode) return true;
    return false;
  }

  bool dateEquals(String dateString) {
    return _dateString == dateString;
  }

  @override
  String toString() {
    // TODO: implement toString
    return " $stateName : { stateCode : $stateCode, status : $status, value : $value, dateString : $dateString, date : ${date.toString()}} ";
  }
}
