import 'package:flutter/material.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';

class ShimmerLoader extends StatefulWidget {
  final double? width,height;

  const ShimmerLoader({this.width,this.height,this.margin,this.borderRadius});
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;

  @override
   State<ShimmerLoader> createState() => _ShimmerLoaderState();
}
class _ShimmerLoaderState extends State<ShimmerLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds:1000),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
         builder: (context, child) {
        const beginAlignment = Alignment.topRight;
        const endAlignment = Alignment.bottomLeft;
        final gradient = LinearGradient(
          begin: Alignment.lerp(beginAlignment, endAlignment, _animation.value)!,
          end: Alignment.lerp(beginAlignment, endAlignment, _animation.value - 0.5)!,
          colors: dark(context) ? [
            Colors.grey[700]!,
            Colors.grey[500]!,
            Colors.grey[700]!,
          ]:[
            Colors.grey[300]!,
            Colors.grey[100]!,
            Colors.grey[300]!,
          ],
          stops: const [0.0, 0.5, 1.0],
        );
        return Container(
          // duration: Duration(milliseconds: 100),
          // curve: Curves.linear,
          width: widget.width,
          height: widget.height,
          margin: widget.margin ?? const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular( widget.borderRadius ??20),
            gradient:gradient,
          ),
        );
      },
    );
  }
}

dark(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}




class AnimateWidget extends StatefulWidget {
  final double? width,height;

  const AnimateWidget({this.width,this.height,this.margin,required this.child,this.borderRadius});
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final Widget child;

  @override
   State<AnimateWidget> createState() => _AnimateWidgetState();
}
class _AnimateWidgetState extends State<AnimateWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation,_animation2,_animation3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds:1000),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween(begin: 0.8, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
     _animation2 = Tween(begin: 0.4, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
      _animation3 = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(_animation.value);
    return AnimatedBuilder(
      animation: _animation,
         builder: (context, child) {
        // final gradient = LinearGradient(
        //   begin: Alignment.lerp(beginAlignment, endAlignment, _animation.value)!,
        //   end: Alignment.lerp(beginAlignment, endAlignment, _animation.value - 0.5)!,
        //   colors: dark(context) ? [
        //     Colors.grey[700]!,
        //     Colors.grey[500]!,
        //     Colors.grey[700]!,
        //   ]:[
        //     Colors.grey[300]!,
        //     Colors.grey[100]!,
        //     Colors.grey[300]!,
        //   ],
        //   stops: const [0.0, 0.5, 1.0],
        // );
        return ScaleTransition(
            scale: _animation,
            child: Stack(
              children: [
              AnimatedContainer(
                      duration: Duration(milliseconds: 100),
                       curve: Curves.easeInOut,
                      width: widget.width,
                      height: widget.height,
                      margin: widget.margin ?? const EdgeInsets.only(right: 0),
                      
                      decoration: BoxDecoration(
              // border: Border.lerp(Border.all(width: 1,color:Colors.grey.shade500), Border.all(width: 1,color : _animation.value >= 0.8 && _animation.value <= 0.9
              //  ? Colors.grey.shade400 :Colors.grey.shade200 ), 1.0),
              borderRadius: BorderRadius.circular( widget.borderRadius ?? 20),
              // gradient:gradient,
            ),
               child: widget.child),
               Positioned.fill(child: CircularProgressIndicator(
                value: _animation2.value,
                strokeWidth: 1,
                color: MyColor.commonColorSet2,
               ))
            ]),
        );
      },
    );
  }
}