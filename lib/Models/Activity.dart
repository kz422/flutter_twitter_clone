import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  String id;
  String fromUserId;
  Timestamp timestamp;
  bool follow;

  Activity({this.id, this.fromUserId, this.timestamp, this.follow});

  factory Activity.fromDoc(DocumentSnapshot documentSnapshot) {
    return Activity(
      id: documentSnapshot.id,
      fromUserId: documentSnapshot['fromUserId'],
      timestamp: documentSnapshot['timestamp'],
      follow: documentSnapshot['follow'],
    );
  }
}
