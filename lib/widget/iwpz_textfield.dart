import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IWPZTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final Widget? leftWidget;
  final Widget? rightWidget;
  final double? height;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final Function()? onEditingComplete;
  final BoxBorder? border;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final double? contentPaddingValue;
  final FocusNode? focusNode;
  final bool? enabled;
  IWPZTextField({
    Key? key,
    this.controller,
    this.hintText,
    this.style = const TextStyle(color: Color(0xFF333333)),
    this.hintStyle,
    this.leftWidget,
    this.rightWidget,
    this.height,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
    this.onChanged,
    this.onEditingComplete,
    this.border,
    this.backgroundColor = Colors.white,
    this.borderRadius = BorderRadius.zero,
    this.contentPaddingValue = 10,
    this.focusNode,
    this.enabled = true,
  }) : super(key: key);

  @override
  _IWPZTextFieldState createState() => _IWPZTextFieldState();
}

class _IWPZTextFieldState extends State<IWPZTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.border != null
          ? BoxDecoration(
              color: widget.backgroundColor,
              border: widget.border!,
              borderRadius: widget.borderRadius,
            )
          : BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: widget.borderRadius,
            ),
      child: TextField(
        focusNode: widget.focusNode,
        maxLength: widget.maxLength,
        maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        controller: widget.controller,
        style: widget.style,
        textAlign: TextAlign.left,
        onChanged: (text) {
          if (widget.onChanged != null) {
            widget.onChanged!(text);
          }
        },
        onEditingComplete: () {
          if (widget.onEditingComplete != null) {
            widget.onEditingComplete!();
          }
        },
        onSubmitted: (text) {
          if (widget.onSubmitted != null) {
            widget.onSubmitted!(text);
          }
        },
        decoration: InputDecoration(
          counterText: '',
          prefixIcon: widget.leftWidget == null
              ? null
              : Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: widget.leftWidget,
                ),
          prefix: Container(width: widget.leftWidget == null ? 10 : 0),
          suffixIcon: widget.rightWidget == null
              ? null
              : Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: widget.rightWidget,
                ),
          hintText: widget.hintText ?? '',
          hintStyle: widget.hintStyle == null
              ? const TextStyle(color: Color(0xff757575), fontSize: 14, height: 1.4)
              : widget.hintStyle!,
          enabled: widget.enabled!,
          contentPadding:
              EdgeInsets.only(left: 10, top: widget.contentPaddingValue!, bottom: widget.contentPaddingValue!),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
