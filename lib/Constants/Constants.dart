import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';

final _fireStore = FirebaseFirestore.instance;

final userRef = _fireStore.collection('users');
final followersRef = _fireStore.collection('folloers');
final followingRef = _fireStore.collection('following');
final storageRef = FirebaseStorage.instance.ref();
final tweetsRef = _fireStore.collection('tweets');
final feedRefs = _fireStore.collection('feeds');
final likesRef = _fireStore.collection('likes');
final activitiesRef = _fireStore.collection('activities');
