import re

with open('lib/features/host/presentation/host/my_listing/my_listing.dart', 'r') as f:
    content = f.read()

# 1. Add import for DetailScreen
if "import 'package:pfe/features/property_details/presentation/detail_screen/detail_screen.dart';" not in content:
    content = content.replace("import 'package:pfe/core/models/property_model.dart';", "import 'package:pfe/core/models/property_model.dart';\nimport 'package:pfe/features/property_details/presentation/detail_screen/detail_screen.dart';")

# 2. Update stats variables calculation in StreamBuilder
# Currently: count: properties.length.toString()
# Replace with:
# int activeCount = properties.where((p) => p.isActive).length;
# int hiddenCount = properties.length - activeCount;

# 3. Modify _buildListingCard calls in StreamBuilder
# status: prop.isActive ? AppStrings.active : AppStrings.hidden,
# isActive: prop.isActive,

build_stream = """                List<PropertyModel> properties = [];
                if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                  final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                  data.forEach((key, value) {
                    properties.add(PropertyModel.fromJson(value as Map<dynamic, dynamic>, key.toString()));
                  });
                }
                
                int activeCount = properties.where((p) => p.isActive).length;
                int hiddenCount = properties.length - activeCount;

                return Column(
                  children: [
                    // Stats Cards
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          _buildStatCard(
                            count: activeCount.toString(),
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
                            count: hiddenCount.toString(),
                            label: AppStrings.hidden,
                            isActive: false,
                            c: c,
                          ),
                        ],
                      ),
                    ),"""
content = re.sub(r'                List<PropertyModel> properties = \[\];.*?                return Column\(\n                  children: \[\n                    // Stats Cards.*?                    \),', build_stream, content, flags=re.DOTALL)


content = content.replace("status: AppStrings.active,", "status: prop.isActive ? AppStrings.active : AppStrings.hidden,")
content = content.replace("isActive: true,", "isActive: prop.isActive,")


# 4. Update the buttons in _buildListingCard
switch_replace = """                          Switch(
                            value: isActive,
                            onChanged: (val) {
                              FirebaseDatabase.instance.ref('properties/${property.id}/isActive').set(val);
                            },
                            activeThumbColor: const Color(0xFF136DEC),
                            activeTrackColor: const Color(
                              0xFF136DEC,
                            ).withValues(alpha: 0.5),
                          ),"""
content = re.sub(r'                          Switch\(.*?                           \),', switch_replace, content, flags=re.DOTALL)

edit_replace = """              Expanded(
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ManageListingScreen(property: property),
                      ),
                    );
                  },"""
content = re.sub(r'              Expanded\(\n                child: TextButton\.icon\(\n                  onPressed: \(\) \{\},.*?label: Text\(\n                    AppStrings\.editListing,', edit_replace + '\n                    label: Text(\n                    AppStrings.editListing,', content, flags=re.DOTALL)

stats_replace = """              Expanded(
                child: TextButton.icon(
                  onPressed: () {
                    if (isActive) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Stats coming soon!')));
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(property: property)));
                    }
                  },"""
content = re.sub(r'              Expanded\(\n                child: TextButton\.icon\(\n                  onPressed: \(\) \{\},.*?label: Text\(\n                    isActive \? AppStrings\.stats : AppStrings\.preview,', stats_replace + '\n                    label: Text(\n                    isActive ? AppStrings.stats : AppStrings.preview,', content, flags=re.DOTALL)


with open('lib/features/host/presentation/host/my_listing/my_listing.dart', 'w') as f:
    f.write(content)
