// ignore_for_file: use_build_context_synchronously

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

pickImage(ImageSource source, BuildContext context,
    {int maxByteSize = 2 * 1024 * 1024}) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);

  if (file != null) {
    List<int> bytes = await file.readAsBytes();

    if (bytes.length > maxByteSize) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("File too large"),
        backgroundColor: Colors.red,
      ));
    } else {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Image selected "),
        backgroundColor: Colors.green,
      ));
      return bytes;
    }
  }
  // print("no image selected");
}
