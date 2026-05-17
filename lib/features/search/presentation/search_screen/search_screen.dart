import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe/core/theme/app_theme.dart';
import 'package:pfe/core/widgets/list_card_home/list_card_home.dart';
import 'package:pfe/core/models/property_model.dart';
import 'package:pfe/features/home/presentation/map/map_screen.dart';
import 'package:pfe/features/home/data/repositories/property_repository.dart';

class SearchScreen extends StatefulWidget {
  final List<PropertyModel>? properties;
  const SearchScreen({super.key, this.properties});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';
  int _filterIndex = 0; // 0=All, 1=Co-Living, 2=Studio, 3=Featured

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<PropertyModel> _filter(List<PropertyModel> props) {
    var filtered = props;

    // Text search
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      filtered = filtered.where((p) =>
        p.title.toLowerCase().contains(q) ||
        p.subtitle.toLowerCase().contains(q) ||
        p.description.toLowerCase().contains(q) ||
        p.roomType.toLowerCase().contains(q)
      ).toList();
    }

    // Category filter
    switch (_filterIndex) {
      case 1:
        filtered = filtered.where((p) => p.isColiving).toList();
        break;
      case 2:
        filtered = filtered.where((p) => p.roomType.toLowerCase().contains('studio')).toList();
        break;
      case 3:
        filtered = filtered.where((p) => p.isFeatured).toList();
        break;
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    if (widget.properties != null) {
      return _buildScaffold(c, widget.properties!);
    }

    return StreamBuilder<List<PropertyModel>>(
      stream: PropertyRepository().propertiesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: c.background,
            body: Center(child: CircularProgressIndicator(color: c.primary)),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: c.background,
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        return _buildScaffold(c, snapshot.data ?? []);
      },
    );
  }

  Widget _buildScaffold(AppColorScheme c, List<PropertyModel> allProps) {
    final props = _filter(allProps);
    final filters = ['All', 'Co-Living', 'Studio', 'Featured'];

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              color: c.card,
              child: Column(
                children: [
                  // Search bar
                  Container(
                    decoration: BoxDecoration(
                      color: c.hover,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: c.border),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 14),
                          child: Icon(Icons.search, color: c.textSecondary, size: 22),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _searchCtrl,
                            onChanged: (v) => setState(() => _query = v),
                            decoration: InputDecoration(
                              hintText: 'Search by city, title, type...',
                              hintStyle: TextStyle(color: c.textSecondary, fontSize: 14),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            ),
                            style: GoogleFonts.plusJakartaSans(fontSize: 14, color: c.textMain),
                          ),
                        ),
                        if (_query.isNotEmpty)
                          IconButton(
                            icon: Icon(Icons.clear, color: c.textSecondary, size: 20),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _query = '');
                            },
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Filter chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(filters.length, (i) {
                        final selected = _filterIndex == i;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8, bottom: 12),
                          child: GestureDetector(
                            onTap: () => setState(() => _filterIndex = i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: selected ? c.primary : c.hover,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: selected ? c.primary : c.border),
                              ),
                              child: Text(
                                filters[i],
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: selected ? Colors.white : c.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),

            // Results count
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text(
                '${props.length} listing${props.length != 1 ? 's' : ''} found',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: c.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // List
            Expanded(
              child: props.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search_off, size: 64, color: c.textSecondary.withValues(alpha: 0.4)),
                          const SizedBox(height: 12),
                          Text('No listings match your search',
                            style: GoogleFonts.plusJakartaSans(fontSize: 15, color: c.textSecondary)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      itemCount: props.length,
                      itemBuilder: (context, index) => ListCardHome(property: props[index]),
                    ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: c.card,
        foregroundColor: c.primary,
        elevation: 4,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => MapScreen(properties: _filter(allProps))),
          );
        },
        icon: const Icon(Icons.map_outlined),
        label: Text('Map', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
      ),
    );
  }
}
