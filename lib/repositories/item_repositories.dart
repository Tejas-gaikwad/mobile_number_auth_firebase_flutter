import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/model/item_model.dart';
import 'package:crud/services/item_services.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ItemRepositories {
  // final createGatePassRepository = ItemService();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<bool> addItemInDB({
    required ItemModel? item,
    File? img,
  }) async {
    print("STORAGE ->>>>>>>>>>>>>>>>>    ${_storage}");
    print("img ->>>>>>>>>>>>>>>>>    ${img}");

    try {
      final ref = _storage.ref().child('images/${DateTime.now()}');
      UploadTask uploadTask = ref.putFile(img ?? File(""));
      await uploadTask.whenComplete(() => print('Image uploaded'));

      String imageUrl = await ref.getDownloadURL();

      final itemRef = FirebaseFirestore.instance.collection("items").doc();

      await itemRef.set({
        "itemId": itemRef.id,
        "title": item?.title,
        "description": item?.description,
        "imgUrl": imageUrl,
        "timestamp": DateTime.now(),
      });

      return true;
    } catch (err) {
      print("error ->>>>>>>>   $err");
      return false;
    }

    // ADD logic to item in firebase
  }

  Future<bool> updateItemInDB({
    required String? id,
    required String? imgUrl,
    required ItemModel? item,
    File? img,
  }) async {
    try {
      String? imageUrl;
      if (img != null) {
        final ref = _storage.ref().child('images/${DateTime.now()}');
        UploadTask uploadTask = ref.putFile(img);
        await uploadTask.whenComplete(() => print('Image uploaded'));
        imageUrl = await ref.getDownloadURL();
      }

      final itemRef = FirebaseFirestore.instance.collection("items").doc(id);

      await itemRef.update({
        "itemId": itemRef.id,
        "title": item?.title,
        "description": item?.description,
        "imgUrl": imageUrl ?? imgUrl,
        "timestamp": DateTime.now(),
      });

      return true;
    } catch (err) {
      print("error ->>>>>>>>   $err");
      return false;
    }

    // List<String> allItemsList = [];
    // Stream<List<String>> getAllItems() {
    //   List<String> allItemsList = [];
    //   try {
    //     allItemsList.clear();
    //     return FirebaseFirestore.instance
    //         .collection("items")
    //         .orderBy("timestamp", descending: true)
    //         .snapshots()
    //         .map((querySnapshot) =>
    //             querySnapshot.docs.map((doc) => doc.id).toList());
    //   } catch (error) {
    //     rethrow;
    //   }
    // }

    // ADD logic to item in firebase
  }
}
