import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// iOS 26 "Liquid Glass" style floating tab bar.
///
/// Takes the same [BottomNavigationBarItem]s as [BottomNavigationBar] so it can
/// be swapped in without changing the items themselves.
///
/// - Press and slide a finger across the bar to move the selection bubble.
/// - The bubble stretches like a droplet while it travels to a new tab.
/// - Sliding the finger well away from the bar cancels the tap.
///
/// All look & feel values live in [_NavTuning] at the bottom of this file.
class LiquidGlassNavBar extends StatefulWidget {
  const LiquidGlassNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    required this.selectedItemColor,
    required this.unselectedItemColor,
  });

  final List<BottomNavigationBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color selectedItemColor;
  final Color unselectedItemColor;

  @override
  State<LiquidGlassNavBar> createState() => _LiquidGlassNavBarState();
}

class _LiquidGlassNavBarState extends State<LiquidGlassNavBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press;
  int? _pressed;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _NavTuning.holdMs),
      reverseDuration: const Duration(milliseconds: _NavTuning.releaseMs),
    );
  }

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  void _setPressed(int i) {
    if (_pressed != i) {
      if (_NavTuning.haptics) HapticFeedback.selectionClick();
      setState(() => _pressed = i);
    }
    _press.forward();
  }

  void _release() {
    if (_pressed != null) setState(() => _pressed = null);
    // Let the grow finish even on a quick tap, then go back to normal.
    _press.forward().whenComplete(() {
      if (mounted && _pressed == null) _press.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final n = widget.items.length;
    final target = _pressed ?? widget.currentIndex;
    const radius = _NavTuning.barRadius;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            16, _NavTuning.barTopPadding, 16, _NavTuning.barBottomPadding),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final itemWidth = width / n;
            int indexAt(double dx) => (dx / itemWidth).floor().clamp(0, n - 1);
            bool isOutside(Offset p) =>
                p.dx < -_NavTuning.cancelSlop ||
                p.dx > width + _NavTuning.cancelSlop ||
                p.dy < -_NavTuning.cancelSlop ||
                p.dy > _NavTuning.barHeight + _NavTuning.cancelSlop;

            return Listener(
              behavior: HitTestBehavior.opaque,
              onPointerDown: (e) => _setPressed(indexAt(e.localPosition.dx)),
              onPointerMove: (e) {
                if (isOutside(e.localPosition)) {
                  // Finger left the bar: cancel, pill returns to the current tab.
                  if (_pressed != null) _release();
                } else {
                  _setPressed(indexAt(e.localPosition.dx));
                }
              },
              onPointerUp: (_) {
                final i = _pressed;
                _release();
                if (i != null) widget.onTap(i);
              },
              onPointerCancel: (_) => _release(),
              child: AnimatedBuilder(
                animation: _press,
                builder: (context, child) {
                  final p = Curves.easeOut.transform(_press.value);
                  return Transform.scale(
                    scaleX: 1 + (_NavTuning.barHoldScaleX - 1) * p,
                    scaleY: 1 + (_NavTuning.barHoldScaleY - 1) * p,
                    child: child,
                  );
                },
                child: SizedBox(
                  height: _NavTuning.barHeight,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Glass background
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(radius),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withValues(alpha: isDark ? 0.14 : 0.055),
                                blurRadius: 24,
                                offset: const Offset(0, 7),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(radius),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                  sigmaX: _NavTuning.barBlur,
                                  sigmaY: _NavTuning.barBlur),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF202020).withValues(
                                          alpha: _NavTuning.barOpacityDark)
                                      : Colors.white.withValues(
                                          alpha: _NavTuning.barOpacityLight),
                                  borderRadius: BorderRadius.circular(radius),
                                  border: Border.all(
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.12)
                                        : Colors.white.withValues(alpha: 0.42),
                                    width: 0.8,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Selection droplet
                      _LiquidPill(
                        index: target,
                        itemWidth: itemWidth,
                        isDark: isDark,
                        color: widget.selectedItemColor,
                        press: _press,
                      ),
                      // Icons + labels
                      Positioned.fill(
                        child: Row(
                          children: List.generate(n, (i) {
                            return Expanded(
                              child: _GlassNavItem(
                                item: widget.items[i],
                                selected: widget.currentIndex == i,
                                pressed: _pressed == i,
                                isDark: isDark,
                                selectedColor: widget.selectedItemColor,
                                unselectedColor: widget.unselectedItemColor,
                                // Raw pointer events don't reach screen
                                // readers, so expose the tap explicitly.
                                onSemanticTap: () => widget.onTap(i),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _GlassNavItem extends StatelessWidget {
  const _GlassNavItem({
    required this.item,
    required this.selected,
    required this.pressed,
    required this.isDark,
    required this.selectedColor,
    required this.unselectedColor,
    required this.onSemanticTap,
  });

  final BottomNavigationBarItem item;
  final bool selected;
  final bool pressed;
  final bool isDark;
  final Color selectedColor;
  final Color unselectedColor;
  final VoidCallback onSemanticTap;

  @override
  Widget build(BuildContext context) {
    final base =
        isDark ? Colors.white.withValues(alpha: 0.78) : unselectedColor;
    final iconColor = selected ? selectedColor : base;
    final textColor = selected ? selectedColor.withValues(alpha: .8) : base;

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      onTap: onSemanticTap,
      excludeSemantics: true,
      child: SizedBox(
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSlide(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              offset: pressed
                  ? const Offset(0, -_NavTuning.iconHoldLift)
                  : Offset.zero,
              child: AnimatedScale(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                scale: pressed
                    ? _NavTuning.iconHoldScale
                    : (selected ? _NavTuning.iconSelectedScale : 1.0),
                child: IconTheme(
                  data: IconThemeData(color: iconColor, size: 24),
                  child: selected ? item.activeIcon : item.icon,
                ),
              ),
            ),
            const SizedBox(height: 3),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 160),
              opacity:
                  (pressed && _NavTuning.hideLabelWhileHolding) ? 0.0 : 1.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: Text(
                  item.label ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: _NavTuning.labelFontSize.sp,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    color: textColor,
                    height: 1.15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Selection bubble that stretches and squashes while sliding to the new tab.
class _LiquidPill extends StatefulWidget {
  const _LiquidPill({
    required this.index,
    required this.itemWidth,
    required this.isDark,
    required this.color,
    required this.press,
  });

  final int index;
  final double itemWidth;
  final bool isDark;
  final Color color;
  final Animation<double> press;

  @override
  State<_LiquidPill> createState() => _LiquidPillState();
}

class _LiquidPillState extends State<_LiquidPill>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  final _rnd = math.Random();

  late double _fromL, _fromR, _toL, _toR;
  double _lag = 0.25;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _NavTuning.pillMoveMs),
    );
    _fromL = _toL = widget.index.toDouble();
    _fromR = _toR = widget.index + 1.0;
    _c.value = 1;
  }

  @override
  void didUpdateWidget(covariant _LiquidPill old) {
    super.didUpdateWidget(old);
    if (old.index != widget.index) {
      // Start from wherever the pill is right now (even mid-move).
      final e = _edges();
      _fromL = e[0];
      _fromR = e[1];
      _toL = widget.index.toDouble();
      _toR = widget.index + 1.0;
      _lag = _NavTuning.dropLagMin +
          _rnd.nextDouble() * (_NavTuning.dropLagMax - _NavTuning.dropLagMin);
      _c.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  // The front of the drop rushes ahead (and overshoots a little);
  // the tail is pulled along behind it.
  List<double> _edges() {
    final t = _c.value;
    final trail = Interval(_lag, 1.0, curve: Curves.easeOutCubic);
    const lead =
        _NavTuning.dropOvershoot ? Curves.easeOutBack : Curves.easeOutCubic;
    final right = _toL > _fromL;
    final lt = (right ? trail : lead).transform(t);
    final rt = (right ? lead : trail).transform(t);
    return [
      _fromL + (_toL - _fromL) * lt,
      _fromR + (_toR - _fromR) * rt,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: Listenable.merge([_c, widget.press]),
        builder: (_, __) {
          final e = _edges();
          final p = Curves.easeOut.transform(widget.press.value);

          // How much the drop is stretched beyond a normal single tab.
          final stretch = ((e[1] - e[0]) - 1.0).clamp(0.0, 2.0);
          final pinch = _NavTuning.dropPinch * (stretch / 0.5).clamp(0.0, 1.0);

          final base = widget.isDark
              ? _NavTuning.pillOpacityDark
              : _NavTuning.pillOpacityLight;

          return CustomPaint(
            painter: _DropPainter(
              left: e[0] * widget.itemWidth +
                  _NavTuning.pillInset -
                  _NavTuning.pillHoldGrowH * p,
              right: e[1] * widget.itemWidth -
                  _NavTuning.pillInset +
                  _NavTuning.pillHoldGrowH * p,
              topInset: _NavTuning.pillInset - _NavTuning.pillHoldGrowV * p,
              pinch: pinch,
              color: widget.color.withValues(
                  alpha: base + _NavTuning.pillHoldExtraOpacity * p),
              borderColor:
                  Colors.white.withValues(alpha: _NavTuning.pillHoldBorder * p),
            ),
          );
        },
      ),
    );
  }
}

/// Draws a pill whose top and bottom edges curve inward in the middle,
/// like a droplet stretching away from the spot it left.
class _DropPainter extends CustomPainter {
  _DropPainter({
    required this.left,
    required this.right,
    required this.topInset,
    required this.pinch,
    required this.color,
    required this.borderColor,
  });

  final double left, right, topInset, pinch;
  final Color color, borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final top = topInset;
    final bottom = size.height - topInset;
    final h = bottom - top;
    // Corner radius, never more than half the height/width (= capsule).
    final rad = math.min(_NavTuning.pillRadius,
        math.min(h / 1.7, math.max(0.0, (right - left) / 2)));
    final corner = Radius.circular(rad);
    final neck = h * pinch * 0.5; // how far each side moves inward

    final innerL = left + rad;
    final innerR = right - rad;
    final span = innerR - innerL;

    final path = Path()
      ..moveTo(innerL, top)
      // top edge (pinches inward while stretching)
      ..cubicTo(innerL + span * 0.35, top + neck, innerR - span * 0.35,
          top + neck, innerR, top)
      // top-right corner, right side, bottom-right corner
      ..arcToPoint(Offset(right, top + rad), radius: corner)
      ..lineTo(right, bottom - rad)
      ..arcToPoint(Offset(innerR, bottom), radius: corner)
      // bottom edge
      ..cubicTo(innerR - span * 0.35, bottom - neck, innerL + span * 0.35,
          bottom - neck, innerL, bottom)
      // bottom-left corner, left side, top-left corner
      ..arcToPoint(Offset(left, bottom - rad), radius: corner)
      ..lineTo(left, top + rad)
      ..arcToPoint(Offset(innerL, top), radius: corner)
      ..close();

    canvas.drawPath(path, Paint()..color = color);
    if (borderColor.a > 0) {
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = borderColor,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DropPainter o) =>
      o.left != left ||
      o.right != right ||
      o.topInset != topInset ||
      o.pinch != pinch ||
      o.color != color ||
      o.borderColor != borderColor;
}

/// ALL liquid-glass nav bar values live here. Change them freely.
class _NavTuning {
  _NavTuning._();

  // ── Bar ──────────────────────────────────────────────
  static const double barHeight = 68; // height of the bar
  static const double barRadius = 40; // roundness of the bar
  static const double barTopPadding =
      14; // room above the bar so the pill can grow
  static const double barBottomPadding =
      1; // gap below the bar (above home indicator)
  static const double barBlur = 50; // glass blur strength
  static const double barOpacityLight = 0.38; // glass tint, light mode
  static const double barOpacityDark = 0.38; // glass tint, dark mode
  static const double barHoldScaleX =
      1.03; // bar width zoom while holding (1.0 = none)
  static const double barHoldScaleY =
      1.03; // bar height zoom while holding (1.0 = none)
  static const double cancelSlop =
      32; // drag this far (px) outside the bar to cancel a tap

  // ── Hold / release timing ────────────────────────────
  static const int holdMs =
      220; // speed of growing when pressed (also min. tap hold)
  static const int releaseMs = 300; // speed of returning to normal

  // ── Icon & label ─────────────────────────────────────
  static const double iconHoldScale =
      1.1; // icon size while holding (1.0 = none)
  static const double iconSelectedScale = 1.02; // icon size of the selected tab
  static const double iconHoldLift =
      0.1; // icon lift while holding, as a fraction of icon height
  static const bool hideLabelWhileHolding =
      false; // true = label fades while holding
  static const double labelFontSize = 8.5; // label size (scaled with .sp)

  // ── Pill (selection bubble) ──────────────────────────
  static const int pillMoveMs = 500; // speed of sliding to another tab
  static const double pillInset = 4; // gap between pill and bar edge
  static const double pillRadius =
      20; // pill corner roundness (30+ = full capsule; below ~20 the corners of the first/last tab poke past the bar's curve)
  static const double pillOpacityLight = 0.09; // pill colour amount, light mode
  static const double pillOpacityDark = 0.19; // pill colour amount, dark mode
  static const double pillHoldExtraOpacity =
      0.0; // extra colour while holding (0 = none)
  static const double pillHoldBorder =
      0.25; // white rim while holding (0 = none)
  static const double pillHoldGrowV = 6; // pill grows beyond bar, vertical (px)
  static const double pillHoldGrowH =
      5; // pill grows beyond bar, horizontal (px)

  // ── Droplet effect (moving between tabs) ─────────────
  static const double dropPinch =
      0.05; // how thin the "neck" gets mid-move (0 = none, 0.6 = very thin)
  static const bool dropOvershoot =
      true; // front of the drop overshoots then settles
  static const double dropLagMin =
      0.1; // tail delay, min (more = longer stretched drop)
  static const double dropLagMax = 0.2; // tail delay, max

  // ── Feedback ─────────────────────────────────────────
  static const bool haptics = false; // tiny vibration on tab change
}
