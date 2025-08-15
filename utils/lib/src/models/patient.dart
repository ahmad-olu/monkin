// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart' show immutable;

part 'patient.g.dart';

enum Gender { male, female, other }

enum BloodType {
  aPositive,
  aNegative,
  bPositive,
  bNegative,
  abPositive,
  abNegative,
  oPositive,
  oNegative,
}

@immutable
@JsonSerializable()
class Patient extends Equatable {
  const Patient({
    required this.patientNumber,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    required this.phone,
    required this.address,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.id,
    this.createdBy,
    this.email,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.bloodType,
    this.allergies,
    this.insuranceProvider,
    this.insuranceNumber,
    this.deletedAt,
  });

  @JsonKey(includeIfNull: false)
  final String? id;
  @JsonKey(includeIfNull: false)
  final String? createdBy;
  final String patientNumber;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final Gender gender;
  final String phone;
  final String? email;
  final String address;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final BloodType? bloodType;
  final List<String>? allergies;
  final String? insuranceProvider;
  final String? insuranceNumber;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  Patient copyWith({
    String? id,
    String? createdBy,
    String? patientNumber,
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    Gender? gender,
    String? phone,
    String? email,
    String? address,
    String? emergencyContactName,
    String? emergencyContactPhone,
    BloodType? bloodType,
    List<String>? allergies,
    String? insuranceProvider,
    String? insuranceNumber,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return Patient(
      id: id ?? this.id,
      createdBy: createdBy ?? this.createdBy,
      patientNumber: patientNumber ?? this.patientNumber,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone:
          emergencyContactPhone ?? this.emergencyContactPhone,
      bloodType: bloodType ?? this.bloodType,
      allergies: allergies ?? this.allergies,
      insuranceProvider: insuranceProvider ?? this.insuranceProvider,
      insuranceNumber: insuranceNumber ?? this.insuranceNumber,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory Patient.fromJson(Map<String, dynamic> json) =>
      _$PatientFromJson(json);

  Map<String, dynamic> toJson() => _$PatientToJson(this);

  @override
  String toString() {
    return '''Patient(id: $id, patientNumber: $patientNumber, firstName: $firstName, lastName: $lastName, dateOfBirth: $dateOfBirth, gender: $gender, phone: $phone, email: $email, address: $address, emergencyContactName: $emergencyContactName, emergencyContactPhone: $emergencyContactPhone, bloodType: $bloodType, allergies: $allergies, insuranceProvider: $insuranceProvider, insuranceNumber: $insuranceNumber, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)''';
  }

  @override
  List<Object?> get props {
    return [
      id,
      createdBy,
      patientNumber,
      firstName,
      lastName,
      dateOfBirth,
      gender,
      phone,
      email,
      address,
      emergencyContactName,
      emergencyContactPhone,
      bloodType,
      allergies,
      insuranceProvider,
      insuranceNumber,
      isActive,
      createdAt,
      updatedAt,
    ];
  }
}

@immutable
@JsonSerializable()
class UpdatePatient extends Equatable {
  const UpdatePatient({
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.gender,
    this.phone,
    this.address,
    this.isActive,
    this.updatedAt,
    this.email,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.bloodType,
    this.allergies,
    this.insuranceProvider,
    this.insuranceNumber,
  });

  @JsonKey(includeIfNull: false)
  final String? firstName;
  @JsonKey(includeIfNull: false)
  final String? lastName;
  @JsonKey(includeIfNull: false)
  final DateTime? dateOfBirth;
  @JsonKey(includeIfNull: false)
  final Gender? gender;
  @JsonKey(includeIfNull: false)
  final String? phone;
  @JsonKey(includeIfNull: false)
  final String? email;
  @JsonKey(includeIfNull: false)
  final String? address;
  @JsonKey(includeIfNull: false)
  final String? emergencyContactName;
  @JsonKey(includeIfNull: false)
  final String? emergencyContactPhone;
  @JsonKey(includeIfNull: false)
  final BloodType? bloodType;
  @JsonKey(includeIfNull: false)
  final List<String>? allergies;
  @JsonKey(includeIfNull: false)
  final String? insuranceProvider;
  @JsonKey(includeIfNull: false)
  final String? insuranceNumber;
  @JsonKey(includeIfNull: false)
  final bool? isActive;
  @JsonKey(includeIfNull: false)
  final DateTime? updatedAt;

  factory UpdatePatient.fromJson(Map<String, dynamic> json) =>
      _$UpdatePatientFromJson(json);

  Map<String, dynamic> toJson() => _$UpdatePatientToJson(this);

  @override
  List<Object?> get props {
    return [
      firstName,
      lastName,
      dateOfBirth,
      gender,
      phone,
      email,
      address,
      emergencyContactName,
      emergencyContactPhone,
      bloodType,
      allergies,
      insuranceProvider,
      insuranceNumber,
      isActive,
      updatedAt,
    ];
  }

  UpdatePatient copyWith({
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    Gender? gender,
    String? phone,
    String? email,
    String? address,
    String? emergencyContactName,
    String? emergencyContactPhone,
    BloodType? bloodType,
    List<String>? allergies,
    String? insuranceProvider,
    String? insuranceNumber,
    bool? isActive,
    DateTime? updatedAt,
  }) {
    return UpdatePatient(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone:
          emergencyContactPhone ?? this.emergencyContactPhone,
      bloodType: bloodType ?? this.bloodType,
      allergies: allergies ?? this.allergies,
      insuranceProvider: insuranceProvider ?? this.insuranceProvider,
      insuranceNumber: insuranceNumber ?? this.insuranceNumber,
      isActive: isActive ?? this.isActive,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
