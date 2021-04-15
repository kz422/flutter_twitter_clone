import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitterclone/Models/Tweet.dart';
import 'package:twitterclone/Services/DatabaseServices.dart';
import 'package:twitterclone/Services/StorageService.dart';
import 'package:twitterclone/Widgets/RoundedButton.dart';

class CreateTweetScreen extends StatefulWidget {
  final String currentUserId;

  CreateTweetScreen({Key key, this.currentUserId}) : super(key: key);

  @override
  _CreateTweetScreenState createState() => _CreateTweetScreenState();
}

class _CreateTweetScreenState extends State<CreateTweetScreen> {
  String _tweetText;
  File _pickedImage;

  bool _loading = false;

  handleImageGallery() async {
    try {
      File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
      if (imageFile != null) {
        setState(() {
          _pickedImage = imageFile;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Post',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 20),
            TextField(
              maxLength: 300,
              maxLines: 7,
              decoration: InputDecoration(hintText: 'Tweet'),
              onChanged: (value) {
                _tweetText = value;
              },
            ),
            SizedBox(height: 10),
            _pickedImage == null
                ? SizedBox.shrink()
                : Column(
                    children: [
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(_pickedImage),
                        )),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
            GestureDetector(
              onTap: handleImageGallery,
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    border: Border.all(width: 2)),
                child: Icon(Icons.camera_alt),
              ),
            ),
            SizedBox(height: 20),
            RoundedButton(
              btnText: 'Sumit',
              onBtnPressed: () async {
                setState(() {
                  _loading = true;
                });
                if (_tweetText != null && _tweetText.isNotEmpty) {
                  String image;
                  if (_pickedImage == null) {
                    image = '';
                  } else {
                    image =
                        await StorageService.uploadTweetPicture(_pickedImage);
                  }
                  Tweet tweet = Tweet(
                    text: _tweetText,
                    image: image,
                    authorId: widget.currentUserId,
                    likes: 0,
                    retweets: 0,
                    timestamp: Timestamp.fromDate(
                      DateTime.now(),
                    ),
                  );
                  DatabaseServices.createTweet(tweet);
                  Navigator.pop(context);
                }
                setState(() {
                  _loading = false;
                });
              },
            ),
            SizedBox(height: 20),
            _loading ? CircularProgressIndicator() : SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
