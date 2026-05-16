import re

with open('lib/features/booking/presentation/mybooking_rent/my_booking_renter.dart', 'r') as f:
    content = f.read()

# Imports
if "import 'package:firebase_auth/firebase_auth.dart';" not in content:
    imports = """import 'package:flutter/material.dart';
import 'package:pfe/core/localization/app_strings.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe/core/theme/app_theme.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pfe/features/home/data/repositories/property_repository.dart';
import 'package:pfe/core/models/property_model.dart';
import 'package:intl/intl.dart';
"""
    content = re.sub(r"import 'package:flutter/material.dart';.*?import 'package:pfe/core/theme/app_theme.dart';", imports, content, flags=re.DOTALL)

# State
state_replace = """class _MyBookingsPageState extends State<MyBookingRenter> {
  int _selectedSegmentIndex = 0;
  final _database = FirebaseDatabase.instance;
  Map<String, PropertyModel> _properties = {};
  bool _isLoadingProperties = true;

  @override
  void initState() {
    super.initState();
    _fetchProperties();
  }

  Future<void> _fetchProperties() async {
    try {
      final properties = await PropertyRepository().fetchProperties();
      for (var p in properties) {
        _properties[p.id] = p;
      }
    } catch (e) {
      debugPrint('Failed to fetch properties: $e');
    }
    if (mounted) {
      setState(() {
        _isLoadingProperties = false;
      });
    }
  }
"""

content = re.sub(r"class _MyBookingsPageState extends State<MyBookingRenter> \{.*?  \];\n", state_replace, content, flags=re.DOTALL)

# Expanded Bookings List
expanded_list = """            // Bookings List
            Expanded(
              child: _isLoadingProperties
                  ? const Center(child: CircularProgressIndicator())
                  : StreamBuilder<DatabaseEvent>(
                      stream: _database.ref('bookings').orderByChild('guestId').equalTo(FirebaseAuth.instance.currentUser?.uid).onValue,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }
                        if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                          return Center(
                            child: Text(
                              'No bookings found.',
                              style: TextStyle(color: c.textSecondary, fontSize: 16),
                            ),
                          );
                        }

                        final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                        final List<Map<String, dynamic>> fetchedBookings = data.entries.map((e) {
                          final val = e.value as Map<dynamic, dynamic>;
                          return {
                            'id': e.key.toString(),
                            ...val,
                          };
                        }).toList();

                        // Filter based on segment index
                        // 0 = upcoming (pending/accepted), 1 = past (completed), 2 = cancelled (rejected/cancelled)
                        final filteredBookings = fetchedBookings.where((b) {
                          final status = b['status']?.toString() ?? 'pending';
                          if (_selectedSegmentIndex == 0) return status == 'pending' || status == 'accepted';
                          if (_selectedSegmentIndex == 1) return status == 'completed';
                          if (_selectedSegmentIndex == 2) return status == 'rejected' || status == 'cancelled';
                          return false;
                        }).toList();
                        
                        // Sort by createdAt descending
                        filteredBookings.sort((a, b) {
                          final aTime = (a['createdAt'] ?? 0) as int;
                          final bTime = (b['createdAt'] ?? 0) as int;
                          return bTime.compareTo(aTime);
                        });

                        if (filteredBookings.isEmpty) {
                          return Center(
                            child: Text(
                              'No items in this category.',
                              style: TextStyle(color: c.textSecondary, fontSize: 16),
                            ),
                          );
                        }

                        return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                          child: Column(
                            children: filteredBookings.map((b) {
                              final propertyId = b['propertyId']?.toString() ?? '';
                              final property = _properties[propertyId];
                              
                              final moveInStr = b['moveInDate']?.toString() ?? '';
                              final moveOutStr = b['moveOutDate']?.toString() ?? '';
                              
                              DateTime? moveIn;
                              DateTime? moveOut;
                              try { moveIn = DateTime.parse(moveInStr); } catch (_) {}
                              try { moveOut = DateTime.parse(moveOutStr); } catch (_) {}
                              
                              final dateRange = moveIn != null && moveOut != null
                                  ? '${DateFormat('MMM d').format(moveIn)} - ${DateFormat('MMM d').format(moveOut)}'
                                  : 'Unknown dates';

                              final title = property?.title ?? 'Unknown Property';
                              final location = property?.subtitle ?? 'Unknown Location';
                              final image = property?.images.isNotEmpty == true
                                  ? property!.images.first
                                  : 'https://placehold.co/400x400/png';

                              final status = b['status']?.toString() ?? 'pending';
                              String statusText = status.toUpperCase();
                              Color statusColor = Colors.grey;
                              IconData statusIcon = Icons.info;
                              String primaryAction = 'details';
                              String primaryText = AppStrings.btnViewDetails;

                              if (status == 'pending') {
                                statusColor = Colors.amber;
                                statusIcon = Icons.hourglass_top;
                                statusText = 'PENDING';
                              } else if (status == 'accepted') {
                                statusColor = Colors.green;
                                statusIcon = Icons.check_circle;
                                statusText = 'CONFIRMED';
                                primaryAction = 'message';
                                primaryText = AppStrings.btnMessageHost;
                              } else if (status == 'rejected' || status == 'cancelled') {
                                statusColor = Colors.red;
                                statusIcon = Icons.cancel;
                              } else if (status == 'completed') {
                                statusColor = Colors.blue;
                                statusIcon = Icons.bookmark;
                              }

                              final uiBooking = {
                                'id': b['id'],
                                'title': title,
                                'location': location,
                                'dates': dateRange,
                                'status': status,
                                'statusText': statusText,
                                'statusColor': statusColor,
                                'statusIcon': statusIcon,
                                'image': image,
                                'primaryButtonText': primaryText,
                                'primaryButtonAction': primaryAction,
                                'secondaryButtonIcon': Icons.map,
                                'secondaryButtonAction': 'map',
                                'property': property,
                                'rawBooking': b,
                              };
                              return _buildBookingCard(uiBooking, c);
                            }).toList(),
                          ),
                        );
                      },
                    ),
            ),"""

content = re.sub(r"            // Bookings List.*?            \),\n", expanded_list + "\n", content, flags=re.DOTALL)

with open('lib/features/booking/presentation/mybooking_rent/my_booking_renter.dart', 'w') as f:
    f.write(content)
