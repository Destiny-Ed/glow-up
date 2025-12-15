import 'dart:developer' as developer;
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppContactService {
  /// Requests permission and returns list of contacts if granted.
  /// Returns empty list if denied or error.
  Future<List<Contact>> requestAndGetContacts() async {
    try {
      // This handles permission request + dialog automatically
      final bool granted = await FlutterContacts.requestPermission(
        readonly: true,
      );

      if (!granted) {
        Fluttertoast.showToast(msg: 'Contacts permission denied');
        return [];
      }

      // Fetch contacts efficiently (no thumbnails = faster for large lists)
      final List<Contact> contacts = await FlutterContacts.getContacts(
        withProperties: true, // Gets phones, emails, names
        withThumbnail: false, // Set true if you want avatars later (slower)
      );

      developer.log('Successfully fetched ${contacts.length} contacts');
      // for (var i in contacts) {
      //   developer.log("contacts :: ${i.toJson()}");
      // }

      // Optional: Filter or process (e.g., only with phone numbers)
      // final filtered = contacts.where((c) => c.phones.isNotEmpty).toList();

      return contacts;
    } catch (e) {
      developer.log('Error fetching contacts: $e');
      Fluttertoast.showToast(msg: 'Error accessing contacts');
      return [];
    }
  }
}
