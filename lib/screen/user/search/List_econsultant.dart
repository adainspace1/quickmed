// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/helpers/screen_navigation.dart';
import 'package:quickmed/provider/search/searh_provider.dart';
import 'package:quickmed/screen/user/search/searcheconsultant.dart';
import 'package:quickmed/util/constant.dart';

class Econsultant extends StatefulWidget {
  const Econsultant({Key? key}) : super(key: key);

  @override
  State<Econsultant> createState() => _EconsultantState();
}

class _EconsultantState extends State<Econsultant> {
  TextEditingController searchEditingController = TextEditingController();

  QuerySnapshot? searchResultSnapshot;
  bool isLoading = false;
  bool haveUserSearched = false;

  Future<void> initSearch(String text) async {
    if (text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      await Provider.of<SearchResultProvider>(context, listen: false).setSearchResult(text);
      setState(() {
        isLoading = true;
        haveUserSearched = true;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        haveUserSearched = true;
      });
    }
  }

  void navigateToSearchResultScreen(String profession) {
    changeScreen(context, SearchResultScreen(profession: profession));
  }

  void handleContainerTap(String profession) {
    // Show modal when container is tapped
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Consulting with $profession',
                style: const TextStyle(fontSize: 20.0),
              ),
              const SizedBox(height: 16.0),
              Form(
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: "Describe the issue",
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: COLOR_ACCENT,
                  ),
                  onPressed: () {
                    // Close the modal
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Close',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: COLOR_ACCENT),
                  onPressed: () async {
                    await initSearch(profession);
                  },
                  child: const Text(
                    'Send',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
    // Handle tap event here
  }

  Widget buildConsultantContainer(String profession) {
    return GestureDetector(
      onTap: () {
        handleContainerTap(profession);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        width: 200,
        height: 100,
        decoration: BoxDecoration(
          color: COLOR_ACCENT,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.star,
              color: Colors.white,
              size: 30.0,
            ),
            const SizedBox(height: 10.0),
            Text(
              profession,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                buildConsultantContainer('nurse'),
                const SizedBox(height: 20),
                buildConsultantContainer('Dentist'),
                const SizedBox(height: 20),
                buildConsultantContainer('Optician'),
                const SizedBox(height: 20),
                buildConsultantContainer('Cardiac'),
                const SizedBox(height: 20),
                buildConsultantContainer('Physician'),
                const SizedBox(height: 20),
                buildConsultantContainer('Osteologist'),
                const SizedBox(height: 20),
                buildConsultantContainer('Nepriology'),
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: ElevatedButton(
      //     onPressed: () {
      //       changeScreen(context, UserGoogleMapScreen());
      //     },
      //     child: const Text(
      //       "cancle",
      //       style: TextStyle(color: Colors.white),
      //     ),
      //     style: ElevatedButton.styleFrom(
      //       backgroundColor: COLOR_ACCENT,
      //       shape: RoundedRectangleBorder(),
      //     ),
      //   ),
      // ),
    );
  }
}
