import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:covid_self_care_app/data/models/update_info.dart';
import 'package:covid_self_care_app/data/repos/update_repository.dart';
import 'package:meta/meta.dart';
import 'package:package_info/package_info.dart';

part 'update_info_event.dart';
part 'update_info_state.dart';

class UpdateInfoBloc extends Bloc<UpdateInfoEvent, UpdateInfoState> {
  final UpdateRepository updateRepository;

  UpdateInfoBloc({required this.updateRepository}):
      //assert(this.updateRepository!=null),
      super(UpdateInfoInitial());

  @override
  UpdateInfoState get initialState => UpdateInfoInitial();

  @override
  Stream<UpdateInfoState> mapEventToState(UpdateInfoEvent event) async* {
    yield UpdateInfoLoading();
    if (event is GetUpdateInfo) {
      try {
        final updateInfo = await updateRepository.fetchUpdateInfo();
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        int? currentBuildNumber =  int.tryParse(packageInfo.buildNumber);

        if(currentBuildNumber != null && currentBuildNumber < updateInfo.versionNumber) {
          yield UpdateInfoLoaded(updateInfo: updateInfo);
        } else {
          yield UpdateInfoNoUpdate();
        }
        
      } catch (error) {
        print(error);
        yield UpdateInfoError(error: error.toString());
      }
    }
  }
}
