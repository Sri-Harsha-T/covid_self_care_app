import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class UpdateEntity extends Equatable {
  final bool updateAvailable;
  final bool important;
  final int versionNumber;
  final String versionName;
  final String versionDesc;
  final String downloadLink;

  UpdateEntity({required this.updateAvailable, required this.important, required this.versionNumber, required this.versionName, required this.versionDesc, required this.downloadLink});

  factory UpdateEntity.fromSnapshot(DocumentSnapshot snapshot) {
    return UpdateEntity(
      updateAvailable: snapshot.get("update_available"),
      important: snapshot.get("important"),
      versionNumber: snapshot.get("version_number"),
      versionName: snapshot.get("version_name"),
      versionDesc: snapshot.get("version_desc"),
      downloadLink: snapshot.get("download_link"),
    );
  }

  @override
  String toString() {
    return 'UpdateEntity { updateAvailable : $updateAvailable, important : $important , versionNumber : ${versionNumber.toString()}, versionName : $versionName, versionDesc : $versionDesc, downloadLink : $downloadLink }';
  }

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
