// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:quickmed/provider/user/user_appstate.dart';
// import 'package:quickmed/util/constant.dart';


// class DriverFoundWidget extends StatelessWidget {
//   const DriverFoundWidget({super.key});


//   @override
//   Widget build(BuildContext context) {
//     UserAppProvider appState = Provider.of<UserAppProvider>(context);

//     return Material(
//       child: DraggableScrollableSheet(
//           initialChildSize: 0.2,
//           minChildSize: 0.05,
//           maxChildSize: 0.8,
//           builder: (BuildContext context, myscrollController) {
//             return Container(
//               decoration: BoxDecoration(color: Colors.white,
//                              borderRadius: const BorderRadius.only(
//                                  topLeft: Radius.circular(20),
//                                  topRight: Radius.circular(20)),
//                   boxShadow: [
//                     BoxShadow(
//                         color: COLOR_ACCENT.withOpacity(.8),
//                         offset: const Offset(3, 2),
//                         blurRadius: 7)
//                   ]),
//               child: ListView(
//                 controller: myscrollController,
//                 children: [
//                   const SizedBox(
//                     height: 12,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         child: appState.driverArrived == false ? const Text(
//                         'Your ride arrives in ',
                          
//                         ) :const Text(
                        
//                           'Your ride has arrived',
                        
//                         )
//                       ),
//                     ],
//                   ),
//                   const Divider(),
//                   ListTile(
//                     leading: Container(
//                       child:appState.driverModel?.name  == null ? const CircleAvatar(
//                         radius: 30,
//                         child: Icon(Icons.person_outline, size: 25,),
//                       ) : CircleAvatar(
//                         radius: 30,
//                         backgroundImage: NetworkImage(appState.driverModel?.profileImage ?? ""),
//                       ),
//                     ),
//                     title: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         RichText(
//                             text: const TextSpan(children: [
//                           TextSpan(
//                               text:  "\n",
//                               style: TextStyle(
//                                   fontSize: 17, fontWeight: FontWeight.bold)),
//                           TextSpan(
//                               text: "Toyota",
//                               style: TextStyle(
//                                   fontSize: 14, fontWeight: FontWeight.w300)),
//                         ], style: TextStyle(color: Colors.black))),
//                       ],
//                     ),
//                     subtitle: ElevatedButton(
//                         style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
//                         onPressed: null,
//                         child: const Text(
//                           ""
                       
//                         )),
//                     trailing: Container(
//                         decoration: BoxDecoration(
//                             color: Colors.green.withOpacity(0.3),
//                             borderRadius: BorderRadius.circular(20)),
//                         child: IconButton(
//                           onPressed: () {
//                           },
//                           icon: const Icon(Icons.call),
//                         )),
//                   ),
//                   const Divider(),
//                   const Padding(
//                     padding: EdgeInsets.all(12),
//                     child: Text(
//                       "Ride details",
                    
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       const SizedBox(
//                         width: 10,
//                       ),
//                       const SizedBox(
//                         height: 100,
//                         width: 10,
//                         child: Column(
//                           children: [
//                             Icon(
//                               Icons.location_on,
//                               color: Colors.greenAccent,
//                             ),
//                             Padding(
//                               padding: EdgeInsets.only(left: 9),
//                               child: SizedBox(
//                                 height: 45,
//                                 width: 2,
                               
//                               ),
//                             ),
//                             Icon(Icons.flag),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 30,
//                       ),
//                       RichText(
//                           text: const TextSpan(children: [
//                         TextSpan(
//                             text: "\nPick up location \n",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 16)),
//                         TextSpan(
//                             text: "25th avenue, flutter street \n\n\n",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w300, fontSize: 16)),
//                         TextSpan(
//                             text: "Destination \n",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 16)),
//                         TextSpan(
//                             text: "25th avenue, flutter street \n",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w300, fontSize: 16)),
//                       ], style: TextStyle(color: Colors.black))),
//                     ],
//                   ),
//                   const Divider(),
//                   const Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.all(12),
//                         child: Text(
//                           "Ride price",
                     
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.all(12),
//                         child: Text(
//                           "",
                       
//                         ),
//                       ),
//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(12),
//                     child: ElevatedButton(
//                       onPressed: () {},
//                       child: const Text(
//                         "Cancel Ride",
                        
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             );
//           }),
//     );
//   }
// }
