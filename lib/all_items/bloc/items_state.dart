part of 'items_bloc.dart';

sealed class ItemsState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class ItemInitialState extends ItemsState {}

class AddItemLoadingState extends ItemsState {}

class AddItemSuccessfullyState extends ItemsState {}

class AddItemErrorState extends ItemsState {}

class GettingAllItemsLoadingState extends ItemsState {}

class GetAllItemsSuccessState extends ItemsState {
  final Stream<List<String>> itemsIdList;

  GetAllItemsSuccessState({required this.itemsIdList});

  @override
  List<Object> get props => [itemsIdList];
}

class GettingAllItemsErrorState extends ItemsState {
  final String errorMessage;

  GettingAllItemsErrorState({required this.errorMessage});

  @override
  List<Object> get props => [];
}
