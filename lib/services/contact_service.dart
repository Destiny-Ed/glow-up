import 'dart:developer' as developer;
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
  // Future<ContactSyncResult> syncAndFindFriends() async {
  //   try {
  //     final bool granted = await FlutterContacts.requestPermission(
  //       readonly: true,
  //     );
  //     if (!granted) {
  //       Fluttertoast.showToast(msg: 'Contacts permission denied');
  //       return ContactSyncResult(
  //         totalContactsSynced: 0,
  //         friendsFoundOnApp: 0,
  //         usersOnApp: [],
  //       );
  //     }

  //     final List<Contact> contacts = await FlutterContacts.getContacts(
  //       withProperties: true,
  //       withThumbnail: false,
  //     );

  //     final contactsWithPhones = contacts
  //         .where((c) => c.phones.isNotEmpty)
  //         .toList();
  //     developer.log(
  //       'Fetched ${contactsWithPhones.length} contacts with phone numbers',
  //     );

  //     if (contactsWithPhones.isEmpty) {
  //       return ContactSyncResult(
  //         totalContactsSynced: 0,
  //         friendsFoundOnApp: 0,
  //         usersOnApp: [],
  //       );
  //     }

  //     // Securely hash phone numbers (E.164 format) before sending to Firestore
  //     final Set<String> hashedPhones = {};
  //     for (var contact in contactsWithPhones) {
  //       for (var phone in contact.phones) {
  //         final cleaned = phone.number.replaceAll(
  //           RegExp(r'\D'),
  //           '',
  //         ); // Remove non-digits
  //         final e164 = cleaned.startsWith('1')
  //             ? '+$cleaned'
  //             : cleaned.length >= 10
  //             ? '+1$cleaned'
  //             : null;
  //         if (e164 != null && e164.length >= 10) {
  //           final hash = sha256.convert(utf8.encode(e164)).toString();
  //           hashedPhones.add(hash);
  //         }
  //       }
  //     }

  //     if (hashedPhones.isEmpty) {
  //       return ContactSyncResult(
  //         totalContactsSynced: contactsWithPhones.length,
  //         friendsFoundOnApp: 0,
  //         usersOnApp: [],
  //       );
  //     }

  //     // Query Firestore for users with matching hashed phones
  //     final snapshot = await _db
  //         .collection('users')
  //         .where('hashedPhone', whereIn: hashedPhones.toList())
  //         .get();

  //     final List<Map<String, dynamic>> usersOnApp = [];

  //     for (var doc in snapshot.docs) {
  //       final data = doc.data();
  //       usersOnApp.add({
  //         'uid': doc.id,
  //         'name': data['name'] ?? 'Unknown',
  //         'userName': data['userName'] ?? '',
  //         'profilePictureUrl': data['profilePictureUrl'],
  //       });
  //     }

  //     developer.log('Found ${usersOnApp.length} friends already on GlowUp');

  //     return ContactSyncResult(
  //       totalContactsSynced: contactsWithPhones.length,
  //       friendsFoundOnApp: usersOnApp.length,
  //       usersOnApp: usersOnApp,
  //     );
  //   } catch (e) {
  //     developer.log('Contact sync error: $e');
  //     Fluttertoast.showToast(msg: 'Error syncing contacts');
  //     return ContactSyncResult(
  //       totalContactsSynced: 0,
  //       friendsFoundOnApp: 0,
  //       usersOnApp: [],
  //     );
  //   }
  // }

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
        'Fetched ${contactsWithPhones.length} contacts with phones',
      );

      if (contactsWithPhones.isEmpty) {
        return ContactSyncResult(
          totalContactsSynced: 0,
          friendsFoundOnApp: 0,
          usersOnApp: [],
        );
      }

      // Normalize all phone numbers
      final Set<String> normalizedPhones = {};
      for (var contact in contactsWithPhones) {
        for (var phone in contact.phones) {
          developer.log(
            'Raw phone: ${phone.number}, Normalized: ${phone.normalizedNumber}',
          );
          // final normalized = _normalizePhone(phone.number);
          // if (normalized != null) {
          normalizedPhones.add(phone.number);
          // }
        }
      }

      developer.log(
        'Normalized ${normalizedPhones.length} phone numbers for querying',
      );

      if (normalizedPhones.isEmpty) {
        return ContactSyncResult(
          totalContactsSynced: contactsWithPhones.length,
          friendsFoundOnApp: 0,
          usersOnApp: [],
        );
      }

      // Query users where phoneNumber exactly matches any normalized phone
      // Firestore doesn't support whereIn for >10 items → chunk into batches of 10
      final List<List<String>> chunks = [];
      final List<String> phoneList = normalizedPhones.toList();
      for (var i = 0; i < phoneList.length; i += 10) {
        chunks.add(
          phoneList.sublist(
            i,
            i + 10 > phoneList.length ? phoneList.length : i + 10,
          ),
        );
      }

      final List<Map<String, dynamic>> usersOnApp = [];

      for (var chunk in chunks) {
        final snapshot = await _db
            .collection('users')
            .where('phoneNumber', whereIn: chunk)
            .get();

        for (var doc in snapshot.docs) {
          final data = doc.data();
          usersOnApp.add({
            'uid': doc.id,
            'name': data['name'] ?? 'Unknown',
            'userName': data['userName'] ?? '',
            'profilePictureUrl':
                data['profilePictureUrl'] ?? 'https://i.pravatar.cc/150',
          });
        }
      }

      developer.log('Found ${usersOnApp.length} friends on GlowUp');

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

  /// Normalize phone number to E.164 format (e.g., +1234567890)
  String? _normalizePhone(String rawPhone) {
    // Remove all non-digits
    final String cleaned = rawPhone.replaceAll(RegExp(r'\D'), '');

    // Handle US numbers (assume +1 if 10 digits and no country code)
    if (cleaned.length == 10) {
      return '+1$cleaned';
    } else if (cleaned.length == 11 && cleaned.startsWith('1')) {
      return '+$cleaned';
    } else if (cleaned.startsWith('00')) {
      // Replace leading 00 with +
      return '+${cleaned.substring(2)}';
    } else if (!cleaned.startsWith('+')) {
      return null; // Invalid
    }

    return cleaned.startsWith('+') ? cleaned : null;
  }
}
