import 'package:equatable/equatable.dart';

class Rocket extends Equatable {
  const Rocket({
    required this.id,
    required this.name,
    required this.description,
    required this.flickrImages,
  });

  final String id;
  final String name;
  final String description;
  final List<String> flickrImages;

  factory Rocket.fromJson(Map<String, dynamic> json) {
    return Rocket(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      flickrImages: List<String>.from(json['flickr_images']),
    );
  }

  @override
  List<Object?> get props => [id, name, description, flickrImages];
}
