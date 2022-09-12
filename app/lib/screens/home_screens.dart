import 'package:app/providers/user_provider.dart';
import 'package:app/utils/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:app/Common_widgets/bottom_bar.dart';

import '../Common_widgets/note_card.dart';
import '../Models/course.dart';
import '../Models/notes.dart';
import '../services/notes_services.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note>? notes = <Note>[];
  NotesServices notesServices = NotesServices();
  bool isLoading = false;
  final controller = ScrollController();
  int page = 1;
  bool hasMore = true;
  bool hasNotes = false;
  List<Course> courses = <Course>[];
  List<String> coursesName = <String>[];
  String? selectedCourse;
  String course = '';
  String oldCourse = '';
  String courseName = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getCourses();
    getListNotes();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        setState(() {
          page += 1;
        });
        if(hasMore)getListNotes();
      }
    });
  }

  void getCourses() async {
    var sCourses = await notesServices.getCourse();

    setState(() {
      courses = sCourses;

      if (coursesName.isEmpty) {
        for (var element in courses) {
          coursesName.add(element.course);
         
        }
      }
    });
  }

  

  void getListNotes() async {
    if(selectedCourse != courseName){
      
      if (selectedCourse != null && selectedCourse!.isNotEmpty) {
      for (var element in courses) {
        if (element.course == selectedCourse!) {
          courseName = element.course;
          oldCourse = course;
          course = element.id;
          setState(() {
      isLoading = true;
      page = 1;
      hasMore = true;
      notes!.clear();
    });
        }
      }
    }
    }else{
      oldCourse = course;
    }
    
     print('HERE THE COURSE:' + course);
    List<Note> sNotes =
        await notesServices.getUserFilesSorted(course: course, page: page);
    // print('that what it look like' + sNotes.toString());
    if (sNotes.isNotEmpty) {
      print('ITS GOING THERE');
      if (sNotes.length < 3) {
        setState(() {
          hasMore = false;
        });
      }
      print('OLDCOURSE'+ oldCourse + '/n' + 'COURSE' + course);
      if(oldCourse == course){
        setState(() {
        notes!.addAll(sNotes);
        isLoading = false;
        hasNotes = true;
      });

      }else{
        setState(() {
        
        notes = sNotes;
        isLoading = false;
        hasNotes = true;
      });

      }
      
    } else {
      if (sNotes.isEmpty) {
        setState(() {
          hasMore = false;
          isLoading = false;
        });
      }

      if (notes!.isEmpty) {
        print('ITS IF ELSE');
        setState(() {
          hasNotes = false;
          isLoading = false;
        });
      }
      if(oldCourse != course ) {
        setState(() {
        notes = sNotes;
        isLoading = false;
        hasNotes = false;
      });}
    }
  }

  Future refresh() async {
    setState(() {
      isLoading = true;
      page = 1;
      hasMore = true;
      notes!.clear();
    });
    getListNotes();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refresh,
        child: ListView(
          controller: controller,
          physics: const AlwaysScrollableScrollPhysics(),
          children: <Widget>[
            const SizedBox(height: 10),
            customDropDownButtom(),
           
            isLoading
                ? Column(
                    children: const [
                      SizedBox(height: 62),
                      Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.indigo),
                        ),
                      ),
                    ],
                  )
                : !hasNotes
                    ? Column(
                        children: [
                          const SizedBox(height: 72),
                          Text(
                            'No notes uploaded for this course',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.ptSerif(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.black),
                          ),
                        ],
                      )
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: notes!.length + 1,
                        itemBuilder: (context, index) {
                          if (index < notes!.length) {
                            return NoteCard(note: notes![index], isUserNote:false, updateNoteDelete: (){},);
                          } else {
                            return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 32),
                                child: Center(
                                    child: hasMore
                                        ? const CircularProgressIndicator()
                                        : const Text(
                                            'No more notes to load',
                                            textAlign: TextAlign.center,
                                          )));
                          }
                        },
                      ),
          ],
        ),
      ),
    );
  }

  Widget customDropDownButtom() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        
        height: 50,
        decoration: const BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 2)],
        ),
        child: DropdownButtonFormField<String>(
          hint: Text('select a course'),
          isExpanded: true,
          menuMaxHeight: 150,
          decoration: const InputDecoration(
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
            if(courseName != value){
              setState(() {
              selectedCourse = value;
              getListNotes();
            });

            }
            
          },
        ),
      ),
    );
  }
}
