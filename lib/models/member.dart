import 'package:json_annotation/json_annotation.dart';
part 'member.g.dart';

@JsonSerializable(explicitToJson: true)
class Member {
//ก ำหนดรำยชื่อฟิวด์ในตำรำง products พร้อมก ำหนดชนิดข้อมูล
  String? name, last_name, email, created_at, updated_at;
  int? id;

//ก ำหนดตำมรำยชื่อฟิวด์ที่ประกำศไว้ข้ำงต้น
  Member({
    this.id,
    this.name,
    this.last_name,
    this.email,
    this.created_at,
    this.updated_at,
  });
  factory Member.fromJson(Map<String, dynamic> data) => _$MemberFromJson(data);
  Map<String, dynamic> toJson() => _$UsersToJson(this);
}
