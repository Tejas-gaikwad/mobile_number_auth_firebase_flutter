import 'package:crud/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
              return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: BottomSheetWidget(
                  titleController: titleController,
                  descriptionController: descriptionController,
                ),
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
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 15),
                // StreamBuilder(
                //   stream: stream,
                //   builder: (context, snapshot) {
                //     return Container(
                //       child: Row(
                //         children: [
                //           Image.asset(
                //             "assets/items_placeholder_png_img.png",
                //             fit: BoxFit.cover,
                //           ),
                //           Column(
                //             children: [
                //               Text(
                //                 "Title",
                //               ),
                //               Text(
                //                 "Description",
                //               ),
                //             ],
                //           ),
                //           Icon(Icons.edit),
                //         ],
                //       ),
                //     );
                //   },
                // ),

                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      child: Column(
                        children: [
                          Dismissible(
                            key: Key(items[index].toString()),
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
                              setState(() {
                                items.removeAt(index);
                              });
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
                                    child: Image.asset(
                                      "assets/items_placeholder_png_img.png",
                                      fit: BoxFit.cover,
                                      height: 100,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            items[index].toString(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const Text(
                                            "Description",
                                            style: TextStyle(
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
                                          return Padding(
                                            padding: MediaQuery.of(context)
                                                .viewInsets,
                                            child: BottomSheetWidget(
                                              isEdit: true,
                                              titleController: titleController,
                                              descriptionController:
                                                  descriptionController,
                                            ),
                                          );
                                        },
                                      );
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
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
