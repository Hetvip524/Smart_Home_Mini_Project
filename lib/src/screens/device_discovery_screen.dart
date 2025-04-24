import 'package:flutter/material.dart';
import 'package:domus/src/models/device.dart';
import 'package:domus/src/services/device_service.dart';
import 'package:provider/provider.dart';
import 'package:domus/src/services/auth_service.dart';

class DeviceDiscoveryScreen extends StatefulWidget {
  const DeviceDiscoveryScreen({Key? key}) : super(key: key);

  @override
  _DeviceDiscoveryScreenState createState() => _DeviceDiscoveryScreenState();
}

class _DeviceDiscoveryScreenState extends State<DeviceDiscoveryScreen> {
  bool _isScanning = false;
  List<Map<String, dynamic>> _discoveredDevices = [];
  final DeviceService _deviceService = DeviceService();

  void _startScan() {
    setState(() {
      _isScanning = true;
      // Simulated device discovery
      _discoveredDevices = [
        {
          'name': 'Smart Light Bulb',
          'type': 'light',
          'id': 'light_001',
        },
        {
          'name': 'Smart Thermostat',
          'type': 'thermostat',
          'id': 'therm_001',
        },
        {
          'name': 'Smart Lock',
          'type': 'lock',
          'id': 'lock_001',
        },
      ];
    });

    // Simulate scanning completion after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      }
    });
  }

  Future<void> _connectDevice(Map<String, dynamic> deviceInfo) async {
    final userId = Provider.of<AuthService>(context, listen: false).currentUser?.uid;
    if (userId == null) return;

    final device = Device(
      id: deviceInfo['id'],
      name: deviceInfo['name'],
      type: deviceInfo['type'],
      status: 'connected',
      roomId: '',
      isOnline: true,
      properties: {},
    );

    try {
      await _deviceService.addDevice(userId, device);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${device.name} connected successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to connect device')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Device'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Available Devices',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          if (_isScanning)
            const Center(child: CircularProgressIndicator())
          else if (_discoveredDevices.isEmpty)
            const Center(
              child: Text('No devices found. Try scanning again.'),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _discoveredDevices.length,
                itemBuilder: (context, index) {
                  final device = _discoveredDevices[index];
                  return ListTile(
                    leading: Icon(_getDeviceIcon(device['type'])),
                    title: Text(device['name']),
                    subtitle: Text(device['type']),
                    trailing: ElevatedButton(
                      onPressed: () => _connectDevice(device),
                      child: const Text('Connect'),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isScanning ? null : _startScan,
        child: Icon(_isScanning ? Icons.hourglass_empty : Icons.search),
      ),
    );
  }

  IconData _getDeviceIcon(String type) {
    switch (type) {
      case 'light':
        return Icons.lightbulb_outline;
      case 'thermostat':
        return Icons.thermostat;
      case 'lock':
        return Icons.lock_outline;
      default:
        return Icons.devices_other;
    }
  }
} 