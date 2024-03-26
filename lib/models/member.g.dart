part of 'member.dart';

Member _$MemberFromJson(Map<String, dynamic> json) => Member(
      id: json['id'] as int?,
      name: json['nmae'] as String?,
      last_name: json['last_name'] as String?,
      email: json['email'] as String?,
      student_id: json['student_id'],
      m_img: json['m_img'],
      created_at: json['created_at'] as String?,
      updated_at: json['updated_at'] as String?,
    );

Map<String, dynamic> _$UsersToJson(Member instance) => <String, dynamic>{
      'name': instance.name,
      'last_name': instance.last_name,
      'email': instance.email,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'id': instance.id,
      "m_img": instance.m_img,
      "student_id": instance.student_id
    };
