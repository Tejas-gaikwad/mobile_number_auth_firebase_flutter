import 'package:crud/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BottomSheetWidget extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final bool isEdit;

  const BottomSheetWidget({
    super.key,
    required this.titleController,
    required this.descriptionController,
    this.isEdit = false,
  });

  @override
  Widget build(BuildContext context) {
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
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                // ADd pick image logic here
              },
              child: SizedBox(
                width: 100,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Image.asset(
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
                onTap: () {
                  //
                },
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
