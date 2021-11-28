import 'dart:async';

import 'package:covid_self_care_app/data/models/my_state_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:covid_self_care_app/data/repos/patientrepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'statewise_event.dart';
part 'statewise_state.dart';

class StatewiseBloc extends Bloc<StatewiseEvent, StatewiseState> {
  final PatientRepository patientRepository;

  StatewiseBloc({required this.patientRepository}):
      //assert(this.patientRepository!=null),
      super(const StatewiseInitial()){
      on<StatewiseEvent> (_onStatewiseEvent);
    }

  StatewiseState get initialState => const StatewiseInitial();


  void _onStatewiseEvent(StatewiseEvent event, Emitter<StatewiseState> emitter){
    // TODO: implement mapEventToState
      //emit(const StatewiseLoading()) ;
      on<GetPatientData>(_onGetPatientData);
      /*if (event is GetPatientData) {
      try {
      final patientData = await patientRepository.fetchPatientData();
      yield StatewiseLoaded(patientDataMap: patientData);
      } catch (error) {
      print(error);
      yield const StatewiseError(error: "Data couldn't be loaded.");
      }
      }*/
  }
  Future<void> _onGetPatientData(GetPatientData event, Emitter<StatewiseState> emitter) async {
    final patientData = await patientRepository.fetchPatientData();
    emit(StatewiseLoaded(patientDataMap: patientData));
  }
}
