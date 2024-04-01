// ignore_for_file: must_be_immutable, prefer_interpolation_to_compose_strings, unnecessary_string_escapes

import 'package:flutter/material.dart';
import 'package:quickmed/method/common_method.dart';



class PaymentDialog extends StatefulWidget
{
  String fareAmount;

  PaymentDialog({super.key, required this.fareAmount,});

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}



class _PaymentDialogState extends State<PaymentDialog>
{
  CommonMethods cMethods = CommonMethods();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.black54,
      child: Container(
        margin: const EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const SizedBox(height: 21,),

            const Text(
              "PAY CASH",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 21,),

            const Divider(
              height: 1.5,
              color: Colors.white70,
              thickness: 1.0,
            ),

            const SizedBox(height: 16,),

            Text(
              "\₦" + widget.fareAmount,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "This is fare amount ( \₦ ${widget.fareAmount} ) you have to pay to the driver.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey
                ),
              ),
            ),

            const SizedBox(height: 31,),

            ElevatedButton(
              onPressed: ()
              {
                Navigator.pop(context, "paid");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text(
                "PAY CASH",
              ),
            ),

            const SizedBox(height: 41,)

          ],
        ),
      ),
    );
  }
}
