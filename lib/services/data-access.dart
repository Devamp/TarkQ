import 'package:cloud_firestore/cloud_firestore.dart';

class DataAccess {
  DataAccess._privateConstructor();

  static final DataAccess _instance = DataAccess._privateConstructor();

  static DataAccess get instance => _instance;

  Future<void> createUser(String email, String username) async {
    try {
      // add new user to collection
      await FirebaseFirestore.instance.collection('Users').doc(email).set({
        'username': username,
        'email': email,
        'numRaidTickets': 0,
        'dateJoined': FieldValue.serverTimestamp(),
      });
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
          .collection('Users')
          .doc(userEmail)
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getUserRaidTickets(
    String userEmail,
  ) async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection('RaidTickets')
              .where('userEmail', isEqualTo: userEmail)
              .orderBy('timestamp', descending: true)
              .get();

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getDisplayRaidTickets(
    String userEmail, [
    Map<String, String>? filters,
  ]) async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('RaidTickets')
              .where('userEmail', isNotEqualTo: userEmail)
              .orderBy('userEmail') // Required when using isNotEqualTo
              .orderBy('timestamp', descending: true)
              .get();

      List<Map<String, dynamic>> allTickets =
          snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return data;
          }).toList();

      // If no filters, return all tickets
      if (filters == null || filters.isEmpty) {
        return allTickets;
      }

      return allTickets.where((ticket) {
        // Filter by map
        if (filters.containsKey('map') && filters['map'] != 'Any') {
          if (ticket['map'] != filters['map']) return false;
        }

        // Filter by goal
        if (filters.containsKey('goal') && filters['goal'] != 'Any') {
          if (ticket['goal'] != filters['goal']) return false;
        }

        // Filter by party size
        if (filters.containsKey('partySize') && filters['partySize'] != 'Any') {
          if (ticket['maxPartySize']?.toString() != filters['partySize']) {
            return false;
          }
        }

        // Filter by contact method
        if (filters.containsKey('contactMethod') &&
            filters['contactMethod'] != 'Any') {
          if (ticket['contactMethod'] != filters['contactMethod']) return false;
        }

        // Filter by PMC level (minimum)
        if (filters.containsKey('pmcLevel') && filters['pmcLevel'] != 'Any') {
          int ticketLevel =
              int.tryParse(ticket['pmcLevel']?.toString() ?? '0') ?? 0;
          int minLevel = int.tryParse(filters['pmcLevel']!) ?? 0;
          if (ticketLevel < minLevel) return false;
        }

        // Filter by game mode
        if (filters.containsKey('gameMode') && filters['gameMode'] != 'Any') {
          if (ticket['gameMode'] != filters['gameMode']) return false;
        }

        // Filter by skill rating
        if (filters.containsKey('skillRating') &&
            filters['skillRating'] != 'Any') {
          if (ticket['skillRating'] != filters['skillRating']) return false;
        }

        return true;
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createRaidTicket(
    Map<String, dynamic> ticketData,
    String userEmail,
  ) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('RaidTickets').doc();
      final docId = docRef.id;

      await docRef.set({
        ...ticketData,
        'userEmail': userEmail,
        'timestamp': FieldValue.serverTimestamp(),
        'id': docId,
      });

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userEmail)
          .update({'numRaidTickets': FieldValue.increment(1)});
    } catch (e) {
      rethrow;
    }
  }

  Future<DocumentSnapshot<Object?>> getUserData(String? userEmail) async {
    try {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance
              .collection('Users')
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

  Future<void> deleteUserTicket(String userEmail, String ticketDocId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference ticketRef = firestore
        .collection('RaidTickets')
        .doc(ticketDocId);

    try {
      final snapshot = await ticketRef.get();

      if (!snapshot.exists) {
        throw Exception('Ticket not found.');
      }

      final data = snapshot.data() as Map<String, dynamic>;

      // Verify ownership
      if (data['userEmail'] != userEmail) {
        throw Exception('You do not have permission to delete this ticket.');
      }

      // Delete the ticket document
      await ticketRef.delete();

      await firestore.collection('Users').doc(userEmail).update({
        'numRaidTickets': FieldValue.increment(-1),
      });
    } catch (e) {
      print('Error deleting ticket: $e');
      rethrow;
    }
  }

  Future<void> updateUserAchievements(
    String userEmail,
    List<String?> achievements,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userEmail)
          .update({'achievements': achievements});
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> getUserAchievements(String userEmail) async {
    try {
      final docSnapshot =
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(userEmail)
              .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data['achievements'] != null) {
          return List<String>.from(data['achievements']);
        }
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }
}
