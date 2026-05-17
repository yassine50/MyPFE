import 'package:firebase_database/firebase_database.dart';

class NotificationService {
  static final _db = FirebaseDatabase.instance.ref();

  /// Sends a push notification via Firebase Realtime Database
  static Future<void> sendNotification({
    required String targetUserId,
    required String type, // e.g. 'booking_request', 'booking_accepted', 'message'
    required String title,
    required String body,
  }) async {
    final notifRef = _db.child('notifications').child(targetUserId).push();
    await notifRef.set({
      'type': type,
      'title': title,
      'body': body,
      'read': false,
      'createdAt': ServerValue.timestamp,
    });
  }

  static Future<void> sendBookingRequestNotification({
    required String hostId,
    required String renterName,
    required String propertyTitle,
  }) async {
    await sendNotification(
      targetUserId: hostId,
      type: 'booking_request',
      title: 'New Booking Request',
      body: '$renterName has requested to book $propertyTitle.',
    );
  }

  static Future<void> sendBookingStatusNotification({
    required String renterId,
    required String hostName,
    required String propertyTitle,
    required bool accepted,
  }) async {
    final status = accepted ? 'accepted' : 'declined';
    await sendNotification(
      targetUserId: renterId,
      type: accepted ? 'booking_accepted' : 'booking_rejected',
      title: 'Booking $status',
      body: '$hostName has $status your request for $propertyTitle.',
    );
  }

  static Future<void> sendMessageNotification({
    required String targetUserId,
    required String senderName,
    required String messagePreview,
  }) async {
    await sendNotification(
      targetUserId: targetUserId,
      type: 'message',
      title: 'New Message from $senderName',
      body: messagePreview,
    );
  }
}
