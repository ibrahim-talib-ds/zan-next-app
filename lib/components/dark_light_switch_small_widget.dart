import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class DarkLightSwitchSmallWidget extends StatefulWidget {
  const DarkLightSwitchSmallWidget({super.key});

  @override
  State<DarkLightSwitchSmallWidget> createState() =>
      _DarkLightSwitchSmallWidgetState();
}

class _DarkLightSwitchSmallWidgetState
    extends State<DarkLightSwitchSmallWidget> {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ToggleButtons(
      isSelected: [!isDarkMode, isDarkMode],
      onPressed: (index) {
        setDarkModeSetting(context, index == 1 ? ThemeMode.dark : ThemeMode.light);
      },
      borderRadius: BorderRadius.circular(8.0),
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Icon(Icons.wb_sunny_rounded),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Icon(Icons.nightlight_round),
        ),
      ],
    );
  }
}
