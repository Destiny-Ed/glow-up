import 'dart:developer' as developer;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactSyncResult {
  final int totalContactsSynced;
  final int friendsFoundOnApp;
  final List<Map<String, dynamic>> usersOnApp;

  ContactSyncResult({
    required this.totalContactsSynced,
    required this.friendsFoundOnApp,
    required this.usersOnApp,
  });
}

class AppContactService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Securely sync contacts and find which ones are already on GlowUp
  Future<ContactSyncResult> syncAndFindFriends() async {
    try {
      final bool granted = await FlutterContacts.requestPermission(
        readonly: true,
      );
      if (!granted) {
        Fluttertoast.showToast(msg: 'Contacts permission denied');
        return ContactSyncResult(
          totalContactsSynced: 0,
          friendsFoundOnApp: 0,
          usersOnApp: [],
        );
      }

      final List<Contact> contacts = await FlutterContacts.getContacts(
        withProperties: true,
        withThumbnail: false,
      );

      final contactsWithPhones = contacts
          .where((c) => c.phones.isNotEmpty)
          .toList();
      developer.log(
        'Fetched ${contactsWithPhones.length} contacts with phone numbers',
      );

      if (contactsWithPhones.isEmpty) {
        return ContactSyncResult(
          totalContactsSynced: 0,
          friendsFoundOnApp: 0,
          usersOnApp: [],
        );
      }

      // Securely hash phone numbers (E.164 format) before sending to Firestore
      final Set<String> hashedPhones = {};
      for (var contact in contactsWithPhones) {
        for (var phone in contact.phones) {
          final cleaned = phone.number.replaceAll(
            RegExp(r'\D'),
            '',
          ); // Remove non-digits
          final e164 = cleaned.startsWith('1')
              ? '+$cleaned'
              : cleaned.length >= 10
              ? '+1$cleaned'
              : null;
          if (e164 != null && e164.length >= 10) {
            final hash = sha256.convert(utf8.encode(e164)).toString();
            hashedPhones.add(hash);
          }
        }
      }

      if (hashedPhones.isEmpty) {
        return ContactSyncResult(
          totalContactsSynced: contactsWithPhones.length,
          friendsFoundOnApp: 0,
          usersOnApp: [],
        );
      }

      // Query Firestore for users with matching hashed phones
      final snapshot = await _db
          .collection('users')
          .where('hashedPhone', whereIn: hashedPhones.toList())
          .get();

      final List<Map<String, dynamic>> usersOnApp = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        usersOnApp.add({
          'uid': doc.id,
          'name': data['name'] ?? 'Unknown',
          'userName': data['userName'] ?? '',
          'profilePictureUrl': data['profilePictureUrl'],
        });
      }

      developer.log('Found ${usersOnApp.length} friends already on GlowUp');

      return ContactSyncResult(
        totalContactsSynced: contactsWithPhones.length,
        friendsFoundOnApp: usersOnApp.length,
        usersOnApp: usersOnApp,
      );
    } catch (e) {
      developer.log('Contact sync error: $e');
      Fluttertoast.showToast(msg: 'Error syncing contacts');
      return ContactSyncResult(
        totalContactsSynced: 0,
        friendsFoundOnApp: 0,
        usersOnApp: [],
      );
    }
  }

  /// Optional: Auto-add found friends (after user confirms)
  Future<void> addFoundFriendsAsFriends(
    List<String> friendUids,
    String currentUid,
  ) async {
    final batch = _db.batch();

    for (var friendUid in friendUids) {
      batch.update(_db.collection('users').doc(currentUid), {
        'friendUids': FieldValue.arrayUnion([friendUid]),
      });
      batch.update(_db.collection('users').doc(friendUid), {
        'friendUids': FieldValue.arrayUnion([currentUid]),
      });
    }

    await batch.commit();
  }
}
