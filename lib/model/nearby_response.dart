// This class represents the response from the nearby places API. It has two properties:
// ignore_for_file: unnecessary_this, prefer_collection_literals

class NearByPlacesResponse {
  // A list of places (instances of the Results class).
  List<Results>? results;
  // A status string indicating the success or failure of the API request
  String? status;

  // Constructor for NearbyPlacesResponse class. It allows you to create an instance of the class and initialize its properties
  NearByPlacesResponse({this.results, this.status});
  // A named constructor that creates a NearbyPlacesResponse object from a JSON map. It takes a Map<String, dynamic> as a parameter, typically representing the JSON response from the API.
  NearByPlacesResponse.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v){
        results!.add(Results.fromJson(v));
      });
    }
    status = json['status'];
  }

  //This method converts a NearbyPlacesResponse object into a JSON map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }


}
// This class represents details about a specific place. It has various properties such as name, location, photos, etc
class Results {
  Geometry? geometry;
  String? icon;
  String? iconBackgroundColor;
  String? iconMaskBaseUri;
  String? name;
  List<Photos>? photos;
  String? placeId;
  String? reference;
  String? scope;
  List<String>? types;
  String? vicinity;
  String? businessStatus;
  OpeningHours? openingHours;
  PlusCode? plusCode;
  dynamic rating;
  int? userRatingsTotal;
  // Constructor for the Results class. It allows you to create an instance of the class and initialize its properties.
  Results(
      {this.geometry,
        this.icon,
        this.iconBackgroundColor,
        this.iconMaskBaseUri,
        this.name,
        this.photos,
        this.placeId,
        this.reference,
        this.scope,
        this.types,
        this.vicinity,
        this.businessStatus,
        this.openingHours,
        this.plusCode,
        this.rating,
        this.userRatingsTotal});
  // A named constructor that creates a Results object from a JSON map.
  Results.fromJson(Map<String, dynamic> json) {
    geometry = json['geometry'] != null
        ? Geometry.fromJson(json['geometry'])
        : null;
    icon = json['icon'];
    iconBackgroundColor = json['icon_background_color'];
    iconMaskBaseUri = json['icon_mask_base_uri'];
    name = json['name'];
    if (json['photos'] != null) {
      photos = <Photos>[];
      json['photos'].forEach((v) {
        photos!.add(Photos.fromJson(v));
      });
    }
    placeId = json['place_id'];
    reference = json['reference'];
    scope = json['scope'];
    types = json['types'].cast<String>();
    vicinity = json['vicinity'];
    businessStatus = json['business_status'];
    openingHours = json['opening_hours'] != null
        ? OpeningHours.fromJson(json['opening_hours'])
        : null;
    plusCode = json['plus_code'] != null
        ? PlusCode.fromJson(json['plus_code'])
        : null;
    rating = json['rating'];
    userRatingsTotal = json['user_ratings_total'];
  }
  // This method converts a Results object into a JSON map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.geometry != null) {
      data['geometry'] = this.geometry!.toJson();
    }
    data['icon'] = this.icon;
    data['icon_background_color'] = this.iconBackgroundColor;
    data['icon_mask_base_uri'] = this.iconMaskBaseUri;
    data['name'] = this.name;
    if (this.photos != null) {
      data['photos'] = this.photos!.map((v) => v.toJson()).toList();
    }
    data['place_id'] = this.placeId;
    data['reference'] = this.reference;
    data['scope'] = this.scope;
    data['types'] = this.types;
    data['vicinity'] = this.vicinity;
    data['business_status'] = this.businessStatus;
    if (this.openingHours != null) {
      data['opening_hours'] = this.openingHours!.toJson();
    }
    if (this.plusCode != null) {
      data['plus_code'] = this.plusCode!.toJson();
    }
    data['rating'] = this.rating;
    data['user_ratings_total'] = this.userRatingsTotal;
    return data;
  }
}

class Geometry {
  Location? location;
  Viewport? viewport;

  Geometry({this.location, this.viewport});

  Geometry.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null;
    viewport = json['viewport'] != null
        ? Viewport.fromJson(json['viewport'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    if (this.viewport != null) {
      data['viewport'] = this.viewport!.toJson();
    }
    return data;
  }
}

class Location {
  double? lat;
  double? lng;

  Location({this.lat, this.lng});

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

class Viewport {
  Location? northeast;
  Location? southwest;

  Viewport({this.northeast, this.southwest});

  Viewport.fromJson(Map<String, dynamic> json) {
    northeast = json['northeast'] != null
        ? Location.fromJson(json['northeast'])
        : null;
    southwest = json['southwest'] != null
        ? Location.fromJson(json['southwest'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.northeast != null) {
      data['northeast'] = this.northeast!.toJson();
    }
    if (this.southwest != null) {
      data['southwest'] = this.southwest!.toJson();
    }
    return data;
  }
}


class Photos {
  int? height;
  List<String>? htmlAttributions;
  String? photoReference;
  int? width;

  Photos({this.height, this.htmlAttributions, this.photoReference, this.width});

  Photos.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    htmlAttributions = json['html_attributions'].cast<String>();
    photoReference = json['photo_reference'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['height'] = this.height;
    data['html_attributions'] = this.htmlAttributions;
    data['photo_reference'] = this.photoReference;
    data['width'] = this.width;
    return data;
  }
}

class OpeningHours {
  bool? openNow;

  OpeningHours({this.openNow});

  OpeningHours.fromJson(Map<String, dynamic> json) {
    openNow = json['open_now'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['open_now'] = this.openNow;
    return data;
  }
}

class PlusCode {
  String? compoundCode;
  String? globalCode;

  PlusCode({this.compoundCode, this.globalCode});

  PlusCode.fromJson(Map<String, dynamic> json) {
    compoundCode = json['compound_code'];
    globalCode = json['global_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['compound_code'] = this.compoundCode;
    data['global_code'] = this.globalCode;
    return data;
  }
}



