part of 'statewise_bloc.dart';

@immutable
abstract class StatewiseEvent {
  late EventHandler swe;
  StatewiseEvent();
}

class GetPatientData extends StatewiseEvent {
  GetPatientData();
}
