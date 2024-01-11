
// ignore_for_file: non_constant_identifier_names

class PredictedPlaces {
  double? place_Id;
  String? main_text;
  String? secondary_text;

  PredictedPlaces({this.place_Id, this.main_text, this.secondary_text});

  PredictedPlaces.fromJson(Map<String, dynamic> jsonData) {
    place_Id = jsonData["place_id"];
    main_text = jsonData["structured_formatting"]["main_text"];
    secondary_text = jsonData["structured_formatting"]["secondary_text"];

  }
}
