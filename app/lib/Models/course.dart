
import 'dart:convert';


class Course{
  Course( this.id,this.course);
  String course;
  String id;
  
  

  Map<String, dynamic> toMap() {
    final result = <String,dynamic>{};
    result.addAll({'_id': id});
    result.addAll({'course': course});
    return result;
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      map['_id'] ?? '',
      map['course'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Course.fromJson(String source) => Course.fromMap(json.decode(source));
}