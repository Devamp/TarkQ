import 'package:flutter/material.dart';

class ReleaseNotes extends StatelessWidget {
  const ReleaseNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Release Notes'),
          titleTextStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
          leading: IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(25),
              border: Border(
                top: BorderSide(color: Colors.grey.withAlpha(75)),
                bottom: BorderSide(color: Colors.grey.withAlpha(75)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                // Header row
                Row(
                  children: [
                    Text(
                      'Release 1.0.0',
                      style: TextStyle(
                        color: Colors.lightGreenAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Text(
                      'July 2025',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12),

                // Account category
                _CategoryHeader(icon: Icons.person_outline, title: 'Account'),
                _BulletPoint(
                  text: 'Account creation, logging in, and deletion.',
                ),

                SizedBox(height: 12),

                // Raid Tickets category
                _CategoryHeader(
                  icon: Icons.confirmation_num_outlined,
                  title: 'Raid Tickets',
                ),
                _BulletPoint(
                  text: 'Ticket creation, viewing, deletion, and filtering',
                ),
                _BulletPoint(text: 'Manage active tickets with ease'),

                SizedBox(height: 12),

                // Achievements category
                _CategoryHeader(
                  icon: Icons.emoji_events_outlined,
                  title: 'Achievements',
                ),
                _BulletPoint(text: 'Achievement creation and viewing'),
                _BulletPoint(text: 'Show achievements on user profiles'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _CategoryHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.lightGreenAccent, size: 20),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;

  const _BulletPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
