import 'package:flutter/foundation.dart';

class RatingVotesNotifier extends ChangeNotifier {
  int _votes = 0;
  int _rating = 0;

  int get votes => _votes;
  int get rating => _rating;

  void updateVotesAndRating(int newVotes, int newRating) {
    if (_votes != newVotes || _rating != newRating) {
      _votes = newVotes;
      _rating = newRating;
      notifyListeners();
    }
  }
}
