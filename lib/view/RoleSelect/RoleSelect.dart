import 'package:flutter/material.dart';
import 'package:pfe/component/GoogleNavBar/Navbar.dart';

class RoleSelect extends StatelessWidget {
  const RoleSelect({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // ✅ FIX OVERFLOW
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔙 Back + Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const BackButton(),
                    TextButton(onPressed: () {}, child: const Text("Log in")),
                  ],
                ),

                const SizedBox(height: 20),

                // 📝 Title
                const Text(
                  "How will you use the app?",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                const Text(
                  "To get started, tell us what brings you here today.",
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 20),

                // 🏠 RENTER CARD
                _RoleCard(
                  image: "assets/images/renter.jpg",
                  tag: "Popular",
                  title: "I'm a Renter",
                  description:
                      "Browse apartments, co-living spaces, and homes in Romania. Find your next stay effortlessly.",
                  buttonText: "Find a place",
                  filled: true,
                ),

                const SizedBox(height: 20),

                // 🏡 HOST CARD
                _RoleCard(
                  image: "assets/images/host.jpg",
                  title: "I'm a Host",
                  description:
                      "Earn money by renting out your space to travelers. Simple listing process and secure payments.",
                  buttonText: "List my property",
                  filled: false,
                ),

                const SizedBox(height: 30),

                // 📄 Terms
                const Center(
                  child: Text(
                    "By continuing, you agree to our Terms of Service and Privacy Policy.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String image;
  final String? tag;
  final String title;
  final String description;
  final String buttonText;
  final bool filled;

  const _RoleCard({
    required this.image,
    this.tag,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.filled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🖼 Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                Image.asset(
                  image,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                if (tag != null)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(tag!, style: const TextStyle(fontSize: 12)),
                    ),
                  ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(description, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: filled ? Colors.blue : Colors.white,
                      foregroundColor: filled ? Colors.white : Colors.blue,
                      side: filled
                          ? null
                          : const BorderSide(color: Colors.blue),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => const GoogleNavBar(renter: true,),
                        ),
                      );
                    },
                    child: Text(buttonText),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
