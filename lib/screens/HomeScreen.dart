import 'package:flutter/material.dart';
import 'package:twitterclone/Constants/Constants.dart';
import 'package:twitterclone/Models/Tweet.dart';
import 'package:twitterclone/Models/UserModel.dart';
import 'package:twitterclone/Services/DatabaseServices.dart';
import 'package:twitterclone/Widgets/TweetContainer.dart';
import 'package:twitterclone/screens/CreateTweetScreen.dart';

class HomeScreen extends StatefulWidget {
  final String currentUserId;

  HomeScreen({Key key, this.currentUserId}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List _followingTweets = [];
  bool _loading = false;

  buildTweets(Tweet tweet, UserModel author) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: TweetContainer(
        tweet: tweet,
        author: author,
        currentUserId: widget.currentUserId,
      ),
    );
  }

  showFollowingTweets(String currentUserId) {
    List<Widget> followingTweetList = [];
    for (Tweet tweet in _followingTweets) {
      followingTweetList.add(
        FutureBuilder(
          future: userRef.doc(tweet.authorId).get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              UserModel author = UserModel.fromDoc(snapshot.data);
              return buildTweets(tweet, author);
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      );
    }
    return followingTweetList;
  }

  setUpFollowingTweets() async {
    setState(() {
      _loading = true;
    });
    List followingTweets =
        await DatabaseServices.getHomeTweets(widget.currentUserId);
    if (mounted) {
      setState(() {
        _followingTweets = followingTweets;
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setUpFollowingTweets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => CreateTweetScreen(
                    currentUserId: widget.currentUserId,
                  ),
                ));
          },
          child: Image.asset('assets/post.png'),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: .5,
          centerTitle: true,
          leading: Container(
            height: 40,
          ),
          title: Text(
            'Home',
            style: TextStyle(color: Colors.black26),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () => setUpFollowingTweets(),
          child: ListView(
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            children: [
              _loading ? LinearProgressIndicator() : SizedBox.shrink(),
              SizedBox(height: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 5),
                  Column(
                    children: _followingTweets.isEmpty && _loading == false
                        ? [
                            SizedBox(height: 5),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 25),
                                child: Text(
                                  'There is no new Tweets',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                )),
                          ]
                        : showFollowingTweets(widget.currentUserId),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
