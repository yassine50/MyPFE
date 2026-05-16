import re

with open('lib/features/host/presentation/host/my_listing/my_listing.dart', 'r') as f:
    content = f.read()

imports = """import 'package:flutter/material.dart';
import 'package:pfe/core/localization/app_strings.dart';
import 'package:pfe/core/theme/app_theme.dart';
import 'package:pfe/core/models/property_model.dart';
import 'package:pfe/features/host/presentation/host/add_listing/manage_listing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
"""

content = re.sub(r"import 'package:flutter/material.dart';.*?import 'package:pfe/features/host/presentation/host/add_listing/manage_listing.dart';", imports, content, flags=re.DOTALL)

# Convert MyListing to StatefulWidget
stateful_widget = """class MyListing extends StatefulWidget {
  const MyListing({super.key});

  @override
  State<MyListing> createState() => _MyListingState();
}

class _MyListingState extends State<MyListing> {
"""

content = re.sub(r"class MyListing extends StatelessWidget \{\n  const MyListing\(\{super.key\}\);\n", stateful_widget, content, flags=re.DOTALL)


build_start = """  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return Scaffold(
        backgroundColor: c.background,
        body: Center(child: Text('Please log in')),
      );
    }
"""
content = re.sub(r"  @override\n  Widget build\(BuildContext context\) \{\n    final c = context.appColors;\n", build_start, content, flags=re.DOTALL)


# Replace stats cards and listview with StreamBuilder
stream_builder = """          Expanded(
            child: StreamBuilder<DatabaseEvent>(
              stream: FirebaseDatabase.instance
                  .ref('properties')
                  .orderByChild('hostId')
                  .equalTo(currentUser.uid)
                  .onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<PropertyModel> properties = [];
                if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                  final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                  data.forEach((key, value) {
                    properties.add(PropertyModel.fromJson(value as Map<dynamic, dynamic>, key.toString()));
                  });
                }

                return Column(
                  children: [
                    // Stats Cards
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          _buildStatCard(
                            count: properties.length.toString(),
                            label: AppStrings.active,
                            isActive: true,
                            c: c,
                          ),
                          const SizedBox(width: 12),
                          _buildStatCard(
                            c: c,
                            count: '0',
                            label: AppStrings.drafts,
                            isActive: false,
                          ),
                          const SizedBox(width: 12),
                          _buildStatCard(
                            count: '0',
                            label: AppStrings.hidden,
                            isActive: false,
                            c: c,
                          ),
                        ],
                      ),
                    ),

                    // Filter Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppStrings.allProperties,
                            style: TextStyle(
                              fontSize: 14,
                              color: const Color(0xFF6B7280),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.tune, size: 16),
                            label: Text(
                              AppStrings.filter,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF136DEC),
                              ),
                            ),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Listings
                    Expanded(
                      child: properties.isEmpty
                          ? Center(
                              child: Text(
                                'No listings found.',
                                style: TextStyle(color: c.textSecondary),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              itemCount: properties.length,
                              itemBuilder: (context, index) {
                                final prop = properties[index];
                                final imageUrl = prop.images.isNotEmpty ? prop.images.first : 'https://placehold.co/400x400/png';
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: _buildListingCard(
                                    context: context,
                                    property: prop,
                                    imageUrl: imageUrl,
                                    title: prop.title,
                                    location: prop.subtitle,
                                    price: prop.price,
                                    status: AppStrings.active,
                                    isActive: true,
                                    c: c,
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
"""

# We need to replace from `// Stats Cards` all the way down to `],` right before `),` of `Column`.
content = re.sub(r"          // Stats Cards.*?Expanded\(\n            child: ListView\(.*?\),\n          \),\n", stream_builder, content, flags=re.DOTALL)


# Update _buildListingCard to take PropertyModel
build_card = """  Widget _buildListingCard({
    required BuildContext context,
    required PropertyModel property,
    required String imageUrl,
    required String title,
    required String location,
    required String price,
    required String status,
    required bool isActive,
    required AppColorScheme c,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ManageListingScreen(property: property),
          ),
        );
      },"""
content = re.sub(r"  Widget _buildListingCard\(\{.*?child: Container\(", build_card + "\n      child: Container(", content, flags=re.DOTALL)


with open('lib/features/host/presentation/host/my_listing/my_listing.dart', 'w') as f:
    f.write(content)
