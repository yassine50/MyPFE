import 'package:flutter/material.dart';

class CurrentResident extends StatelessWidget {
  const CurrentResident({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
                          padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:    Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color:  Colors.grey.shade200,
                          ),
                        ),
                            child:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Current Residents",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "2 Males, 1 Female • Young Pros",
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            const _AvatarStack(),
                          ],
                        
                      )
                          );
  }
}
class _AvatarStack extends StatelessWidget {
  const _AvatarStack();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _avatar("https://images.unsplash.com/photo-1500648767791-00dcc994a43e"),
       _avatar("https://images.unsplash.com/photo-1494790108377-be9c29b29330"),
      _avatar("https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d"),
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
Widget _avatar(String url) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        image: DecorationImage(
          image: NetworkImage(url),
          fit: BoxFit.cover,
        ),
      ),
    );
  }