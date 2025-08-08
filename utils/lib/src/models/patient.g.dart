// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Patient _$PatientFromJson(Map<String, dynamic> json) => Patient(
  id: json['id'] as String,
  patientNumber: json['patientNumber'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
  gender: $enumDecode(_$GenderEnumMap, json['gender']),
  phone: json['phone'] as String,
  address: json['address'] as String,
  isActive: json['isActive'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  email: json['email'] as String?,
  emergencyContactName: json['emergencyContactName'] as String?,
  emergencyContactPhone: json['emergencyContactPhone'] as String?,
  bloodType: $enumDecodeNullable(_$BloodTypeEnumMap, json['bloodType']),
  allergies: (json['allergies'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  insuranceProvider: json['insuranceProvider'] as String?,
  insuranceNumber: json['insuranceNumber'] as String?,
);

Map<String, dynamic> _$PatientToJson(Patient instance) => <String, dynamic>{
  'id': instance.id,
  'patientNumber': instance.patientNumber,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'dateOfBirth': instance.dateOfBirth.toIso8601String(),
  'gender': _$GenderEnumMap[instance.gender]!,
  'phone': instance.phone,
  'email': instance.email,
  'address': instance.address,
  'emergencyContactName': instance.emergencyContactName,
  'emergencyContactPhone': instance.emergencyContactPhone,
  'bloodType': _$BloodTypeEnumMap[instance.bloodType],
  'allergies': instance.allergies,
  'insuranceProvider': instance.insuranceProvider,
  'insuranceNumber': instance.insuranceNumber,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
  Gender.other: 'other',
};

const _$BloodTypeEnumMap = {
  BloodType.aPositive: 'aPositive',
  BloodType.aNegative: 'aNegative',
  BloodType.bPositive: 'bPositive',
  BloodType.bNegative: 'bNegative',
  BloodType.abPositive: 'abPositive',
  BloodType.abNegative: 'abNegative',
  BloodType.oPositive: 'oPositive',
  BloodType.oNegative: 'oNegative',
};
