import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickmed/screen/user/service/user_databaseservice.dart';

class SearchResultProvider extends ChangeNotifier {
  QuerySnapshot? _searchResultSnapshot;

  QuerySnapshot? get searchResultSnapshot => _searchResultSnapshot;

  Future<void> setSearchResult(String text) async {
    try {
      // ignore: await_only_futures
      var snapshot = await UserServices().econsultantStream(text);
      _searchResultSnapshot = snapshot as QuerySnapshot<Object?>?;
      notifyListeners();
    
    // ignore: empty_catches
    } catch (e) {
    }
  }
}