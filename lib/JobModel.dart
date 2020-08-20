import 'package:flutter/cupertino.dart';

class Job {
  Job({@required this.name, @required this.ratePerHour})
      : assert(name != null, ratePerHour != null);
  final String name;
  final int ratePerHour;

  Map<String, dynamic> toMap() {
    return {
      'Name': name,
      'Rate Per Hour': ratePerHour,
    };
  }
}

class FirestorePath {
  static String firestorePath(String userID, String jobID) =>
      '/Users/$userID/Jobs/$jobID';
  static String firestorePaths(String userID) => 'Users/$userID/Jobs';
}
