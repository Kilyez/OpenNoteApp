import 'package:app/services/notes_services.dart';
import 'package:app/utils/user_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/Common_widgets/note_card.dart';
import 'package:app/Models/notes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../Common_widgets/profileWidget.dart';
import '../Models/user.dart';
import '../providers/user_provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  List<Note>? notes = <Note>[];
  NotesServices notesServices = NotesServices();
  bool isLoading = false;
  final controller = ScrollController();
  int page = 1;
  bool hasMore = true;
  bool hasNotes = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
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

  void getListNotes() async {
    List<Note> sNotes =
        await notesServices.getUserFiles(context: context, page: page);
    // print('that what it look like' + sNotes.toString());
    if (sNotes.isNotEmpty) {
      print('ITS GOING THERE');
      if (sNotes.length < 3) {
        setState(() {
          hasMore = false;
        });
      }
      setState(() {
        notes!.addAll(sNotes);
        isLoading = false;
        hasNotes = true;
      });
    } else {
      if(sNotes.isEmpty) {
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
    String? imagePath = UserSharedPreferences.getUserImage();
    User user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refresh,
        child: ListView(
          controller: controller,
          physics: const AlwaysScrollableScrollPhysics(),
          children: <Widget>[
            const SizedBox(height: 40),
            ProfileWidget(
              imagePath: imagePath ??
                  '',
              onClicked: () {
                changeUserImage(context, imagePath);
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              user.email,
              textAlign: TextAlign.center,
              style: GoogleFonts.ptSerif(
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                  color: Colors.black),
            ),
            const SizedBox(
              height: 26,
            ),
            customDivider('MY NOTES'),
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
                            'No notes uploaded',
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
                            return NoteCard(note: notes![index]);
                          } else {
                            return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 32),
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

  customDivider(String title) {
    return Row(
      children: [
        Expanded(
          child: Container(
             color: Colors.indigo,
           
            height: 10,
            
            
            
        
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            color: Color.fromARGB(255, 226, 235, 249),
            boxShadow: [BoxShadow(color: Colors.indigo, blurRadius: 5)]
          ),
          child: Center(
            child: Text(
              title,
              style: GoogleFonts.ptSerif(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.black),
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.indigo,
            height: 10,
          ),
        ),
      ],
    );
  }

  void changeUserImage(BuildContext context, String? imagePath) async {
    final result = await FilePicker.platform.pickFiles(
        allowedExtensions: ['png', 'jpg', 'jpeg','jfif'],
        type: FileType.custom,
        withData: true);
    if (result != null) {
      final file = result.files.first;
      String? path = file.path;
      setState(() {
        imagePath = path;
        UserSharedPreferences.setUserImage(path!);
      });
    }
  }
}
