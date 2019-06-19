import 'package:animation_text/page/widgets/like_button.dart';
import 'package:animation_text/page/widgets/like_button_typedef.dart';
import 'package:flutter/material.dart';

const double buttonSize = 40.0;

class LikeButtonPage extends StatefulWidget {
  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButtonPage> {
  @override
  Widget build(BuildContext context) {
    final int likeCount = 999;
    return Material(
        child: Column(children: <Widget>[
      AppBar(
        title: Text("Like Button Demo"),
      ),
      Expanded(
        child: GridView(
          children: <Widget>[
            LikeButton(
              size: buttonSize,
              likeCount: likeCount,
              countBuilder: (int count, bool isLiked, String text) {
                var color = isLiked ? Colors.pinkAccent : Colors.grey;
                Widget result;
                if (count == 0) {
                  result = Text(
                    "love",
                    style: TextStyle(color: color),
                  );
                } else
                  result = Text(
                    count >= 1000
                        ? (count / 1000.0).toStringAsFixed(1) + "k"
                        : text,
                    style: TextStyle(color: color),
                  );
                return result;
              },
              likeCountAnimationType: likeCount < 1000
                  ? LikeCountAnimationType.part
                  : LikeCountAnimationType.none,
              likeCountPadding: EdgeInsets.only(left: 15.0),
            ),
            LikeButton(
              size: buttonSize,

              likeBuilder: (bool isLiked) {
                return Icon(
                  Icons.home,
                  color: isLiked ? Colors.deepPurpleAccent : Colors.grey,
                  size: buttonSize,
                );
              },
              likeCount: 665,
              countBuilder: (int count, bool isLiked, String text) {
                var color = isLiked ? Colors.deepPurpleAccent : Colors.grey;
                Widget result;
                if (count == 0) {
                  result = Text(
                    "love",
                    style: TextStyle(color: color),
                  );
                } else
                  result = Text(
                    text,
                    style: TextStyle(color: color),
                  );
                return result;
              },
              likeCountPadding: EdgeInsets.only(left: 15.0),
            ),
            LikeButton(
              size: buttonSize,
              likeBuilder: (bool isLiked) {
                return Icon(
                  Icons.adb,
                  color: isLiked ? Colors.green : Colors.grey,
                  size: buttonSize,
                );
              },
              likeCount: 665,
              likeCountAnimationType: LikeCountAnimationType.all,
              countBuilder: (int count, bool isLiked, String text) {
                var color = isLiked ? Colors.green : Colors.grey;
                Widget result;
                if (count == 0) {
                  result = Text(
                    "love",
                    style: TextStyle(color: color),
                  );
                } else
                  result = Text(
                    text,
                    style: TextStyle(color: color),
                  );
                return result;
              },
              likeCountPadding: EdgeInsets.only(left: 15.0),
            ),
            LikeButton(
              size: buttonSize,
              isLiked: null,

              likeBuilder: (bool isLiked) {
                return Icon(
                  Icons.assistant_photo,
                  color: Colors.red,
                  size: buttonSize,
                );
              },
              likeCount: 1000,
              countBuilder: (int count, bool isLiked, String text) {
                var color = Colors.red;
                Widget result;
                if (count == 0) {
                  result = Text(
                    "love",
                    style: TextStyle(color: color),
                  );
                } else
                  result = Text(
                    text,
                    style: TextStyle(color: color),
                  );
                return result;
              },
              likeCountPadding: EdgeInsets.only(left: 15.0),
            ),

            LikeButton(
              size: buttonSize,

              likeBuilder: (bool isLiked) {
                return Icon(
                  Icons.insert_emoticon,
                  color: isLiked ? Colors.lightBlueAccent : Colors.grey,
                  size: buttonSize,
                );
              },
            ),


            LikeButton(
              size: buttonSize,

              likeBuilder: (bool isLiked) {
                return Icon(
                  Icons.cloud,
                  color: isLiked ? Colors.grey[900] : Colors.grey,
                  size: buttonSize,
                );
              },
            ),
          ],
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        ),
      )
    ]));
  }
}
