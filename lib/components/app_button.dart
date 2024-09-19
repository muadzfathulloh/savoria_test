import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../components/app_colors.dart';

class AppButton extends StatefulWidget {
  const AppButton(
      {super.key,
      this.padding,
      this.backgroundColor,
      this.duration,
      this.child,
      this.contents,
      this.text,
      this.borderRadius = 0,
      this.border,
      this.textStyle,
      this.width,
      this.height,
      this.boxShadow,
      this.onTap})
      : defaultPadding = const EdgeInsets.all(0),
        color = null,
        defaultBackgroundColor = Colors.transparent;

  const AppButton.elevated(
      {super.key,
      this.padding,
      this.backgroundColor,
      this.duration,
      this.child,
      this.contents,
      this.text,
      this.borderRadius = 8,
      this.border,
      this.textStyle,
      this.width,
      this.height,
      this.boxShadow,
      this.onTap})
      : defaultPadding = const EdgeInsets.all(22.5),
        color = Colors.white,
        defaultBackgroundColor = AppColor.primary;

  AppButton.outlined(
      {super.key,
      this.padding,
      this.duration,
      this.child,
      this.contents,
      this.text,
      this.borderRadius = 8,
      this.boxShadow,
      this.backgroundColor,
      this.width,
      this.height,
      this.color,
      this.textStyle,
      this.onTap})
      : defaultPadding = const EdgeInsets.all(22.5),
        defaultBackgroundColor = Colors.transparent,
        border = Border.all(color: color ?? AppColor.primary);

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry defaultPadding;
  final Color? color;
  final Color? backgroundColor;
  final Color defaultBackgroundColor;
  final Duration? duration;
  final TextStyle? textStyle;

  final Widget? child;
  final Widget? contents;
  final String? text;
  final Future<void> Function()? onTap;
  final double? borderRadius;
  final double? width;
  final double? height;
  final BoxBorder? border;
  final BoxShadow? boxShadow;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> with SingleTickerProviderStateMixin {
  late Animation<double> _scale;
  late AnimationController _controller;
  bool _isLoading = false;
  final GlobalKey _keys = GlobalKey();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? const Duration(milliseconds: 200),
    );

    _scale = Tween<double>(begin: 1.0, end: 0.95).animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
  }

  bool _isOutsideChildBox(Offset touchPosition) {
    final RenderBox childRenderBox = _keys.currentContext?.findRenderObject() as RenderBox;
    final Size childSize = childRenderBox.size;
    final Offset childPosition = childRenderBox.localToGlobal(Offset.zero);

    return touchPosition.dx < childPosition.dx ||
        touchPosition.dx > childPosition.dx + childSize.width ||
        touchPosition.dy < childPosition.dy ||
        touchPosition.dy > childPosition.dy + childSize.height;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      key: _keys,
      onPointerDown: (PointerDownEvent event) {
        if (_isLoading) return;
        _controller.forward();
      },
      onPointerUp: (PointerUpEvent event) async {
        if (_isLoading) return;
        _controller.reverse();
        if (_isOutsideChildBox(event.position)) return;
        setState(() {
          _isLoading = true;
        });
        (widget.onTap ?? () => Future.delayed(const Duration(seconds: 1))).call().then((value) {
          try {
            setState(() {
              _isLoading = false;
            });
          } catch (_) {}
        });
      },
      child: ScaleTransition(
        scale: _scale,
        child: widget.child ??
            Container(
                alignment: Alignment.center,
                height: widget.height,
                width: widget.width == 0 ? null : widget.width ?? (double.maxFinite),
                padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 18, horizontal: 0),
                decoration: BoxDecoration(
                    boxShadow: [
                      widget.boxShadow ??
                          BoxShadow(color: const Color(0xffDDDADA).withOpacity(0.4), offset: const Offset(0, 4), blurRadius: 17),
                    ],
                    border: widget.border,
                    color: widget.backgroundColor ?? widget.defaultBackgroundColor,
                    borderRadius: BorderRadius.circular(widget.borderRadius ?? 15)),
                child: _isLoading
                    ? SpinKitThreeInOut(
                        color: widget.color ?? AppColor.primary,
                        size: 16,
                      )
                    : widget.contents ??
                        Text(
                          widget.text ?? '',
                          style: widget.textStyle ??
                              TextStyle(color: widget.color ?? AppColor.primary, fontSize: 16, fontWeight: FontWeight.w500),
                        )),
      ),
    );
  }
}
