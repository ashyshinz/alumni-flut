import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // 1. STATE VARIABLES
  bool _isEditing = false;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  // Dynamic Skills List
  final List<String> _skills = ["JavaScript", "React", "Node.js"];

  // Controllers
  final TextEditingController _nameController = TextEditingController(text: "AJ Domopoy");
  final TextEditingController _emailController = TextEditingController(text: "alumni@alumni.edu");
  final TextEditingController _phoneController = TextEditingController(text: "+1 234 567 8900");
  final TextEditingController _addressController = TextEditingController(text: "Enter your address");

  // 2. LOGIC: ADD SKILL DIALOG
  void _showAddSkillDialog() {
    final TextEditingController skillController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Skill"),
        content: TextField(
          controller: skillController,
          autofocus: true,
          decoration: const InputDecoration(hintText: "e.g. Flutter, Python, SQL"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (skillController.text.isNotEmpty) {
                setState(() {
                  _skills.add(skillController.text);
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  // IMAGE PICKER LOGIC
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF3F3F3),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Profile Management",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
            ),
            const Text(
              "Manage your personal information and professional details",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // PROFILE PICTURE SECTION
            _buildSectionCard(
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: _imageFile != null 
                            ? FileImage(_imageFile!) as ImageProvider
                            : const AssetImage('assets/eunchae.jpg'),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: _pickImage,
                          child: const CircleAvatar(
                            radius: 18,
                            backgroundColor: Color(0xFF4A0E2E),
                            child: Icon(Icons.camera_alt, size: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_nameController.text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(_emailController.text, style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
                      const Text("Student ID: 2020-00123", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // PERSONAL INFORMATION SECTION
            _buildSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Personal Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() => _isEditing = !_isEditing);
                        },
                        icon: Icon(_isEditing ? Icons.save : Icons.edit, size: 18),
                        label: Text(_isEditing ? "Save Changes" : "Edit Profile"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isEditing ? Colors.green : const Color(0xFF6366F1),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: _buildField("Full Name", _nameController, Icons.person_outlined)),
                      const SizedBox(width: 20),
                      Expanded(child: _buildField("Email Address", _emailController, Icons.email_outlined)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: _buildField("Phone Number", _phoneController, Icons.phone_outlined)),
                      const SizedBox(width: 20),
                      Expanded(child: _buildField("Program", TextEditingController(text: "Information Technology"), null, canEdit: false)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildField("Address", _addressController, Icons.location_on_outlined),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // 5. SKILLS SECTION (UPDATED)
            _buildSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Skills", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      // Generate chips from the dynamic list
                      ..._skills.map((skill) => _buildSkillChip(skill)),
                      
                      // Only show the "Add" button when editing mode is ON
                      if (_isEditing) 
                        ActionChip(
                          avatar: const Icon(Icons.add, size: 16, color: Color(0xFF1A237E)),
                          label: const Text("Add Skill"),
                          onPressed: _showAddSkillDialog,
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Color(0xFFC5CAE9)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: child,
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData? icon, {bool canEdit = true}) {
    bool activeEdit = _isEditing && canEdit;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: !activeEdit,
          decoration: InputDecoration(
            prefixIcon: icon != null ? Icon(icon, size: 20, color: activeEdit ? const Color(0xFF6366F1) : Colors.grey) : null,
            filled: true,
            fillColor: activeEdit ? Colors.white : const Color(0xFFF9F9F9),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: activeEdit ? const Color(0xFF6366F1) : Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildSkillChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: const Color(0xFFC5CAE9),
      labelStyle: const TextStyle(color: Color(0xFF1A237E), fontWeight: FontWeight.bold),
      onDeleted: _isEditing ? () {
        setState(() {
          _skills.remove(label);
        });
      } : null, // Show "X" to delete only when editing
      deleteIconColor: const Color(0xFF1A237E),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}