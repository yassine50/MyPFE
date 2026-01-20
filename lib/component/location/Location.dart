import 'package:flutter/material.dart';

class Location extends StatelessWidget {
  const Location({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      const Text(
                          "Location",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuBeCMC87Tsokwz7hKE5XyZfMhNyArZDHr0qYa6cV0jQmYQ5r6i3Gf1iBbcbELG3Jepl0EbbZu2fSDBrRyObrr0yFNfBwLx3iVECITsAikIi0wGFirCp_G5kR34OBDI-2Kr3pa2un9p3t9TRfp1qcfXmH7FknSogxe34I4Tugz97jbIsuqbRkayYRlbeOJMWROT5-a2T_M7xDBa-3Vp4XwwCqOx4S-EjIB-kQT00z5uoIMJ2xFvfzr5rlMUuOtgP24VcqFm6xXQ8AvI',
                                height: 190,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),

                            // Fake map pin
                            Positioned(
                              top: 80,
                              left: MediaQuery.of(context).size.width / 2 - 40,
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.9),
                                      shape: BoxShape.circle,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.home,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ),
                                  Container(
                                    width: 8,
                                    height: 8,
                                    transform: Matrix4.rotationZ(0.785),
                                    color: Colors.blue,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
    ],);
  }
}