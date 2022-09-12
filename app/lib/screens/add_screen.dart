import 'dart:typed_data';
// import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:app/Common_widgets/CustomButton.dart';
import 'package:app/services/notes_services.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Common_widgets/CustomSnackBar.dart';
import '../Models/course.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';
import '../app/sign_in/Social_sign_in_button.dart';
import 'package:app/Common_widgets/custom_form_field.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/safe_area_values.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  NotesServices notesServices = NotesServices();
  GlobalKey<FormState> key = GlobalKey<FormState>();
  CustomFormField customFormField = CustomFormField();
  bool isLoading = false;
  List<Course> courses = <Course>[];
  List<String> coursesName = <String>[];
  String? selectedCourse;
  String? _titolo;

  @override
  void initState() {
    isLoading = true;
    print('here?');
    super.initState();
    getCourses();
  }

  void getCourses() async {
    var sCourses = await notesServices.getCourse();

    setState(() {
      courses = sCourses;
      isLoading = false;
      if (coursesName.isEmpty) {
        for (var element in courses) {
          coursesName.add(element.course);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Column(
              children: const [
                SizedBox(height: 62),
                Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
                  ),
                ),
              ],
            )
          : _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      child: Form(
          key: key,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              const SizedBox(
                height: 70.0,
              ),
              Text(
                "Upload Note",
                style: GoogleFonts.ptSerif(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.indigo),
              ),
              const SizedBox(
                height: 48.0,
              ),
              customDropDownButtom(),
              const SizedBox(
                height: 16.0,
              ),
              customFormField.field(
                question: "Titolo",
                canBeNull: false,
                formKey: key,
                onSavedCallback: (String val) => _titolo = val,
              ),
              const SizedBox(
                height: 32.0,
              ),
              SocialSignInButton(
                assetName: 'images/upload2.png',
                text: 'Upload File',
                textColor: Colors.white,
                color: Colors.indigo,
                onPressed: () {
                  key.currentState!.save();
                  if (key.currentState!.validate() && selectedCourse != null) {
                    importFile(context, selectedCourse, _titolo);
                    key.currentState!.reset();
                  }
                },
              ),
            ]),
          )),
    );
  }

  Widget customDropDownButtom() {
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 2)],
      ),
      child: DropdownButtonFormField<String>(
        hint: Text('select a course'),
        isExpanded: true,
        menuMaxHeight: 150,

        // hint: 'Select Item',
        decoration: InputDecoration(
          // enabledBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(12),
          //   borderSide: BorderSide(width: 2, color: Colors.indigo),
          // ),
          // border: OutlineInputBorder(
          //   // borderSide: BorderSide(color: Colors.indigo, width: 1),
          //   borderRadius: BorderRadius.circular(8),
          // ),
          filled: true,
          fillColor: Colors.white,
        ),
        value: selectedCourse,
        items: coursesName
            .map((element) => DropdownMenuItem<String>(
                  value: element,
                  child: Text(
                    element,
                    style: TextStyle(fontSize: 15),
                  ),
                ))
            .toList(),

        onChanged: (value) {
          setState(() {
            selectedCourse = value;
          });
        },
        // validator: (String? value) {
        //   if (value == null || value.trim().isEmpty) {
        //     return 'Required';
        //   }
        //   return null;
        // },
        // onSaved: (String? val) {
        //   key.currentState?.validate();
        //   onSavedCallback(val.toString());
        // },
      ),
    );
  }

  void importFile(BuildContext context, String? corso, String? titolo) async {
    for(var course in courses){
      if(course.course == corso) corso = course.id; 
    }
    final result = await FilePicker.platform.pickFiles(
        allowedExtensions: ['pdf'], type: FileType.custom, withData: true);
    if (result != null) {
      final file = result.files.first;
      String name = file.name;
      String? path = file.path;
      notesServices.uploadFile(
          filename: name,
          path: path,
          context: context,
          corso: corso,
          titolo: titolo);
      showTopSnackBar(
        context,
        const CustomSnackBar.success(
          message: "Good job, your file is uploaded successfully!",
        ),
      );
    }
  }
}
