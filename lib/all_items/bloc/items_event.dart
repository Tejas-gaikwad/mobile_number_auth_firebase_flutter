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
  List<Object> get props => [item];
}

// class GetAllItemsEvent extends ItemsEvent {
//   GetAllItemsEvent();

//   @override
//   List<Object> get props => [item];
// }
