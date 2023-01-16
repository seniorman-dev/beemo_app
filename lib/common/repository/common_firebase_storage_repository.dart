import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final commonFirebaseStorageRepositoryProvider = Provider((ref) => CommonFirebaseStorageRepository(firebaseStorage: FirebaseStorage.instance));


//for storing pictures to firebase storage bucket
class CommonFirebaseStorageRepository {
  final FirebaseStorage firebaseStorage;

  CommonFirebaseStorageRepository({required this.firebaseStorage});

  Future storeFileToFirebase(String ref, File file) async{
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file); ///because of flutter web image picker
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}