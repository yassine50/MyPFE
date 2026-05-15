import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe/features/auth/data/services/auth_service.dart';
import 'package:pfe/core/models/user_model.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: AuthService().getCurrentUserDetails(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        // Check if there is a space in the name, if so just use the first name.
        final firstName = user?.fullName.split(' ').first ?? 'Guest';
        final profileImage = user?.profileImage ?? '';

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome home,',
                  style: GoogleFonts.firaSans(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  firstName,
                  style: GoogleFonts.firaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFFEAD9C9),
              backgroundImage: profileImage.isNotEmpty ? NetworkImage(profileImage) : null,
              child: profileImage.isEmpty ? Icon(Icons.person, color: Colors.grey.shade700) : null,
            ),
          ],
        );
      },
    );
  }
}
