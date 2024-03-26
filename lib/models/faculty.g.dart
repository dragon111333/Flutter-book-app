part of 'faculty.dart';

Faculty _$FacultyFromJson(Map<String, dynamic> json) => Faculty(
      f_id: json['f_id'] as int?,
      f_name: json['f_name'] as String?,
      details: json['details'] as String?,
      f_img: json['f_img'],
      created_at: json['created_at'] as String?,
      updated_at: json['updated_at'] as String?,
    );

Map<String, dynamic> _$FacultyToJson(Faculty instance) => <String, dynamic>{
      'name': instance.f_name,
      'details': instance.details,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'f_id': instance.f_id,
      "f_img": instance.f_img,
    };
