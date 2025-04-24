import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domus/src/models/device.dart';

class DeviceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all devices for a user
  Stream<List<Device>> getUserDevices(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('devices')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Device.fromMap({'id': doc.id, ...doc.data()}))
          .toList();
    });
  }

  // Add a new device
  Future<Device> addDevice(String userId, Device device) async {
    final docRef = await _firestore
        .collection('users')
        .doc(userId)
        .collection('devices')
        .add(device.toMap());
    
    return device.copyWith(id: docRef.id);
  }

  // Update device status
  Future<void> updateDeviceStatus(String userId, String deviceId, String status) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('devices')
        .doc(deviceId)
        .update({'status': status});
  }

  // Delete device
  Future<void> deleteDevice(String userId, String deviceId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('devices')
        .doc(deviceId)
        .delete();
  }

  // Update device properties
  Future<void> updateDeviceProperties(
    String userId,
    String deviceId,
    Map<String, dynamic> properties,
  ) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('devices')
        .doc(deviceId)
        .update({'properties': properties});
  }
} 