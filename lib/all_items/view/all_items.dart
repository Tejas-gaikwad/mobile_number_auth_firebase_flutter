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
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    titleController = TextEditingController();
    descriptionController = TextEditingController();

    super.dispose();
  }

  File? _image;

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  List items = [
    "a",
    "b",
    "c",
    "d",
    "e",
    "f",
    "g",
    "h",
    "i",
    "j",
    "k",
    "l",
    "m",
  ];
  @override
  Widget build(BuildContext context) {
    final itemsRepository = ItemRepositories();
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
                    child: bottomSheetWidget(
                      onTap: () {
                        final item = ItemModel(
                          title: titleController.text,
                          description: descriptionController.text,
                        );
                        context.read<ItemBloc>().add(
                              AddItemEvent(
                                item: item,
                                img: _image,
                              ),
                            );
                      },
                      setState: setState,
                      image: _image,
                      titleController: titleController,
                      descriptionController: descriptionController,
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
      body: BlocConsumer<ItemBloc, ItemsState>(
        builder: (context, state) {
          return StreamBuilder<List<String>>(
            stream: itemsRepository.getAllItems(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final res = snapshot.data;

                Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: res?.length,
                          itemBuilder: (context, index) {
                            final item = res?[index];

                            return ItemWidget(
                              itemId: item ?? "",
                            );
                          },
                        )
                      ],
                    ),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return SizedBox();
            },
          );
        },
        listener: (context, state) {
          if (state is AddItemLoadingState) {
            showDialog(
              context: context,
              builder: (context) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          }
          if (state is AddItemErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Item Cannot be added")));
          }
          if (state is AddItemSuccessfullyState) {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (context) {
                return BlocProvider(
                  create: (context) => ItemBloc(ItemInitialState()),
                  child: const AllItemsScreen(),
                );
              },
            ), (route) => false);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Item added successfully")));
          }
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
                await getImage();
                // setModalState(() {});
                setState(() {});
              },
              child: SizedBox(
                // height: 100,
                width: 100,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: image == null
                          ? Image.asset(
                              "assets/items_placeholder_png_img.png",
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              _image!,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                    ),
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
