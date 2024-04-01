// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:quickmed/util/constant.dart';
import 'package:restart_app/restart_app.dart';

class InfoDialog extends StatefulWidget {
  String? title, description;

  InfoDialog({
    super.key,
    this.title,
    this.description,
  });

  @override
  State<InfoDialog> createState() => _InfoDialogState();
}

class _InfoDialogState extends State<InfoDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
      ),
      backgroundColor: Colors.white,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 12,
                ),
                Text(
                  widget.title.toString(),
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 27,
                ),
                Text(
                  widget.description.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                SizedBox(
                  width: 202,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: COLOR_ACCENT),
                    onPressed: () {
                      Navigator.pop(context);

                      Restart.restartApp();
                    },
                    child: const Text(
                      "OK",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
