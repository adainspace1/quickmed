class RouteModel {
  final String points;
  final Distance distance;
  final TimeNeeded timeNeeded;
  final String startAddress;
  final String endAddress;

  RouteModel({
    required this.points,
    required this.distance,
    required this.timeNeeded,
    required this.startAddress,
    required this.endAddress,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      points: json['points'],
      distance: Distance.fromMap(json['distance']),
      timeNeeded: TimeNeeded.fromMap(json['timeNeeded']),
      startAddress: json['startAddress'],
      endAddress: json['endAddress'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'points': points,
      'distance': distance.toJson(),
      'timeNeeded': timeNeeded.toJson(),
      'startAddress': startAddress,
      'endAddress': endAddress,
    };
  }
}

class Distance {
  String text;
  int value;

  Distance({
    required this.text,
    required this.value,
  });

  factory Distance.fromMap(Map<String, dynamic> data) {
    return Distance(
      text: data['text'],
      value: data['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'text': text, 'value': value};
  }
}

class TimeNeeded {
  String text;
  int value;

  TimeNeeded({
    required this.text,
    required this.value,
  });

  factory TimeNeeded.fromMap(Map<String, dynamic> data) {
    return TimeNeeded(
      text: data['text'],
      value: data['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'text': text, 'value': value};
  }
}
