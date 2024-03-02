import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/model/item_model.dart';
import 'package:crud/services/item_services.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ItemRepositories {
  final createGatePassRepository = ItemService();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<bool> addItemInDB({
    required ItemModel? item,
    File? img,
  }) async {
    try {
      Reference ref =
          _storage.ref().child("itemsImages/${DateTime.now().toString()}");
      UploadTask uploadTask = ref.putFile(img ?? File(""));
      await uploadTask.whenComplete(() => print('Image uploaded'));

      String imageUrl = await ref.getDownloadURL();

      final itemRef = FirebaseFirestore.instance.collection("items").doc();

      await itemRef.set({
        "itemId": itemRef.id,
        "title": item?.title,
        "description": item?.description,
        "imgUrl": imageUrl,
      });

      return true;
    } catch (err) {
      print("error ->>>>>>>>   $err");
      return false;
    }

    // ADD logic to item in firebase
  }

  List<String> allItemsList = [];
  Stream<List<String>> getAllItems() {
    List<String> allItemsList = [];
    try {
      allItemsList.clear();
      return FirebaseFirestore.instance
          .collection("items")
          .orderBy("timestamp", descending: true)
          .snapshots()
          .map((querySnapshot) =>
              querySnapshot.docs.map((doc) => doc.id).toList());
    } catch (error) {
      rethrow;
    }
  }

  // ADD logic to item in firebase
}
