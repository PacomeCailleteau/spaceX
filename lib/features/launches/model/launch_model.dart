import 'package:equatable/equatable.dart';
import 'package:space_x/features/rockets/model/rocket_model.dart';

class Launch extends Equatable {
  const Launch({
    required this.id,
    required this.name,
    this.details,
    required this.dateUtc,
    this.success,
    this.failures,
    this.patch,
    this.article,
    this.rocket,
  });

  final String id;
  final String name;
  final String? details;
  final DateTime dateUtc;
  final bool? success;
  final List<Failure>? failures;
  final Patch? patch;
  final String? article;
  final Rocket? rocket;

  factory Launch.fromJson(Map<String, dynamic> json) {
    return Launch(
      id: json['id'],
      name: json['name'],
      details: json['details'],
      dateUtc: DateTime.parse(json['date_utc']),
      success: json['success'],
      failures: (json['failures'] as List<dynamic>?)
          ?.map((e) => Failure.fromJson(e as Map<String, dynamic>))
          .toList(),
      patch: json['links']?['patch'] != null
          ? Patch.fromJson(json['links']['patch'] as Map<String, dynamic>)
          : null,
      article: json['links']?['article'],
      rocket: json['rocket'] != null
          ? Rocket.fromJson(json['rocket'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        details,
        dateUtc,
        success,
        failures,
        patch,
        article,
        rocket,
      ];
}

class Failure extends Equatable {
  const Failure({
    required this.reason,
  });

  final String reason;

  factory Failure.fromJson(Map<String, dynamic> json) {
    return Failure(
      reason: json['reason'],
    );
  }

  @override
  List<Object?> get props => [reason];
}

class Patch extends Equatable {
  const Patch({
    this.small,
    this.large,
  });

  final String? small;
  final String? large;

  factory Patch.fromJson(Map<String, dynamic> json) {
    return Patch(
      small: json['small'],
      large: json['large'],
    );
  }

  @override
  List<Object?> get props => [small, large];
}
