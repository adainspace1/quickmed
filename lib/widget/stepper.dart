import 'package:flutter/material.dart';


class StepperForm extends StatefulWidget {
  const StepperForm({
    Key? key,
  
  }) : super(key: key);



  @override
  // ignore: library_private_types_in_public_api
  _StepperFormState createState() => _StepperFormState();
}

class _StepperFormState extends State<StepperForm> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();

  int _index = 0;

  // CollectionReference groceryItemRef =
  //     FirebaseFirestore.instance.collection('GroceryItem');

  void submitForm() async {
    // try {
    //   var randomId = groceryItemRef.doc().id;
    //   await groceryItemRef.doc(randomId).set({
    //     'name': nameController.text,
    //     'price': double.parse(priceController.text),
    //     'quantity': int.parse(quantityController.text)
    //   });
    // } catch (e) {
    //   print('Error saving grocery item: $e');
    // }
  }

  Widget getTextFormWidget(
      TextEditingController textController, String customHintText) {
    return TextFormField(
      controller: textController,
      autofocus: true,
      obscureText: false,
      decoration: InputDecoration(
        hintText: customHintText,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0x00000000),
            width: 1,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4.0),
            topRight: Radius.circular(4.0),
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0x00000000),
            width: 1,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4.0),
            topRight: Radius.circular(4.0),
          ),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0x00000000),
            width: 1,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4.0),
            topRight: Radius.circular(4.0),
          ),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0x00000000),
            width: 1,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4.0),
            topRight: Radius.circular(4.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stepper(
      type: StepperType.horizontal,
      currentStep: _index,
      onStepCancel: () {
        if (_index > 0) {
          setState(() {
            _index -= 1;
          });
        }
      },
      onStepContinue: () {
        if (_index <= 0) {
          setState(() {
            _index += 1;
          });
        }
      },
      onStepTapped: (int index) {
        setState(() {
          _index = index;
        });
      },
      steps: <Step>[
        Step(
          title: const Text('Product Name'),
          content: getTextFormWidget(nameController, 'Enter The Product Name'),
        ),
        Step(
          title: const Text('Product Name'),
          content: Column(
            children: [
              getTextFormWidget(priceController, 'Enter The Product Price'),
              getTextFormWidget(
                  quantityController, 'Enter The Product Quantity'),
              ElevatedButton(
                onPressed: submitForm,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}