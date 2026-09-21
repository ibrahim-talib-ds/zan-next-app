import 'package:flutter/material.dart';

class FlutterFlowButtonTabBar extends StatelessWidget {
  const FlutterFlowButtonTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.labelColor,
    this.unselectedLabelColor,
    this.backgroundColor,
    this.unselectedBackgroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.elevation,
    this.labelPadding,
    this.buttonMargin,
    this.padding,
    this.isScrollable = false,
    this.useToggleButtonStyle = false,
    this.onTap,
  });

  final List<Tab> tabs;
  final TabController? controller;
  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final Color? backgroundColor;
  final Color? unselectedBackgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final double? borderRadius;
  final double? elevation;
  final EdgeInsetsGeometry? labelPadding;
  final EdgeInsetsGeometry? buttonMargin;
  final EdgeInsetsGeometry? padding;
  final bool isScrollable;
  final bool useToggleButtonStyle;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: TabBar(
        controller: controller,
        isScrollable: isScrollable,
        labelStyle: labelStyle,
        unselectedLabelStyle: unselectedLabelStyle,
        labelColor: labelColor,
        unselectedLabelColor: unselectedLabelColor,
        indicatorColor: Colors.transparent,
        dividerColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        indicator: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
          border: Border.all(
            color: borderColor ?? Colors.transparent,
            width: borderWidth ?? 0,
          ),
        ),
        onTap: onTap,
        tabs: tabs.map((tab) {
          return Container(
            margin: buttonMargin,
            padding: labelPadding,
            decoration: BoxDecoration(
              color: unselectedBackgroundColor,
              borderRadius: BorderRadius.circular(borderRadius ?? 8),
              border: Border.all(
                color: borderColor ?? Colors.transparent,
                width: borderWidth ?? 0,
              ),
            ),
            child: tab,
          );
        }).toList(),
      ),
    );
  }
}
