import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  bool _cameraPermissionGranted = false;
  bool _microphonePermissionGranted = false;

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      _cameraPermissionGranted = status == PermissionStatus.granted;
    });
  }

  Future<void> _requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    setState(() {
      _microphonePermissionGranted = status == PermissionStatus.granted;
    });
  }

  @override
  void initState() {
    super.initState();

    unawaited(
      Permission.camera.status.then(
        (value) {
          setState(() {
            _cameraPermissionGranted = value == PermissionStatus.granted;
          });
        },
      ),
    );

    unawaited(
      Permission.microphone.status.then(
        (value) {
          setState(() {
            _microphonePermissionGranted = value == PermissionStatus.granted;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permissions'),
      ),
      body: Center(
        child: Column(
          children: [
            _PermissionTile(
              name: 'Camera',
              icon: Icons.camera,
              granted: _cameraPermissionGranted,
              onTap: _requestCameraPermission,
            ),
            _PermissionTile(
              name: 'Microphone',
              icon: Icons.mic,
              granted: _microphonePermissionGranted,
              onTap: _requestMicrophonePermission,
            ),
          ],
        ),
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  const _PermissionTile({
    required this.name,
    required this.icon,
    required this.granted,
    required this.onTap,
  });

  final String name;
  final IconData icon;
  final bool granted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: Key(name.toLowerCase()),
      padding: const EdgeInsets.all(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: granted
              ? Theme.of(context).colorScheme.background
              : Colors.redAccent,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon),
                const SizedBox(width: 8),
                Text(
                  name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            Text(
              key: const Key('statusText'),
              granted ? 'Granted' : 'Not granted',
            ),
            TextButton(
              onPressed: onTap,
              child: Text(
                'Request ${name.toLowerCase()} permission',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
