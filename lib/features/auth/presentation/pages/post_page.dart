import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _textController = TextEditingController();
  XFile? _image;
  XFile? _video;
  String _selectedCategory = "text"; // default category is 'text'

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = selectedImage;
    });
  }

  Future<void> _pickVideo() async {
    final XFile? selectedVideo =
        await _picker.pickVideo(source: ImageSource.gallery);
    setState(() {
      _video = selectedVideo;
    });
  }

  // Function to upload image or video to Firebase Storage and get the URL
  Future<String> _uploadToStorage(File file, String path) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference storageRef = storage.ref().child(path);
    UploadTask uploadTask = storageRef.putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL(); // Get download URL after upload
  }

  // Function to submit the post
  void _submitPost() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    if (_selectedCategory == "text" && _textController.text.isNotEmpty) {
      // Handle text post submission
      try {
        await firestore.collection("text_posts").doc().set({
          'type': 'text',
          'content': _textController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Text post uploaded successfully!")),
        );
        _textController.clear(); // Clear the text input after upload
      } catch (e) {
        print('Error uploading text post: $e');
      }
    } else if (_selectedCategory == "image" && _image != null) {
      // Handle image post submission
      try {
        String imageUrl = await _uploadToStorage(
            File(_image!.path), 'images/${DateTime.now()}.jpg');
        await firestore.collection("image_posts").doc().set({
          'type': 'image',
          'imageUrl': imageUrl,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image post uploaded successfully!")),
        );
        setState(() {
          _image = null; // Clear image after upload
        });
      } catch (e) {
        print('Error uploading image: $e');
      }
    } else if (_selectedCategory == "video" && _video != null) {
      // Handle video post submission
      try {
        String videoUrl = await _uploadToStorage(
            File(_video!.path), 'videos/${DateTime.now()}.mp4');
        await firestore.collection("video_posts").doc().set({
          'type': 'video',
          'videoUrl': videoUrl,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Video post uploaded successfully!")),
        );
        setState(() {
          _video = null; // Clear video after upload
        });
      } catch (e) {
        print('Error uploading video: $e');
      }
    } else {
      // Error handling for empty input
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                "Please provide the necessary data for the selected post type.")),
      );
    }
  }

  // UI for post submission
  Widget _submitPostButton() {
    return ElevatedButton(
      onPressed: _submitPost, // Calls the submit function
      child: const Text("Submit Post"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Post"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown to choose category
            const Text("Select Post Type:"),
            DropdownButton<String>(
              value: _selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
              items: const <DropdownMenuItem<String>>[
                DropdownMenuItem(value: "text", child: Text("Text Post")),
                DropdownMenuItem(value: "image", child: Text("Image Post")),
                DropdownMenuItem(value: "video", child: Text("Video Post")),
              ],
            ),
            const SizedBox(height: 20),

            // Text Field for Text Post
            TextField(
              controller: _textController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Enter your text here",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Image picker
            _image == null
                ? ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text("Pick Image from Gallery"),
                  )
                : Column(
                    children: [
                      Image.file(
                        File(_image!.path),
                        height: 100,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => setState(() => _image = null),
                        child: const Text("Remove Image"),
                      ),
                    ],
                  ),
            const SizedBox(height: 20),

            // Video picker
            _video == null
                ? ElevatedButton(
                    onPressed: _pickVideo,
                    child: const Text("Pick Video from Gallery"),
                  )
                : Column(
                    children: [
                      const Text("Video selected!"),
                      ElevatedButton(
                        onPressed: () => setState(() => _video = null),
                        child: const Text("Remove Video"),
                      ),
                    ],
                  ),
            const SizedBox(height: 20),

            // Submit Post Button
            _submitPostButton(),
          ],
        ),
      ),
    );
  }
}
