import 'dart:core';

class MyStateDailyData {
   late String _stateCode;
   late String _date;
   late int _confirmed;
   late int _active;
   late int _recovered;
   late int _deaths;

  MyStateDailyData({required String stateCode, required String date, required int confirmed, required int recovered, required int deaths}) {
    this._stateCode = stateCode;
    this._date = date;
    this._confirmed = confirmed;
    this._active = confirmed - recovered - deaths;
    this._recovered = recovered;
    this._deaths = deaths;
  }

  set stateCode(String stateCode) => this._stateCode = stateCode;
  set date(String date) => this._date = date;
  set confirmed(int confirmed) => this._confirmed = confirmed;
  set active(int active) => this._active = active;
  set recovered(int recovered) => this._recovered = recovered;
  set deaths(int deaths) => this._deaths = deaths;

  String get stateCode => this._stateCode;
  String get date => this._date;
  int get confirmed => this._confirmed;
  int get active => this._active;
  int get recovered => this._recovered;
  int get deaths => this._deaths;

factory MyStateDailyData.fromJson(Map<String, dynamic> json) {
  return MyStateDailyData(stateCode: json["statecode"], date: "", confirmed: json["confirmed"], recovered: json["recovered"], deaths: json["deaths"]);
}

}