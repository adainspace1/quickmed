import 'package:flutter/material.dart';
import 'package:quickmed/screen/user/search_destination.dart';
import 'package:quickmed/util/constant.dart';

class CommonWidgets {
  //popup before registration happens
  void _popUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(''),
        content: SizedBox(
          width: 350.0, // Set your desired width
          height: 200.0, // Set your desired height
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Center(
                      child: Column(
                    children: [
                      Image.asset(
                        "images/ambu.png",
                        height: 100,
                        width: 100,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("Category 1 ₦5000")
                    ],
                  )),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              )
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: COLOR_ACCENT,
                ),
                onPressed: () async {
                  // Handle submit action
                  var responseFromSearchPage = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (c) => const SearchDestinationPage()));

                  if (responseFromSearchPage == "placeSelected") {}

                  Navigator.pop(context);
                },
                child: const Text(
                  "Continue",
                  style: TextStyle(color: COLOR_BACKGROUND),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.grey, // Customize the Cancel button color
                ),
                onPressed: () {
                  Navigator.pop(context); // Handle cancel action
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void selectWithdrawBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Select a category",
                    style: TextStyle(
                      fontFamily: 'sfpro',
                      fontWeight: FontWeight.w600,
                      fontSize: 26.0,
                      color: Colors.black, // Update with your color
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.clear,
                      color: Colors.black, // Update with your color
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Please select a category to continue",
                style: TextStyle(
                  fontFamily: 'sfpro',
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                  color: Colors.grey, // Update with your color
                ),
              ),
              const SizedBox(height: 36),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPaymentMethod(
                      context,
                      "Category1",
                      "images/ambu.png",
                      () {
                        _popUp(context);
                      },
                    ),
                    const SizedBox(width: 16),
                    _buildPaymentMethod(
                      context,
                      "Category2",
                      "images/ambu.png",
                      () {},
                    ),
                    const SizedBox(width: 16),
                    _buildPaymentMethod(
                      context,
                      "Category3",
                      "images/ambu.png",
                      () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentMethod(BuildContext context, String label,
      String imagePath, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 100,
        width: 212,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.06), // Update with your color
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 70,
              height: 60,
            ),
            const SizedBox(height: 5),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black, // Update with your color
                fontSize: 10,
                fontWeight: FontWeight.w400,
                fontFamily: "sfpro",
                height: 1.40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
