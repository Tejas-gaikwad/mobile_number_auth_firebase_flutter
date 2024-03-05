part of 'items_bloc.dart';

sealed class ItemsEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class AddItemEvent extends ItemsEvent {
  final ItemModel item;
  final File? img;

  AddItemEvent({
    required this.item,
    this.img,
  });

  @override
  List<Object> get props => [item, img!];
}

class UpdateItemEvent extends ItemsEvent {
  final ItemModel item;
  final File? img;
  final String? id;
  final String? imgUrl;

  UpdateItemEvent({
    this.imgUrl,
    required this.id,
    required this.item,
    this.img,
  });

  @override
  List<Object> get props => [item, img!, id!];
}

class DeleteItemEvent extends ItemsEvent {
  final String? id;

  DeleteItemEvent({
    required this.id,
  });

  @override
  List<Object> get props => [id!];
}
