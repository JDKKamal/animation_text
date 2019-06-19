import 'package:flutter/material.dart';

typedef LikeButtonTapCallback = Future<bool> Function(bool isLiked);

///build widget when isLike is changing
typedef LikeWidgetBuilder = Widget Function(bool isLiked);

///build widget when likeCount is changing
typedef LikeCountWidgetBuilder = Widget Function(
    int likeCount, bool isLiked, String text);

enum LikeCountAnimationType {
  //no animation
  none,
  //animation only on change part
  part,
  //animation on all
  all,
}
