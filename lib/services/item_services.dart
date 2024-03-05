import 'dart:io';

import 'package:crud/model/item_model.dart';
import 'package:crud/repositories/item_repositories.dart';

class ItemService {
  final itemRepository = ItemRepositories();

  Future<bool> addItemInDB({
    required ItemModel? item,
    File? img,
  }) async {
    return itemRepository.addItemInDB(
      item: item,
      img: img,
    );
  }

  Future<bool> updateItemInDB({
    required String? id,
    String? imgUrl,
    required ItemModel? item,
    File? img,
  }) async {
    return itemRepository.updateItemInDB(
      imgUrl: imgUrl,
      id: id,
      item: item,
      img: img,
    );
  }

  // Future<Stream<List<String>>> getAllItems() async {
  //   return itemRepository.getAllItems();
  // }
}
