import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:workforceclientapp/Others/MyColors.dart';

/// Shimmering placeholder bubbles shown while a conversation loads.
/// No extra package — the sweep is an AnimationController driving a
/// LinearGradient through a ShaderMask.
class ChatLoadingSkeleton extends StatefulWidget {
  const ChatLoadingSkeleton({super.key});

  @override
  State<ChatLoadingSkeleton> createState() => _ChatLoadingSkeletonState();
}

class _ChatLoadingSkeletonState extends State<ChatLoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // mine, width fraction of the screen, number of text lines
  static const List<({bool mine, double width, int lines})> _pattern = [
    (mine: false, width: 0.58, lines: 2),
    (mine: true, width: 0.42, lines: 1),
    (mine: false, width: 0.70, lines: 3),
    (mine: true, width: 0.52, lines: 2),
    (mine: false, width: 0.38, lines: 1),
    (mine: true, width: 0.64, lines: 2),
    (mine: false, width: 0.48, lines: 1),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // -1 -> 1 so the highlight travels fully across and off screen.
        final slide = (_controller.value * 2) - 1;

        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(slide - 0.35, 0),
              end: Alignment(slide + 0.35, 0),
              colors: const [
                Color(0xFFEDEDED),
                Color(0xFFFAFAFA),
                Color(0xFFEDEDED),
              ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      // Built once — only the shader animates, so there is no rebuild per
      // frame.
      child: ListView(
        padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 14.h),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _dateSeparatorBone(),
          SizedBox(height: 6.h),
          ..._pattern.map((b) => _bubbleBone(
                mine: b.mine,
                width: maxWidth * b.width,
                lines: b.lines,
              )),
        ],
      ),
    );
  }

  Widget _dateSeparatorBone() {
    return Center(
      child: Container(
        width: 86.w,
        height: 20.h,
        decoration: BoxDecoration(
          color: const Color(MyColors.cardGrayColor100),
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
    );
  }

  Widget _bubbleBone({
    required bool mine,
    required double width,
    required int lines,
  }) {
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: width,
        margin: EdgeInsets.symmetric(vertical: 4.r),
        padding: EdgeInsets.symmetric(vertical: 10.r, horizontal: 14.r),
        decoration: BoxDecoration(
          color: const Color(MyColors.cardGrayColor100),
          // Matches the real bubbles: square corner on the sender's side.
          borderRadius: mine
              ? BorderRadius.only(
                  bottomLeft: Radius.circular(8.r),
                  topRight: Radius.circular(8.r),
                  topLeft: Radius.circular(8.r),
                  bottomRight: Radius.zero,
                )
              : BorderRadius.only(
                  bottomLeft: Radius.zero,
                  topRight: Radius.circular(8.r),
                  topLeft: Radius.circular(8.r),
                  bottomRight: Radius.circular(8.r),
                ),
        ),
        child: Column(
          crossAxisAlignment:
              mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < lines; i++) ...[
              Container(
                height: 9.h,
                // Last line stops short, the way real text wraps.
                width: i == lines - 1 ? width * 0.45 : double.infinity,
                decoration: BoxDecoration(
                  color: const Color(MyColors.silverColor),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(height: 6.h),
            ],
            Container(
              height: 7.h,
              width: 34.w,
              decoration: BoxDecoration(
                color: const Color(MyColors.silverColor),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
