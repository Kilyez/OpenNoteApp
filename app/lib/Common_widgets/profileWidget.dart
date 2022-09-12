import 'dart:io';

import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;

  const ProfileWidget({
    Key? key,
    required this.imagePath,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(color),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {
    bool isImage = false;
    Image? image;
     if(imagePath.isNotEmpty){
      isImage = true;
      image = Image.file(File(imagePath));
    }
    
    


    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Container(
          height: 130,
          width: 130,
          // decoration: BoxDecoration(image: DecorationImage(image: image,fit: BoxFit.cover),)  ,
          child:isImage ? image : Image.asset('images/avatar.png')
          ),
        ),
      );
   
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(Icons.edit),
            color: Colors.white,
            iconSize: 20,
            onPressed: onClicked,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          height: 45,
          width: 45,
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
