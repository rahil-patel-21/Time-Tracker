import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'JobModel.dart';

abstract class DataBase {
  Future<void> createJob(Job job);
  Stream<List<Job>> jobsStream();
}

class FirestoreDataBase implements DataBase {
  final _fireStore = Firestore.instance;
  FirestoreDataBase({@required this.userID}) : assert(userID != null);
  final String userID;

  @override
  Future<void> createJob(Job job) async {
    final documentReference =
        _fireStore.document(FirestorePath.firestorePath(userID, 'Job_abc'));
    await documentReference.setData(job.toMap());
  }

  @override
  Stream<List<Job>> jobsStream() {
    final path = FirestorePath.firestorePaths(userID);
    final reference = _fireStore.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.documents.map((snapshot) => Job(
        name: snapshot.data['Name'],
        ratePerHour: snapshot.data['Rate Per Hour'])));
    // snapshots.listen((snapshot) {
    //   snapshot.documents.forEach((snapshot) => print(snapshot.data));
    // });
  }
}

//  @override
//   Future<void> createJob(Job job) async => await _setData(
//       path: FirestorePath.firestorePath(userID, 'Job_abc'), data: job.toMap());

//   Future<void> _setData({String path, Map<String, dynamic> data}) async {
//     final reference = _fireStore.document(path);
//     await reference.setData(data);
//   }
