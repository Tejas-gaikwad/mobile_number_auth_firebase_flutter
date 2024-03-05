import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/all_items/bloc/items_bloc.dart';
import 'package:crud/all_items/view/widgets/item_widget.dart';
import 'package:crud/constants/colors.dart';
import 'package:crud/model/item_model.dart';
import 'package:crud/repositories/item_repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'widgets/bottom_sheet_widget.dart';

class AllItemsScreen extends StatefulWidget {
  const AllItemsScreen({super.key});

  @override
  State<AllItemsScreen> createState() => _AllItemsScreenState();
}

class _AllItemsScreenState extends State<AllItemsScreen> {
  @override
  Widget build(BuildContext context) {
    // final itemsRepository = ItemRepositories();
    return Scaffold(
      floatingActionButton: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0)),
            ),
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: BlocProvider<ItemBloc>(
                      create: (context) => ItemBloc(ItemInitialState()),
                      child: BottomSheetWidget(

                          // onTap: () {
                          //   final item = ItemModel(
                          //     title: titleController.text,
                          //     description: descriptionController.text,
                          //   );
                          //   context.read<ItemBloc>().add(
                          //         AddItemEvent(
                          //           item: item,
                          //           img: _image,
                          //         ),
                          //       );
                          // },
                          // image: _image,
                          // titleController: titleController,
                          // descriptionController: descriptionController,
                          ),
                    ),
                  );
                },
              );
            },
          );
        },
        child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(1.0, 1.0),
                  blurRadius: 4.0,
                  spreadRadius: 1.0,
                )
              ],
              color: const Color(0XFFFFD8E4),
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: const Icon(
              Icons.add,
              size: 40,
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          "Items".toUpperCase(),
          style: const TextStyle(
            fontSize: 22,
            color: blackColor,
          ),
        ),
        centerTitle: true,
        elevation: 1.0,
        shadowColor: Colors.black,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("items")
            .orderBy("timestamp", descending: true)
            .snapshots(),
        // itemsRepository.getAllItems(),
        builder: (context, snapshot) {
          print("snapshot  ->>>    ${snapshot.data}");
          if (snapshot.hasData) {
            final res = snapshot.data;

            print("res  ->>>>>    ${res?.docs.length}");

            return ListView.builder(
              itemCount: res?.docs.length,
              itemBuilder: (context, index) {
                return ItemWidget(
                  itemId: res?.docs[index].id ?? "",
                );
              },
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text("error -> " + snapshot.error.toString()));
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget bottomSheetWidget({
    required Function()? onTap,
    required Function(void Function()) setState,
    required TextEditingController titleController,
    required TextEditingController descriptionController,
    bool isEdit = false,
    required File? image,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Text(
              isEdit ? "Edit Item" : "Add Item",
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () async {
                // await getImage();
                setState(() {});
              },
              child: SizedBox(
                // height: 100,
                width: 100,
                child: Column(
                  children: [
                    // ClipRRect(
                    //   borderRadius: const BorderRadius.only(
                    //     topLeft: Radius.circular(12),
                    //     topRight: Radius.circular(12),
                    //   ),
                    //   child: image == null
                    //       ? Image.asset(
                    //           "assets/items_placeholder_png_img.png",
                    //           fit: BoxFit.cover,
                    //         )
                    //       : Image.file(
                    //           _image!,
                    //           height: 80,
                    //           fit: BoxFit.cover,
                    //         ),
                    // ),
                    Container(
                      alignment: Alignment.center,
                      width: 100,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        color: greyColor,
                      ),
                      child: Text(
                        isEdit ? "Change" : "Pick",
                        style: TextStyle(color: Colors.black.withOpacity(0.4)),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            TextField(
              onChanged: (value) {
                titleController.text = value;
                print("titleController  ->>>   ${titleController.text}");
                setState(() {});
              },
              controller: titleController,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              maxLength: 10,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                counterText: "",
                label: Text("Title"),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: borderColor),
                ),
              ),
            ),
            const SizedBox(height: 25),
            TextField(
              onChanged: (value) {
                setState(() {
                  descriptionController.text = value;
                  print(
                      "descriptionController  ->>>   ${descriptionController.text}");
                });
              },
              controller: descriptionController,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              maxLength: 10,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                counterText: "",
                label: Text("Description"),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: borderColor),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: onTap,
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: const Text(
                    "SAVE",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
