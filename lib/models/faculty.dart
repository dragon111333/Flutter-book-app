import 'package:json_annotation/json_annotation.dart';
part 'faculty.g.dart';

@JsonSerializable(explicitToJson: true)
class Faculty {
//ก ำหนดรำยชื่อฟิวด์ในตำรำง products พร้อมก ำหนดชนิดข้อมูล
  String? f_name, details, f_img, created_at, updated_at;
  int? f_id;

//ก ำหนดตำมรำยชื่อฟิวด์ที่ประกำศไว้ข้ำงต้น
  Faculty({
    this.f_id,
    this.f_name,
    this.f_img,
    this.details,
    this.created_at,
    this.updated_at,
  });
  factory Faculty.fromJson(Map<String, dynamic> data) =>
      _$FacultyFromJson(data);
  Map<String, dynamic> toJson() => _$FacultyToJson(this);
}
