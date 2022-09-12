import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:app/Models/notes.dart';
import 'package:app/constraints/api_path.dart';
import 'package:flutter/cupertino.dart';
import '../Models/course.dart';
import '../Models/user.dart';
import '../providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

import 'package:http/http.dart' as http;

class NotesServices {
  void uploadFile(
      {required String filename,
      required String? path,
      required BuildContext context,
      required String? titolo,
      required String? corso}) async {
    final user = Provider.of<UserProvider>(listen: false, context).user;
    print('waiting for ' + user.email + user.id);
    var request = http.MultipartRequest("POST", Uri.parse(uploaduri));
    request.fields['user'] = user.email;
    request.fields['id'] = user.id;
    request.fields['title'] = titolo!;
    request.fields['course'] = corso!;
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      path!,
      filename: filename,
    ));

    request.send().then((response) {
      if (response.statusCode == 200) print("Uploaded!");
    });
  }

  Future<List<Note>> getUserFiles(
      {required BuildContext context, required int page}) async {
    final user = Provider.of<UserProvider>(listen: false, context).user;
    String id = user.id;
    List paths = await getFilesPath(user: user, page: page);
    print(paths);
    print('QUA');
    List<Note>? notes = <Note>[];
    if (paths.isNotEmpty) {
      print('QUA ci sono ancora');
      for (int i = 0; i < paths.length; i++) {
        Note note = await getFile(path: paths[i]);
        notes.add(note);
      }
      print('SONO IN USERFILE' + notes.toString());
    }

    return notes;
  }

  Future getNote({required String path, required String name}) async {
    http.Response res = await http
        .get(Uri.parse(getNoteuri + '?path=$path'), headers: <String, String>{
      'Content-Type': 'application/json; cahrset=UTF-8',
    });
    print(jsonDecode(res.body));
    return res.body;
  }

  Future<List> getFilesPath({required User user, required int page}) async {
    String id = user.id;
    int limit = 3;
    http.Response res = await http.get(
        Uri.parse(getPathuri + '?user_id=$id&page=$page&limit=$limit'),
        headers: <String, String>{
          'Content-Type': 'application/json; cahrset=UTF-8',
        });
    return jsonDecode(res.body);
  }

  Future<Note> getFile({required String path}) async {
    String name = path.split('/').last;
    http.Response res = await http
        .get(Uri.parse(getFileuri + '?path=$path'), headers: <String, String>{
      'Content-Type': 'application/json; cahrset=UTF-8',
    });
    var resnote = await getNote(path: path, name: name);
    // print('QUA CI SONO I LIKE'+resnote['like']);

    // Note note = Note(resnote['author'], resnote['title'], resnote['course'], resnote['_id'],0);
    Note note = Note.fromJson(resnote);

    //  var file = JsonUtf8Encoder(res.body);
    // print(name);

    note.setPath(await _createFileFromString(res.bodyBytes, name));
    // print('NOTES HERE  ' + note.author + ' ' + note.course + ' ' + note.id + ' ' + note.title + ' ' + note.pathName!);
    return note;
    // var stream = jsonDecode(res.body)['stream'];
    // var result =  jsonDecode(res.body);
    // File transferedFile = File('');
    // IOSink sink = transferedFile.openWrite();
    // await sink.addStream(stream);
    // await sink.close();
  }

  Future<String> _createFileFromString(var res, String name) async {
    // final encodedStr = res;
    // Uint8List bytes = base64.decode(encodedStr);

    final dir = await (syspaths.getTemporaryDirectory());
    // File file = File('${dir.path}/${name}');
    // final Directory? dir = Platform.isAndroid
    // ? await getExternalStorageDirectory()
    // : await getApplicationDocumentsDirectory();
    File file = File('${dir.path}/${name}');
    file.create();
    await file.writeAsBytes(res);
    print(file.path);
    // OpenFile.open(file.path);
    return file.path;
  }

  Future updateNote(
      {required BuildContext context,
      required Note note,
      required bool isliked}) async {
    final user = Provider.of<UserProvider>(listen: false, context).user;

    print(note.author);
    http.Response res = await http.post(Uri.parse(updateNoteuri),
        body:
            jsonEncode({'_id': note.id, 'userId': user.id, 'isLiked': isliked}),
        headers: <String, String>{
          'Content-Type': 'application/json; cahrset=UTF-8',
        });
    // return jsonDecode(res.body);
  }

  Future getCourse() async {
    List<Course> courses = <Course>[];
    http.Response res =
        await http.get(Uri.parse(getCoursesuri), headers: <String, String>{
      'Content-Type': 'application/json; cahrset=UTF-8',
    });
    List result = jsonDecode(res.body);
    for (var element in result) {
      String cour = jsonEncode(element);
      Course course = Course.fromJson(cour);
      courses.add(course);
    }

    return courses;
  }

  Future<List<Note>> getUserFilesSorted(
    { required int page, required String course}) async {
    
    List paths = await getFilesPathSorted(course: course, page: page);
    print(paths);
   
    List<Note>? notes = <Note>[];
    if (paths.isNotEmpty) {
     
      for (int i = 0; i < paths.length; i++) {
        Note note = await getFile(path: paths[i]);
        notes.add(note);
      }
      
    }

    return notes;
  }

  Future<List> getFilesPathSorted({required String course, required int page}) async {
    String id = course;
    int limit = 3;
    http.Response res = await http.get(
        Uri.parse('$getPathSorteduri?course_id=$id&page=$page&limit=$limit'),
        headers: <String, String>{
          'Content-Type': 'application/json; cahrset=UTF-8',
        });
        print('HERE PATHS SORTED');
        print(res.body);
    return jsonDecode(res.body);
  }
}
//request.files.add(http.MultipartFile.fromBytes('file', bytes!,
//      contentType: MediaType('application', 'x-tar'), filename: filename));
