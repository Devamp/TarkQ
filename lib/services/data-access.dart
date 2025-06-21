import 'package:cloud_firestore/cloud_firestore.dart';

class DataAccess {
  DataAccess._privateConstructor();

  static final DataAccess _instance = DataAccess._privateConstructor();

  static DataAccess get instance => _instance;

  Future<void> createUser(String email, String username) async {
    try {
      // add new user to collection
      await FirebaseFirestore.instance.collection('User').doc(email).set({
        'username': username,
        'email': email,
        'dateJoined': FieldValue.serverTimestamp(),
      });

      // set up user's raid ticket collection
      await FirebaseFirestore.instance.collection('RaidTickets').doc(email).set(
        {'tickets': []},
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> delete(String userEmail) async {
    try {
      await FirebaseFirestore.instance
          .collection('RaidTickets')
          .doc(userEmail)
          .delete();
      await FirebaseFirestore.instance
          .collection('User')
          .doc(userEmail)
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchUserRaidTickets(
    String userEmail,
  ) async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('RaidTickets').get();

      // Filter out the document with ID == userEmail
      final otherDocs =
          snapshot.docs.where((doc) => doc.id == userEmail).toList();

      List<Map<String, dynamic>> returnList = [];

      for (var item in otherDocs) {
        returnList.add(item.data() as Map<String, dynamic>);
      }

      return returnList;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchRaidTickets(
    String userEmail,
    int startIdx,
    int limit,
  ) async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('RaidTickets').get();

      // Filter out the document with ID == userEmail
      final otherDocs =
          snapshot.docs.where((doc) => doc.id != userEmail).toList();

      List<Map<String, dynamic>> returnList = [];

      if (otherDocs.length > startIdx) {
        final paginatedDocs = otherDocs.skip(startIdx).take(limit).toList();

        for (var item in paginatedDocs) {
          returnList.add(item.data() as Map<String, dynamic>);
        }
      } else {
        for (var item in otherDocs) {
          returnList.add(item.data() as Map<String, dynamic>);
        }
      }

      return returnList;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createRaidTicket(
    Map<String, dynamic> ticketData,
    String userEmail,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('RaidTickets')
          .doc(userEmail)
          .update({
            'tickets': FieldValue.arrayUnion([ticketData]),
          });
    } catch (e) {
      rethrow;
    }
  }

  Future<DocumentSnapshot<Object?>> getUserData(String? userEmail) async {
    try {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance
              .collection('User')
              .doc(userEmail)
              .get();

      if (doc.exists) {
        return doc;
      } else {
        throw Exception('Could not load user data on login.');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> deleteUserTicket(
    String userEmail,
    int ticketId,
  ) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference raidTicketRef = firestore
        .collection('RaidTickets')
        .doc(userEmail);

    try {
      // Get current ticket array
      final snapshot = await raidTicketRef.get();
      final data = snapshot.data() as Map<String, dynamic>;
      final List<dynamic> tickets = data['tickets'] ?? [];

      if (ticketId < 0 || ticketId >= tickets.length) {
        throw Exception('Invalid ticket index.');
      }

      // Remove the ticket at index
      tickets.removeAt(ticketId);

      // Update the document
      await raidTicketRef.update({'tickets': tickets});

      // Return updated list casted properly
      return List<Map<String, dynamic>>.from(tickets);
    } catch (e) {
      print('Error deleting ticket: $e');
      rethrow;
    }
  }

  Future<void> deleteOldRaidTickets(String userEmail) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference raidTicketRef = firestore
        .collection('RaidTickets')
        .doc(userEmail);

    try {
      final snapshot = await raidTicketRef.get();
      final data = snapshot.data() as Map<String, dynamic>;
      final List<dynamic> tickets = data['tickets'] ?? [];

      final now = DateTime.now();
      final List<Map<String, dynamic>> filteredTickets = [];

      for (var ticket in tickets) {
        final createdAt = ticket['createdAt'];
        if (createdAt is Timestamp) {
          final ticketTime = createdAt.toDate();
          final difference = now.difference(ticketTime);
          if (difference.inHours <= 24) {
            filteredTickets.add(Map<String, dynamic>.from(ticket));
          }
        } else {
          filteredTickets.add(Map<String, dynamic>.from(ticket));
        }
      }

      await raidTicketRef.update({'tickets': filteredTickets});
    } catch (e) {
      print('Error deleting old tickets: $e');
      rethrow;
    }
  }
}
