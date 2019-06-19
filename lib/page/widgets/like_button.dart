import 'package:flutter/material.dart';

import 'like_button_typedef.dart';

class LikeButton extends StatefulWidget {
  ///size of like widget
  final double size;

  ///animation duration to change isLiked state
  final Duration animationDuration;

  /// tap call back of like button
  final LikeButtonTapCallback onTap;

  ///whether it is liked
  final bool isLiked;

  ///like count
  ///if null, will not show
  final int likeCount;

  /// mainAxisAlignment for like button
  final MainAxisAlignment mainAxisAlignment;

  ///builder to create like widget
  final LikeWidgetBuilder likeBuilder;

  ///builder to create like count widget
  final LikeCountWidgetBuilder countBuilder;

  ///animation duration to change like count
  final Duration likeCountAnimationDuration;

  ///animation type to change like count(none,part,all)
  final LikeCountAnimationType likeCountAnimationType;

  ///padding for like count widget
  final EdgeInsetsGeometry likeCountPadding;

  const LikeButton({
    Key key,
    this.size: 30.0,
    this.likeBuilder,
    this.countBuilder,
    this.likeCount,
    this.isLiked: false,
    this.mainAxisAlignment: MainAxisAlignment.center,
    this.animationDuration = const Duration(milliseconds: 1000),
    this.likeCountAnimationType = LikeCountAnimationType.part,
    this.likeCountAnimationDuration = const Duration(milliseconds: 500),
    this.likeCountPadding = const EdgeInsets.only(left: 3.0),
    this.onTap,
  }) ;

  @override
  State<StatefulWidget> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _slidePreValueAnimation;
  Animation<Offset> _slideCurrentValueAnimation;
  AnimationController _likeCountController;
  Animation<double> _opacityAnimation;

  bool _isLiked = false;
  int _likeCount;
  int _preLikeCount;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
    _likeCount = widget.likeCount;
    _preLikeCount = _likeCount;

    _controller =
        AnimationController(duration: widget.animationDuration, vsync: this);
    _likeCountController = AnimationController(
        duration: widget.likeCountAnimationDuration, vsync: this);

    _initAnimations();
  }

  @override
  void didUpdateWidget(LikeButton oldWidget) {
    _isLiked = widget.isLiked;
    _likeCount = widget.likeCount;
    _preLikeCount = _likeCount;

    _controller =
        AnimationController(duration: widget.animationDuration, vsync: this);
    _likeCountController = AnimationController(
        duration: widget.likeCountAnimationDuration, vsync: this);

    _initAnimations();

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    _likeCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _onTap,
      child: Row(
        mainAxisAlignment: widget.mainAxisAlignment,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _getLikeCountWidget()
        ],
      ),
    );
  }

  Widget _getLikeCountWidget() {
    if (_likeCount == null) return Container();
    var likeCount = _likeCount.toString();
    var preLikeCount = _preLikeCount.toString();

    int didIndex = 0;
    if (preLikeCount.length == likeCount.length) {
      for (; didIndex < likeCount.length; didIndex++) {
        if (likeCount[didIndex] != preLikeCount[didIndex]) {
          break;
        }
      }
    }
    bool allChange = preLikeCount.length != likeCount.length || didIndex == 0;

    Widget result;

    if (widget.likeCountAnimationType == LikeCountAnimationType.none ||
        _likeCount == _preLikeCount) {
      result = _createLikeCountWidget(
          _likeCount, (_isLiked ?? true), _likeCount.toString());
    } else if (widget.likeCountAnimationType == LikeCountAnimationType.part &&
        !allChange) {
      var samePart = likeCount.substring(0, didIndex);
      var preText = preLikeCount.substring(didIndex, preLikeCount.length);
      var text = likeCount.substring(didIndex, likeCount.length);
      var preSameWidget =
          _createLikeCountWidget(_preLikeCount, !(_isLiked ?? true), samePart);
      var currentSameWidget =
          _createLikeCountWidget(_likeCount, (_isLiked ?? true), samePart);
      var preWidget =
          _createLikeCountWidget(_preLikeCount, !(_isLiked ?? true), preText);
      var currentWidget =
          _createLikeCountWidget(_likeCount, (_isLiked ?? true), text);

      result = AnimatedBuilder(
          animation: _likeCountController,
          builder: (b, w) {
            return Row(
              children: <Widget>[
                Stack(
                  fit: StackFit.passthrough,
                  overflow: Overflow.clip,
                  children: <Widget>[
                    Opacity(
                      child: currentSameWidget,
                      opacity: _opacityAnimation.value,
                    ),
                    Opacity(
                      child: preSameWidget,
                      opacity: 1.0 - _opacityAnimation.value,
                    ),
                  ],
                ),
                Stack(
                  fit: StackFit.passthrough,
                  overflow: Overflow.clip,
                  children: <Widget>[
                    FractionalTranslation(
                        translation: _preLikeCount > _likeCount
                            ? _slideCurrentValueAnimation.value
                            : -_slideCurrentValueAnimation.value,
                        child: currentWidget),
                    FractionalTranslation(
                        translation: _preLikeCount > _likeCount
                            ? _slidePreValueAnimation.value
                            : -_slidePreValueAnimation.value,
                        child: preWidget),
                  ],
                )
              ],
            );
          });
    } else {
      result = AnimatedBuilder(
        animation: _likeCountController,
        builder: (b, w) {
          return Stack(
            fit: StackFit.passthrough,
            overflow: Overflow.clip,
            children: <Widget>[
              FractionalTranslation(
                  translation: _preLikeCount > _likeCount
                      ? _slideCurrentValueAnimation.value
                      : -_slideCurrentValueAnimation.value,
                  child: _createLikeCountWidget(
                      _likeCount, (_isLiked ?? true), _likeCount.toString())),
              FractionalTranslation(
                  translation: _preLikeCount > _likeCount
                      ? _slidePreValueAnimation.value
                      : -_slidePreValueAnimation.value,
                  child: _createLikeCountWidget(_preLikeCount,
                      !(_isLiked ?? true), _preLikeCount.toString())),
            ],
          );
        },
      );
    }

    result = ClipRect(
      child: result,
      clipper: LikeCountClip(),
    );

    if (widget.likeCountPadding != null) {
      result = Padding(
        padding: widget.likeCountPadding,
        child: result,
      );
    }

    return result;
  }

  Widget _createLikeCountWidget(int likeCount, bool isLiked, String text) {
    return widget.countBuilder?.call(likeCount, isLiked, text) ??
        Text(text, style: TextStyle(color: Colors.grey));
  }

  void _onTap() {
    if (_controller.isAnimating || _likeCountController.isAnimating) return;
    if (widget.onTap != null) {
      widget.onTap((_isLiked ?? true)).then((isLiked) {
        _handleIsLikeChanged(isLiked);
      });
    } else {
      _handleIsLikeChanged(!(_isLiked ?? true));
    }
  }

  void _handleIsLikeChanged(bool isLiked) {
    if (_isLiked == null) {
      if (_likeCount != null) {
        _preLikeCount = _likeCount;
        _likeCount++;
      }
      if (mounted) {
        setState(() {
          _controller.reset();
          _controller.forward();

          if (widget.likeCountAnimationType != LikeCountAnimationType.none) {
            _likeCountController.reset();
            _likeCountController.forward();
          }
        });
      }
      return;
    }

    if (isLiked != null && isLiked != _isLiked) {
      if (_likeCount != null) {
        _preLikeCount = _likeCount;
        if (isLiked) {
          _likeCount++;
        } else {
          _likeCount--;
        }
      }
      _isLiked = isLiked;

      if (mounted) {
        setState(() {
          if (_isLiked) {
            _controller.reset();
            _controller.forward();
          }
          if (widget.likeCountAnimationType != LikeCountAnimationType.none) {
            _likeCountController.reset();
            _likeCountController.forward();
          }
        });
      }
    }
  }

  void _initAnimations() {
    _initLikeCountControllerAnimation();
  }

  void _initLikeCountControllerAnimation() {
    _slidePreValueAnimation = _likeCountController.drive(Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0.0, 1.0),
    ));
    _slideCurrentValueAnimation = _likeCountController.drive(Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ));
    _opacityAnimation = _likeCountController.drive(Tween<double>(
      begin: 0.0,
      end: 1.0,
    ));
  }
}

class LikeCountClip extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Offset.zero & size;
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}