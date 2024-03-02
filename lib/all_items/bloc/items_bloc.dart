import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/services/item_services.dart';
import 'package:equatable/equatable.dart';
import '../../model/item_model.dart';
part 'items_state.dart';
part 'items_event.dart';

class ItemBloc extends Bloc<ItemsEvent, ItemsState> {
  ItemBloc(super.initialState) {
    final itemServices = ItemService();
    on<AddItemEvent>(
      (event, emit) async {
        emit(AddItemLoadingState());
        final status = await itemServices.addItemInDB(
          img: event.img,
          item: event.item,
        );
        if (status) {
          emit(AddItemSuccessfullyState());
        } else {
          emit(AddItemErrorState());
        }
      },
    );

    Future<Stream<List<String>>> getAllItems() async {
      try {
        emit(GettingAllItemsLoadingState());
        final list = await itemServices.getAllItems();
        emit(GetAllItemsSuccessState(itemsIdList: list));
        return list;
      } catch (err) {
        print("error ->>>  $err");
        emit(GettingAllItemsErrorState(errorMessage: err.toString()));
        rethrow;
      }
    }
    // on<GetAllItemsEvent>(
    //   (event, emit) async {
    //     try {
    //       emit(GettingAllItemsLoadingState());
    //       final list = await itemServices.getAllItems();
    //       emit(GettingAllItemsLoadedState(itemsList: list));
    //     } catch (error) {
    //       emit(GettingAllItemsErrorState(
    //           errorMessage: 'Error While fetching all complaints'));
    //     }
    //   },
    // );
  }
}
