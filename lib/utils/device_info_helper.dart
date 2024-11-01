import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:paperly/constants/app_colors.dart';

class DeviceInfoHelper extends StatefulWidget {
  const DeviceInfoHelper({super.key});

  @override
  State<DeviceInfoHelper> createState() => _DeviceInfoHelperState();
}

class _DeviceInfoHelperState extends State<DeviceInfoHelper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              final info = await DeviceInfoPlugin().androidInfo;
              info.toString();
            },
            child: const Text("Press")),
      ),
    );
  }
}
