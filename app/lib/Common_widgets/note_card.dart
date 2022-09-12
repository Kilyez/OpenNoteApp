import 'dart:io';

import 'package:app/Models/notes.dart';
import 'package:app/services/notes_services.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class NoteCard extends StatefulWidget {
  NoteCard({super.key, required this.note, required this.isUserNote, required this.updateNoteDelete});
  Note note = Note('', '', '', '',[]);
  bool isUserNote;
  Function updateNoteDelete;
  
  
  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  PdfViewerController controller = PdfViewerController();
 
  NotesServices notesService = NotesServices();
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
    controller.goToPointInPage(
      pageNumber: 1,
      x: 0.5,
      y: 0.5,
      anchor: PdfViewerAnchor.center,
      zoomRatio: 3,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(listen : false , context).user; 
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 235, 241, 250),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [BoxShadow(color: Colors.grey, spreadRadius: 0.5, blurRadius: 0.5)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                
                children: [
                  Text(widget.note.course,
                  textAlign: TextAlign.center,
                      style: GoogleFonts.ptSerif(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black)),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(widget.note.title,
                  textAlign: TextAlign.center,
                      style: GoogleFonts.ptSerif(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Colors.black)),
                  const SizedBox(height: 5.0),
                  const Divider(color: Colors.grey, thickness: 0.8,),
                  Center(
                    child: Container(
                      // color: ,
                      // padding: const EdgeInsets.symmetric(  horizontal: 100),
                      constraints:
                          BoxConstraints(maxHeight: 200, minWidth: 20),

                      child: PdfViewer.openFile(widget.note.pathName!,
                          viewerController: controller),
                    ),
                  )
                ],
              ),
            ),
            const Divider(color: Colors.grey, thickness: 1,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  iconSize: 20,
                  icon: Icon(Icons
                      .remove_red_eye_outlined), //Icons.remove_red_eye_outlined,
                  onPressed: () {OpenFile.open(widget.note.pathName);},
                ),
                LikeButton(
                  size: 20,
                  onTap: updateLiked,
                  isLiked: widget.note.like.contains(user.id),
                  likeCount: widget.note.like.length,
                ),
                widget.isUserNote ? IconButton(
                  iconSize: 20,
                  icon: Icon(Icons.delete),
                  onPressed: deleteNote,
                ) : IconButton(
                  iconSize: 20,
                  icon: Icon(Icons.edit),
                  onPressed: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<bool> updateLiked(bool isliked) async{
    
    notesService.updateNote(note: widget.note,context: context,isliked: !isliked);
    return !isliked;
  }

  void deleteNote(){
    notesService.deleteNote(id: widget.note.id);
    widget.updateNoteDelete(note: widget.note);
  }
}
