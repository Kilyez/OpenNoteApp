
import 'dart:convert';
import 'dart:io';

class Note{
  Note( this.id,this.title, this.course,this.author, this.like);
  String author;
  String title;
  String course;
  String id;
  String? pathName;
  List like;
  
  void setPath(String path){
    pathName = path;
  }

  Map<String, dynamic> toMap() {
    final result = <String,dynamic>{};
  
    result.addAll({'_id': id});
    result.addAll({'title': title});
    result.addAll({'course': course});
    result.addAll({'author': author});
    result.addAll({'like': like});
  
    return result;
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      map['_id'] ?? '',
      map['title'] ?? '',
      map['course'] ?? '',
      map['author'] ?? '',
      map['like'] ?? [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));
}