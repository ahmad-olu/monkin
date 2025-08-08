import 'package:equatable/equatable.dart';

enum Gender { male, female, other }

enum BloodType {
  aPositive,
  aNegative,
  bPositive,
  bNegative,
  abPositive,
  abNegative,
  oPositive,
  oNegative
}

class Patient extends Equatable {
  const Patient({
    required this.id,
    required this.patientNumber,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    required this.phone,
    required this.address,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.email,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.bloodType,
    this.allergies,
    this.insuranceProvider,
    this.insuranceNumber,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'] as String,
      patientNumber: json['patientNumber'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      dateOfBirth:
          DateTime.fromMillisecondsSinceEpoch(json['dateOfBirth'] as int),
      gender: Gender.values.byName(json['gender'] as String),
      phone: json['phone'] as String,
      email: json['email'] as String?,
      address: json['address'] as String,
      emergencyContactName: json['emergencyContactName'] as String?,
      emergencyContactPhone: json['emergencyContactPhone'] as String?,
      bloodType: BloodType.values.byName(json['bloodType'] as String),
      allergies: List<String>.from(json['allergies'] as List? ?? []),
      insuranceProvider: json['insuranceProvider'] as String?,
      insuranceNumber: json['insuranceNumber'] as String?,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int),
    );
  }
  final String id;
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
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Patient copyWith({
    String? id,
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
  }) {
    return Patient(
      id: id ?? this.id,
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientNumber': patientNumber,
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth.millisecondsSinceEpoch,
      'gender': gender.name,
      'phone': phone,
      'email': email,
      'address': address,
      'emergencyContactName': emergencyContactName,
      'emergencyContactPhone': emergencyContactPhone,
      'bloodType': bloodType?.name,
      'allergies': allergies,
      'insuranceProvider': insuranceProvider,
      'insuranceNumber': insuranceNumber,
      'isActive': isActive,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  @override
  String toString() {
    return '''Patient(id: $id, patientNumber: $patientNumber, firstName: $firstName, lastName: $lastName, dateOfBirth: $dateOfBirth, gender: $gender, phone: $phone, email: $email, address: $address, emergencyContactName: $emergencyContactName, emergencyContactPhone: $emergencyContactPhone, bloodType: $bloodType, allergies: $allergies, insuranceProvider: $insuranceProvider, insuranceNumber: $insuranceNumber, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)''';
  }

  @override
  List<Object?> get props {
    return [
      id,
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
