import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pfe/features/profile/presentation/profile/profile.dart';

class CurrentResident extends StatelessWidget {
  final String propertyId;

  const CurrentResident({
    super.key,
    required this.propertyId,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
      stream: FirebaseDatabase.instance.ref('bookings').orderByChild('propertyId').equalTo(propertyId).onValue,
      builder: (context, bookingSnap) {
        final List<String> guestIds = [];
        if (bookingSnap.hasData && bookingSnap.data!.snapshot.exists) {
          final data = bookingSnap.data!.snapshot.value as Map;
          data.forEach((_, val) {
            final b = Map<String, dynamic>.from(val as Map);
            final status = b['status']?.toString() ?? '';
            if (status == 'accepted' || status == 'active') {
              final gId = b['guestId']?.toString();
              if (gId != null && !guestIds.contains(gId)) {
                guestIds.add(gId);
              }
            }
          });
        }

        if (guestIds.isEmpty) {
          return const SizedBox.shrink(); // Hide if no residents
        }

        return GestureDetector(
          onTap: () {
            _showResidentsList(context, guestIds);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Current Residents",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${guestIds.length} resident${guestIds.length == 1 ? '' : 's'}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                _AvatarStack(guestIds: guestIds),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showResidentsList(BuildContext context, List<String> guestIds) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                ),
                const SizedBox(height: 16),
                const Text('Current Residents', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ...guestIds.map((uid) {
                  return StreamBuilder<DatabaseEvent>(
                    stream: FirebaseDatabase.instance.ref('users/$uid').onValue,
                    builder: (context, userSnap) {
                      if (!userSnap.hasData || !userSnap.data!.snapshot.exists) return const SizedBox.shrink();
                      final u = Map<String, dynamic>.from(userSnap.data!.snapshot.value as Map);
                      final name = u['fullName'] as String? ?? 'Resident';
                      final img = u['profileImage'] as String? ?? '';
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: img.isNotEmpty ? NetworkImage(img) : null,
                          child: img.isEmpty ? const Icon(Icons.person) : null,
                        ),
                        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => Profile(viewedUserId: uid)),
                          );
                        },
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AvatarStack extends StatelessWidget {
  final List<String> guestIds;

  const _AvatarStack({required this.guestIds});

  @override
  Widget build(BuildContext context) {
    final displayIds = guestIds.take(3).toList();
    
    return Row(
      children: [
        ...displayIds.map((uid) => _avatarFromUid(uid)),
        if (guestIds.length > 3)
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Center(
              child: Text(
                '+${guestIds.length - 3}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          )
        else
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(Icons.chevron_right, size: 20),
          ),
      ],
    );
  }
}

Widget _avatarFromUid(String uid) {
  return StreamBuilder<DatabaseEvent>(
    stream: FirebaseDatabase.instance.ref('users/$uid/profileImage').onValue,
    builder: (context, snap) {
      final imgUrl = (snap.hasData && snap.data!.snapshot.exists) 
          ? snap.data!.snapshot.value as String 
          : '';
      return Align(
        widthFactor: 0.7,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            image: imgUrl.isNotEmpty
                ? DecorationImage(image: NetworkImage(imgUrl), fit: BoxFit.cover)
                : null,
          ),
          child: imgUrl.isEmpty ? const Icon(Icons.person, size: 20, color: Colors.white) : null,
        ),
      );
    },
  );
}
