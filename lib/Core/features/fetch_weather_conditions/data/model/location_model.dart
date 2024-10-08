import 'package:courtcast/Core/features/fetch_weather_conditions/domain/entities/location_entity.dart';


class LocationModel {
  String name;
  String region;
  String country;

  LocationModel({
    required this.name,
    required this.region,
    required this.country,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
    name: json["name"],
    region: json["region"],
    country: json["country"],
  );

  Map<String, dynamic> toJson() {
    return {'name': name, 'region': region, 'country': country};
  }

  loactionEntity toEntity() {
    return loactionEntity(name: name, region: region, country: country);
  }
}