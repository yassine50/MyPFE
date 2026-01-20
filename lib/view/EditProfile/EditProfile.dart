import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EditProfil extends StatefulWidget {
  const EditProfil({super.key});

  @override
  State<EditProfil> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfil> {
  final TextEditingController _nameController = TextEditingController(text: 'Alex Johnson');
  final TextEditingController _bioController = TextEditingController(
    text: 'I am a digital nomad looking for a cozy place to stay for a few months while I explore Romania. I love coffee, hiking, and meeting new people!',
  );
  
  String _nationality = 'us';
  String _preferredLanguage = 'en';
  RangeValues _budgetRange = const RangeValues(300, 800);
  DateTime _moveInDate = DateTime.now(); // Changed to current date
  double _screenWidth = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _screenWidth = MediaQuery.of(context).size.width;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      _isLoading = false;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Profile updated successfully!'),
        backgroundColor: _getColors(false)['primary'],
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    // Optional: Close the page after save
    // Navigator.pop(context);
  }

  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = _moveInDate.isBefore(now) ? now : _moveInDate;
    
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: DateTime(now.year + 1, now.month, now.day),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _getColors(false)['primary']!,
              onPrimary: Colors.white,
              onSurface: _getColors(false)['textMain']!,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: _getColors(false)['primary'],
              ),
            ),
            dialogBackgroundColor: _getColors(false)['card'],
          ),
          child: child!,
        );
      },
    );
    
    if (pickedDate != null && pickedDate != _moveInDate) {
      setState(() {
        _moveInDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colors = _getColors(isDarkMode);
    
    if (_screenWidth == 0) {
      _screenWidth = MediaQuery.of(context).size.width;
    }

    return Scaffold(
      backgroundColor: colors['background'],
      body: SafeArea(
        top: true,
        bottom: false,
        child: Stack(
          children: [
            // Main Content
            Column(
              children: [
                // Navigation Header
                _buildNavigationHeader(colors),
                
                // Scrollable Form Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Column(
                      children: [
                        // Profile Photo Section
                        _buildProfilePhotoSection(colors),
                        
                        // Divider
                        Container(
                          height: 8,
                          color: colors['divider'],
                        ),
                        
                        // Personal Details Section
                        _buildPersonalDetailsSection(colors),
                        
                        // Divider
                        Container(
                          height: 8,
                          color: colors['divider'],
                          margin: const EdgeInsets.only(top: 32),
                        ),
                        
                        // Rental Preferences Section
                        _buildRentalPreferencesSection(colors),
                        
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            // Sticky Bottom Button
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                top: false,
                child: _buildBottomButton(colors),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Navigation Header
  Widget _buildNavigationHeader(Map<String, Color> colors) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: colors['card'],
        border: Border(
          bottom: BorderSide(
            color: colors['border']!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Close Button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: colors['card'],
              ),
              child: Icon(
                Icons.close,
                size: 24,
                color: colors['textMain'],
              ),
            ),
          ),
          
          // Title
          Expanded(
            child: Center(
              child: Text(
                'Edit Profile',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colors['textMain'],
                  height: 1.2,
                  letterSpacing: -0.015,
                ),
              ),
            ),
          ),
          
          // Save Button (Text)
          GestureDetector(
            onTap: _saveChanges,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Save',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colors['primary'],
                  letterSpacing: 0.015,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Profile Photo Section
  Widget _buildProfilePhotoSection(Map<String, Color> colors) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          GestureDetector(
            onTap: _changeProfilePhoto,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                // Profile Image
                Container(
                  width: 128,
                  height: 128,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(64),
                    border: Border.all(
                      color: colors['card']!,
                      width: 4,
                    ),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuAnKNjcoxZg5XKv1PrCvk3NlXQM16SvYZ4Y-XyXNNUUvo0LWlGmfOaCk0MX6jxW27bcdYlbTUw2hXZkl9xJirZcyLlkAOV9JvcwhVQDp1PZph1PcGBkqre_bH5y_6naz4_cQmsNQfTGy9Kv_cu8uoP61Jp-AsIGejFOuswWbH1_fnU2MR-9aAXsYi5i4J9o8hhEYTSOy9oTCx3_E_Bapm5c2z6mvYbU1WUpUnDJEZnPItqc-ddLTkakXHrhSjyqcvNruDKzKEA-WzI',
                      ),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                
                // Camera Icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colors['primary'],
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: colors['card']!,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.photo_camera,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Change Photo Text
          GestureDetector(
            onTap: _changeProfilePhoto,
            child: Text(
              'Change Photo',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors['primary'],
                height: 1.2,
                letterSpacing: -0.015,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Personal Details Section
  Widget _buildPersonalDetailsSection(Map<String, Color> colors) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'Personal Details',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colors['textMain'],
              height: 1.2,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Form Fields
          Column(
            children: [
              // Full Name
              _buildTextField(
                label: 'Full Name',
                controller: _nameController,
                hintText: 'e.g. John Doe',
                colors: colors,
              ),
              
              const SizedBox(height: 20),
              
              // Nationality Dropdown
              _buildDropdownField(
                label: 'Nationality',
                value: _nationality,
                items: const [
                  DropdownMenuItem(
                    value: 'us',
                    child: Row(
                      children: [
                        Text('🇺🇸'),
                        SizedBox(width: 12),
                        Text('American'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'ro',
                    child: Row(
                      children: [
                        Text('🇷🇴'),
                        SizedBox(width: 12),
                        Text('Romanian'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'uk',
                    child: Row(
                      children: [
                        Text('🇬🇧'),
                        SizedBox(width: 12),
                        Text('British'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'fr',
                    child: Row(
                      children: [
                        Text('🇫🇷'),
                        SizedBox(width: 12),
                        Text('French'),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _nationality = value;
                    });
                  }
                },
                colors: colors,
              ),
              
              const SizedBox(height: 20),
              
              // Bio Text Field
              _buildTextField(
                label: 'Bio',
                controller: _bioController,
                hintText: 'Tell hosts a bit about yourself...',
                maxLines: 4,
                colors: colors,
              ),
              
              const SizedBox(height: 20),
              
              // Preferred Language Dropdown
              _buildDropdownField(
                label: 'Preferred Language',
                value: _preferredLanguage,
                items: const [
                  DropdownMenuItem(
                    value: 'en',
                    child: Text('English'),
                  ),
                  DropdownMenuItem(
                    value: 'ro',
                    child: Text('Romanian'),
                  ),
                  DropdownMenuItem(
                    value: 'es',
                    child: Text('Spanish'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _preferredLanguage = value;
                    });
                  }
                },
                colors: colors,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Rental Preferences Section
  Widget _buildRentalPreferencesSection(Map<String, Color> colors) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'Rental Preferences',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colors['textMain'],
              height: 1.2,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Budget Range Slider
          _buildBudgetSlider(colors),
          
          const SizedBox(height: 24),
          
          // Move-in Date Picker
          _buildDatePicker(colors),
        ],
      ),
    );
  }

  // Budget Slider
  Widget _buildBudgetSlider(Map<String, Color> colors) {
    final minBudget = 100.0;
    final maxBudget = 2000.0;
    final leftPosition = ((_budgetRange.start - minBudget) / (maxBudget - minBudget)) * (_screenWidth - 32);
    final rightPosition = ((_budgetRange.end - minBudget) / (maxBudget - minBudget)) * (_screenWidth - 32);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label and Value
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Monthly Budget',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colors['textLabel'],
              ),
            ),
            Text(
              '€${_budgetRange.start.round()} - €${_budgetRange.end.round()}',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors['primary'],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Custom Slider
        SizedBox(
          height: 40,
          child: Stack(
            children: [
              // Track Background
              Center(
                child: Container(
                  height: 4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colors['sliderTrack'],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              // Active Range Background
              Positioned(
                left: 0,
                right: 0,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors['primary']!.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              // Active Range
              Positioned(
                left: leftPosition.clamp(0, _screenWidth - 32),
                right: (_screenWidth - 32) - rightPosition.clamp(0, _screenWidth - 32),
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors['primary'],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              // Left Thumb
              Positioned(
                left: leftPosition.clamp(14, _screenWidth - 46) - 14,
                top: 8,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      final newValue = _budgetRange.start + (details.delta.dx / (_screenWidth - 32)) * (maxBudget - minBudget);
                      if (newValue >= minBudget && newValue <= _budgetRange.end - 100) {
                        _budgetRange = RangeValues(newValue, _budgetRange.end);
                      }
                    });
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: colors['card'],
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: colors['primary']!,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: colors['primary'],
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              // Right Thumb
              Positioned(
                left: rightPosition.clamp(14, _screenWidth - 46) - 14,
                top: 8,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      final newValue = _budgetRange.end + (details.delta.dx / (_screenWidth - 32)) * (maxBudget - minBudget);
                      if (newValue <= maxBudget && newValue >= _budgetRange.start + 100) {
                        _budgetRange = RangeValues(_budgetRange.start, newValue);
                      }
                    });
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: colors['card'],
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: colors['primary']!,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: colors['primary'],
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Min/Max Labels
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '€${minBudget.round()}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: colors['textSecondary'],
                ),
              ),
              Text(
                '€${maxBudget.round()}+',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: colors['textSecondary'],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Date Picker
  Widget _buildDatePicker(Map<String, Color> colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Desired Move-in Date',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colors['textLabel'],
          ),
        ),
        
        const SizedBox(height: 8),
        
        GestureDetector(
          onTap: _pickDate,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: colors['inputBackground'],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colors['inputBorder']!,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    DateFormat('yyyy-MM-dd').format(_moveInDate),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: colors['textMain'],
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  color: colors['textSecondary'],
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Sticky Bottom Button
  Widget _buildBottomButton(Map<String, Color> colors) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors['card']!.withOpacity(0.95),
        border: Border(
          top: BorderSide(
            color: colors['border']!,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: _isLoading
          ? Container(
              height: 56,
              decoration: BoxDecoration(
                color: colors['primary'],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            )
          : ElevatedButton(
              onPressed: _saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors['primary'],
                foregroundColor: Colors.white,
                elevation: 8,
                shadowColor: colors['primary']!.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 56),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    'Save Changes',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // Helper: Text Field
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required Map<String, Color> colors,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colors['textLabel'],
          ),
        ),
        
        const SizedBox(height: 8),
        
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colors['inputBorder']!,
            ),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            minLines: maxLines,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: colors['textHint'],
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: colors['textMain'],
            ),
            cursorColor: colors['primary'],
          ),
        ),
      ],
    );
  }

  // Helper: Dropdown Field
  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
    required Map<String, Color> colors,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colors['textLabel'],
          ),
        ),
        
        const SizedBox(height: 8),
        
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: colors['inputBackground'],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colors['inputBorder']!,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              items: items,
              onChanged: onChanged,
              isExpanded: true,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: colors['textMain'],
              ),
              icon: Icon(
                Icons.expand_more,
                color: colors['textSecondary'],
              ),
              dropdownColor: colors['inputBackground'],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  // Function to change profile photo
  Future<void> _changeProfilePhoto() async {
    final result = await showModalBottomSheet(
      context: context,
      backgroundColor: _getColors(false)['card'],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Change Profile Photo',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _getColors(false)['textMain'],
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: _getColors(false)['primary'],
                ),
                title: Text(
                  'Take Photo',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: _getColors(false)['textMain'],
                  ),
                ),
                onTap: () {
                  Navigator.pop(context, 'camera');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: _getColors(false)['primary'],
                ),
                title: Text(
                  'Choose from Gallery',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: _getColors(false)['textMain'],
                  ),
                ),
                onTap: () {
                  Navigator.pop(context, 'gallery');
                },
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: _getColors(false)['textSecondary'],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (result == 'camera' || result == 'gallery') {
      // Here you would implement camera/gallery functionality
      // For now, just show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Opening ${result == 'camera' ? 'camera' : 'gallery'}...'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  // Colors based on theme
  Map<String, Color> _getColors(bool isDarkMode) {
    if (isDarkMode) {
      return {
        'primary': const Color(0xFF136DEC),
        'background': const Color(0xFF101822),
        'card': const Color(0xFF101822),
        'textMain': Colors.white,
        'textSecondary': const Color(0xFF94A3B8),
        'textLabel': const Color(0xFF94A3B8),
        'textHint': const Color(0xFF64748B),
        'border': const Color(0xFF1E293B),
        'divider': const Color(0xFF0F172A),
        'inputBackground': const Color(0xFF1E293B),
        'inputBorder': const Color(0xFF334155),
        'sliderTrack': const Color(0xFF334155),
      };
    } else {
      return {
        'primary': const Color(0xFF136DEC),
        'background': const Color(0xFFF6F7F8),
        'card': Colors.white,
        'textMain': const Color(0xFF111418),
        'textSecondary': const Color(0xFF617289),
        'textLabel': const Color(0xFF111418),
        'textHint': const Color(0xFF617289),
        'border': const Color(0xFFE2E8F0),
        'divider': const Color(0xFFF6F7F8),
        'inputBackground': Colors.white,
        'inputBorder': const Color(0xFFDBE0E6),
        'sliderTrack': const Color(0xFFE2E8F0),
      };
    }
  }
}