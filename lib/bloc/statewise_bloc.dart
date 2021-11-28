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
      super(const StatewiseInitial());

  StatewiseState get initialState => const StatewiseInitial();

  Stream<StatewiseState> mapEventToState(
    StatewiseEvent event,
  ) async* {
    // TODO: implement mapEventToState
    yield const StatewiseLoading();
    on<GetPatientData>((event, emit)async {
      try {
        final patientData = await patientRepository.fetchPatientData();
        emit (StatewiseLoaded(patientDataMap: patientData));

      } catch (error) {
        print(error);
        emit(StatewiseError(error: "Data couldn't be loaded."));
      }
    });
  }
}
