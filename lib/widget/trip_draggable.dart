import 'package:flutter/material.dart';


// this is a widget for the  service provider dashboard
class TripWidget extends StatelessWidget {
  const TripWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return 
      DraggableScrollableSheet(   
         initialChildSize: 0.2,
          minChildSize: 0.2,
          maxChildSize: 0.8,
       
        builder: (BuildContext context, myscrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
                             topLeft: Radius.circular(20),
                             topRight: Radius.circular(20)),
      
            boxShadow: [
              BoxShadow(
                        color: Colors.grey.shade100,
                        offset: const Offset(3, 2),
                        blurRadius: 7)
            ],
      
          
          ),
          child: ListView(
            controller: myscrollController,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.person_outline, size: 25,),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    RichText(
                            text: const TextSpan(children: [
                           
                              TextSpan(
                                  text: "Audi",
                                  style: TextStyle(
                                      fontSize: 14, fontWeight: FontWeight.w300)),
                            ], style: TextStyle(color: Colors.black))),
                  ],
                ),

                trailing: Container(
                  decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(30)),
                      child: IconButton(
                        onPressed: () {
                        },
                        icon: const Icon(Icons.info, color: Colors.white,),
                      )
                ),
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                    "Ride details",
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      height: 100,
                      width: 10,
                      child: Column(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.grey,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 9),
                            child: Container(
                              height: 45,
                              width: 2,
                              color: Colors.purple,
                            ),
                          ),
                          const Icon(Icons.flag),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    RichText(
                        text: const TextSpan(children: [
                          TextSpan(
                              text: "\nPick up location \n",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          TextSpan(
                              text: "25th avenue, flutter street \n\n\n",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 16)),
                          TextSpan(
                              text: "Destination \n",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          TextSpan(
                              text: "25th avenue, flutter street \n",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 16)),
                        ], style: TextStyle(color: Colors.black))),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        "Ride price",
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        "\$${22}",
                      ),
                    ),
                    Padding(
                  padding: const EdgeInsets.all(12),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                    onPressed: () {},
                    child: const Text(
                      "END MY TRIP",
                    ),
                  ),
                )
                  ],
                ),
            ]
            
          ),
        );
      });
  
  }
}