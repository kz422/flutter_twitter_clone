import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twitterclone/Constants/Constants.dart';
import 'package:twitterclone/Models/Tweet.dart';
import 'package:twitterclone/Models/UserModel.dart';
import 'package:twitterclone/Services/DatabaseServices.dart';
import 'package:twitterclone/Services/auth_service.dart';
import 'package:twitterclone/Widgets/TweetContainer.dart';
import 'package:twitterclone/screens/EditProfileScreen.dart';
import 'package:twitterclone/screens/WelcomeScreen.dart';

class ProfileScreen extends StatefulWidget {
  final String currentUserId;
  final String visitedUserId;
  ProfileScreen({
    Key key,
    this.currentUserId,
    this.visitedUserId,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _followersCont = 0;
  int _followingCont = 0;
  List<Tweet> _allTweets = [];
  List<Tweet> _mediaTweets = [];

  int _profileSegmentValue = 0;
  Map<int, Widget> _profileTabs = <int, Widget>{
    0: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          'Tweets',
          style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
        )),
    1: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          'Media',
          style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
        )),
    2: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          'Likes',
          style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
        )),
  };

  Widget buildProfileWidgets(UserModel author) {
    switch (_profileSegmentValue) {
      case 0:
        return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _allTweets.length,
            itemBuilder: (context, index) {
              return TweetContainer(
                currentUserId: widget.currentUserId,
                author: author,
                tweet: _allTweets[index],
              );
            });
        break;
      case 1:
        return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _mediaTweets.length,
            itemBuilder: (context, index) {
              return TweetContainer(
                currentUserId: widget.currentUserId,
                author: author,
                tweet: _mediaTweets[index],
              );
            });
        break;
      case 2:
        return Center(child: Text('Likes', style: TextStyle(fontSize: 25)));
        break;
      default:
        return Center(
            child: Text('Something wrong', style: TextStyle(fontSize: 25)));
        break;
    }
  }

  getFollowersCount() async {
    int followersCount =
        await DatabaseServices.followersNum(widget.visitedUserId);
    if (mounted) {
      setState(() {
        _followersCont = followersCount;
      });
    }
  }

  getFollowingCount() async {
    int followingCount =
        await DatabaseServices.followingNum(widget.visitedUserId);
    if (mounted) {
      setState(() {
        _followingCont = followingCount;
      });
    }
  }

  getAllTweets() async {
    List<Tweet> userTweets =
        await DatabaseServices.getUserTweets(widget.visitedUserId);
    if (mounted) {
      setState(() {
        _allTweets = userTweets;
        _mediaTweets =
            _allTweets.where((element) => element.image.isNotEmpty).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getFollowersCount();
    getFollowingCount();
    getAllTweets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: userRef.doc(widget.visitedUserId).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          UserModel userModel = UserModel.fromDoc(snapshot.data);
          return ListView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.cyan,
                  image: userModel.coverImage.isEmpty
                      ? null
                      : DecorationImage(
                          image: NetworkImage(userModel.coverImage),
                          fit: BoxFit.cover,
                        ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox.shrink(),
                      PopupMenuButton(
                        icon: Icon(
                          Icons.more_horiz,
                          color: Colors.white,
                          size: 30,
                        ),
                        itemBuilder: (_) {
                          return <PopupMenuItem<String>>[
                            new PopupMenuItem(
                              child: Text('Logout'),
                              value: 'logout',
                            )
                          ];
                        },
                        onSelected: (selectedItem) {
                          if (selectedItem == 'logout') {
                            AuthService.logout();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WelcomeScreen()));
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
              Container(
                transform: Matrix4.translationValues(0.0, -40.0, 0.0),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundImage: userModel.profilePicture.isEmpty
                              ? AssetImage('assets/avatar.png')
                              : NetworkImage(userModel.profilePicture),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfileScreen(
                                  user: userModel,
                                ),
                              ),
                            );
                            setState(() {});
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            width: 100,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              border: Border.all(color: Colors.amber),
                            ),
                            child: Center(
                              child: Text(
                                'edit',
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      userModel.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      userModel.bio,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Text(
                          '$_followingCont Following',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 2,
                          ),
                        ),
                        SizedBox(width: 20),
                        Text(
                          '$_followersCont Followers',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: CupertinoSlidingSegmentedControl(
                        groupValue: _profileSegmentValue,
                        thumbColor: Colors.amber,
                        backgroundColor: Colors.blueGrey,
                        children: _profileTabs,
                        onValueChanged: (i) {
                          setState(() {
                            _profileSegmentValue = i;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
              buildProfileWidgets(userModel),
            ],
          );
        },
      ),
    );
  }
}
