import 'dart:io';

import 'package:crud/all_items/view/all_items.dart';
import 'package:crud/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../model/item_model.dart';
import '../../bloc/items_bloc.dart';

class BottomSheetWidget extends StatefulWidget {
  final String? itemUrl;
  final String? itemId;

  final ItemModel? item;
  final bool isEdit;

  const BottomSheetWidget({
    super.key,
    this.isEdit = false,
    this.itemUrl,
    this.item,
    this.itemId,
  });

  @override
  State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  File? _image;
  File? updatingimage;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        if (widget.isEdit) {
          updatingimage = File(pickedFile.path);
        } else {
          _image = File(pickedFile.path);
        }
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(
      text: widget.item?.title,
    );
    descriptionController = TextEditingController(
      text: widget.item?.description,
    );
  }

  @override
  void dispose() {
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ItemBloc, ItemsState>(
      builder: (context, state) {
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
                  widget.isEdit ? "Edit Item" : "Add Item",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: getImage,
                  child: SizedBox(
                    width: 100,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: (widget.itemUrl == null && _image == null)
                              ? Image.asset(
                                  "assets/items_placeholder_png_img.png",
                                  fit: BoxFit.cover,
                                )
                              : (widget.isEdit &&
                                      (widget.itemUrl != null ||
                                          widget.itemUrl != "") &&
                                      updatingimage == null)
                                  ? Image.network(
                                      widget.itemUrl ?? "",
                                      fit: BoxFit.cover,
                                    )
                                  : ((_image?.path != null ||
                                              _image?.path != "") &&
                                          updatingimage == null)
                                      ? Image.file(
                                          _image!,
                                          fit: BoxFit.cover,
                                        )
                                      : (widget.isEdit &&
                                              (updatingimage?.path != null ||
                                                  updatingimage?.path != ""))
                                          ? Image.file(
                                              updatingimage!,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              "assets/items_placeholder_png_img.png",
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
                            widget.isEdit ? "Change" : "Pick",
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.4)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                TextField(
                  onChanged: (value) {
                    print("value ->>>  ${value}");
                  },
                  controller: titleController,
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
                    print("value ->>>  ${value}");
                  },
                  controller: descriptionController,
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
                    onTap: () {
                      final item = ItemModel(
                        title: titleController.text,
                        description: descriptionController.text,
                      );

                      if (widget.isEdit) {
                        context.read<ItemBloc>().add(
                              UpdateItemEvent(
                                id: widget.itemId,
                                item: item,
                                img: updatingimage,
                                imgUrl: widget.itemUrl,
                              ),
                            );
                      } else {
                        context.read<ItemBloc>().add(
                              AddItemEvent(
                                item: item,
                                img: _image,
                              ),
                            );
                      }
                      setState(() {
                        _image = File("");
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: (state is AddItemLoadingState ||
                              state is UpdateItemLoadingState)
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              widget.isEdit ? "UPDATE" : "SAVE",
                              style: const TextStyle(
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
      },
      listener: (context, state) async {
        if (state is AddItemSuccessfullyState ||
            state is UpdateItemSuccessfullyState) {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return const AllItemsScreen();
            },
          ));
        }

        if (state is AddItemErrorState || state is UpdateItemErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Error..."),
            duration: Duration(seconds: 2),
          ));
          await Future.delayed(const Duration(seconds: 2));
          if (!mounted) return;
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return const AllItemsScreen();
            },
          ));
        }
      },
    );
  }
}
