import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_self_care_app/data/entities/update_entity.dart';
import 'package:covid_self_care_app/data/models/update_info.dart';

abstract class UpdateRepository {
  Future<UpdateInfo> fetchUpdateInfo();
}

class FirebaseUpdateRepository extends UpdateRepository {
  @override
  Future<UpdateInfo> fetchUpdateInfo() async {
    final updateDocRef = FirebaseFirestore.instance.collection("app_details").doc("update_details");
    var updateInfo = await updateDocRef.get().then((value) {
      if (value.exists) {
        return UpdateInfo.fromEntity(UpdateEntity.fromSnapshot(value));
      } else {
        throw Error();
      }
    });
    return updateInfo;
  }
}
