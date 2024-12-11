import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  final String currentName;
  final String currentEmail;
  final String currentImageUrl;
  final Function(String, String, String) onSave;

  const EditProfilePage({
    super.key,
    required this.currentName,
    required this.currentEmail,
    required this.currentImageUrl,
    required this.onSave,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  File? _image;
  String? _uploadedImageUrl;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.currentName);
    emailController = TextEditingController(text: widget.currentEmail);
    _uploadedImageUrl = widget.currentImageUrl;
  }

  void _saveProfile(String newName, String newEmail, String newImageUrl) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('user_name', newName);
    await prefs.setString('user_email', newEmail);
    if (newImageUrl.isNotEmpty) {
      await prefs.setString('profile_image', newImageUrl);
    }

    Navigator.pop(
        context, {'name': newName, 'email': newEmail, 'imageUrl': newImageUrl});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF320847),
        title:
            const Text('Edit Profile', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: GestureDetector(
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: _image != null
                      ? FileImage(_image!)
                      : (_uploadedImageUrl != null
                          ? NetworkImage(_uploadedImageUrl!) as ImageProvider
                          : null),
                  backgroundColor: Colors.grey[300],
                  child: _image == null && _uploadedImageUrl == null
                      ? const Icon(Icons.add_a_photo,
                          size: 50, color: Colors.grey)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name')),
            TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _saveProfile(
                    nameController.text,
                    emailController.text,
                    _uploadedImageUrl ?? widget.currentImageUrl,
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF320847)),
                child:
                    const Text('Save', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
