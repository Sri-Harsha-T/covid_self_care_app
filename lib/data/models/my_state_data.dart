class MyStateData {
  late String _state;
  late String _stateCode;
  late String _lastUpdatedTime;
  late String _stateNotes;
  late int _active;
  late int _confirmed;
  late int _deaths;
  late int _recovered;
  late int _todayConfirmed;
  late int _todayRecovered;
  late int _todayDeaths;
  late int _todayActive;

  MyStateData({required String state, required String stateCode, required String lastUpdatedTime, required String stateNotes, required int active, required int confirmed, required int deaths, required int recovered, required int todayConfirmed, required int todayRecovered, required int todayDeaths}) {
    this._state = state;
    this._stateCode = stateCode;
    this._lastUpdatedTime = lastUpdatedTime;
    this._stateNotes = stateNotes;
    this._active = active;
    this._confirmed = confirmed;
    this._deaths = deaths;
    this._recovered = recovered;
    this._todayConfirmed = todayConfirmed;
    this._todayRecovered = todayRecovered;
    this._todayDeaths = todayDeaths;
    this._todayActive = todayConfirmed - todayRecovered - todayDeaths;
  }

  factory MyStateData.fromJson(Map<String, dynamic> json) {
    return MyStateData(
      state: json["state"],
      stateCode: json["statecode"],
      lastUpdatedTime: json["lastupdatedtime"],
      stateNotes: json["statenotes"],
      active: int.tryParse(json["active"]) ?? 0,
      confirmed: int.tryParse(json["confirmed"]) ?? 0,
      recovered: int.tryParse(json["recovered"]) ?? 0,
      deaths: int.tryParse(json["deaths"]) ?? 0,
      todayConfirmed: int.tryParse(json["deltaconfirmed"]) ?? 0,
      todayDeaths: int.tryParse(json["deltadeaths"]) ?? 0,
      todayRecovered: int.tryParse(json["deltarecovered"]) ?? 0,
    );
  }

  factory MyStateData.fromDistrictJson(Map<String, dynamic> districtJson) {
    return MyStateData(
      state: districtJson["district"],
      stateCode: "",
      lastUpdatedTime: "",
      stateNotes: districtJson["notes"],
      active: districtJson["active"],
      confirmed: districtJson["confirmed"],
      recovered: districtJson["recovered"],
      deaths: districtJson["deceased"],
      todayConfirmed: districtJson["delta"]["confirmed"],
      todayRecovered: districtJson["delta"]["recovered"],
      todayDeaths: districtJson["delta"]["deceased"],
    );
  }

  set state(String state) => this._state = state;
  set stateCode(String stateCode) => this._stateCode = stateCode;
  set lastUpdatedTime(String lastUpdatedTime) => this._lastUpdatedTime = lastUpdatedTime;
  set stateNotes(String stateNotes) => this._stateNotes = stateNotes;
  set active(int active) => this._active = active;
  set confirmed(int confirmed) => this._confirmed = confirmed;
  set deaths(int deaths) => this._deaths = deaths;
  set recovered(int recovered) => this._recovered = recovered;
  set todayConfirmed(int todayConfirmed) => this._todayConfirmed = todayConfirmed;
  set todayRecovered(int todayRecovered) => this.todayRecovered = todayRecovered;
  set todayDeaths(int todayDeaths) => this._todayDeaths = todayDeaths;

  String get state => this._state;
  String get stateCode => this._stateCode;
  String get lastUpdatedTime => this._lastUpdatedTime;
  String get stateNotes => this._stateNotes;
  int get active => this._active;
  int get confirmed => this._confirmed;
  int get deaths => this._deaths;
  int get recovered => this._recovered;
  int get todayConfirmed => this._todayConfirmed;
  int get todayRecovered => this._todayRecovered;
  int get todayDeaths => this._todayDeaths;
  int get todayActive => this._todayActive;

  @override
  String toString() {
    String data = "state: " + _state + ", stateCode: " + _stateCode + ", lastUpdatedTime: " + _lastUpdatedTime + ", stateNotes: " + _stateNotes + ", active: " + _active.toString() + ", confirmed:" + _confirmed.toString() + ", deaths: " + _deaths.toString() + ", recovered:" + _recovered.toString() + ", todayConfirmed:" + _todayConfirmed.toString() + ", todayRecovered:" + _todayRecovered.toString() + ", todayDeaths: " + _todayDeaths.toString() + ", todayActive: " + _todayActive.toString();

    return data;
  }
}
