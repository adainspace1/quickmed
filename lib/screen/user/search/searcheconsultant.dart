import 'package:flutter/material.dart';
import 'package:quickmed/util/constant.dart';

// ignore: must_be_immutable
class SearchResultScreen extends StatelessWidget {
  final String profession;

  const SearchResultScreen({
    Key? key,
    required this.profession,
  }) : super(key: key);




  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          backgroundColor: COLOR_ACCENT,
          title: Text('Search Results for $profession', style: const TextStyle(color: Colors.white),),
        ),
        body:  ListTile(
        leading: const CircleAvatar(
          backgroundImage: NetworkImage( ""),
          radius: 20,
        ),
        title: const Text(""),
        subtitle: const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[ 
            Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          )],
        ),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: COLOR_ACCENT,
          ),
          onPressed: () {},
          child: const Text(
            'connect',
            style: TextStyle(color: Colors.white),
          ),
        ),
      )
        
      );
    
  }
}
