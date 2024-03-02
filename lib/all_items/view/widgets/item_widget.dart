import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/constants/colors.dart';
import 'package:flutter/material.dart';

class ItemWidget extends StatelessWidget {
  final String itemId;
  const ItemWidget({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection("items").doc(itemId).get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Error"),
          );
        }
        if (snapshot.hasData) {
          final res = snapshot.data;
          final item = res?.data();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              children: [
                Dismissible(
                  key: Key(item!['itemId'].toString()),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 30.0),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {
                    // setState(() {
                    //   items.removeAt(index);
                    // });
                  },
                  child: Container(
                    // margin: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            offset: const Offset(0.0, 0.0),
                            spreadRadius: 1.0,
                            blurRadius: 4.0,
                          )
                        ]),
                    padding: const EdgeInsets.only(right: 12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25.0),
                            bottomLeft: Radius.circular(25.0),
                          ),
                          child: item?['imgUrl'] != ""
                              ? Image.network(item?['imgUrl'] ?? "")
                              : Image.asset(
                                  "assets/items_placeholder_png_img.png",
                                  fit: BoxFit.cover,
                                  height: 100,
                                ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (item?['title'] ?? "Not Available")
                                      .toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  item?['description'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // showModalBottomSheet(
                            //   context: context,
                            //   backgroundColor: Colors.transparent,
                            //   elevation: 0.0,
                            //   isScrollControlled: true,
                            //   shape: const RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.only(
                            //         topLeft: Radius.circular(30.0),
                            //         topRight: Radius.circular(30.0)),
                            //   ),
                            //   builder: (context) {
                            //     // return Padding(
                            //     //   padding: MediaQuery.of(context).viewInsets,
                            //     //   child: bottomSheetWidget(
                            //     //     onTap: () {},
                            //     //     setState: setState,
                            //     //     image: _image,
                            //     //     isEdit: true,
                            //     //     titleController: titleController,
                            //     //     descriptionController:
                            //     //         descriptionController,
                            //     //   ),
                            //     // );
                            //   },
                            // );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: backgroundColor,
                            ),
                            child: const Icon(Icons.edit, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const Center(
          child: Text("Loading"),
        );
      },
    );
  }
}
