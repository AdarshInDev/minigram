import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minigram/features/auth/presentation/pages/post_page.dart';
import 'package:minigram/features/auth/presentation/pages/profile_page.dart'; // Import the profile page
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _refreshData() {
    setState(() {
      // Triggering a refresh by setting the state again, re-fetching data
      // In a real-world scenario, you could trigger a Firestore query refresh here
    });
  }

  static const List<Widget> _widgetOptions = <Widget>[
    TextPost(),
    VideoPost(), // This remains unchanged
    ImagePost(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Refresh button
          FloatingActionButton(
            onPressed: _refreshData,
            backgroundColor: Colors.blue,
            heroTag: 'refresh_btn',
            child: const Icon(Icons.refresh, color: Colors.white),
          ),
          const SizedBox(height: 10), // Space between buttons
          // Add Post button
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreatePostPage()));
            },
            backgroundColor: Colors.purple,
            heroTag: 'add_post_btn',
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          // CircleAvatar for profile
          GestureDetector(
            onTap: () {
              // Navigate to Profile Page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
            },
            child: const CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                  'https://www.example.com/profile_image.jpg'), // Replace with the user's profile image URL
            ),
          ),
          const SizedBox(width: 10), // Add some spacing
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.text_fields),
            label: 'Text Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_label),
            label: 'Video Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Image Post',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class TextPost extends StatelessWidget {
  const TextPost({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection("text_posts").get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No text posts available.'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var post = snapshot.data!.docs[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                // subtitle: Text(
                //   post['content'] ?? 'No Title',
                //   style: const TextStyle(
                //       fontSize: 18, fontWeight: FontWeight.bold),
                // ),
                title: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    post['content'] ?? 'No Content',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                leading: const Icon(Icons.text_fields,
                    size: 40, color: Colors.purple),
              ),
            );
          },
        );
      },
    );
  }
}

class ImagePost extends StatelessWidget {
  const ImagePost({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection("image_posts").get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No image posts available.'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var post = snapshot.data!.docs[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  post[
                      'imageUrl'], // Assuming imageUrl is the field in Firestore
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class VideoPost extends StatelessWidget {
  const VideoPost({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection("video_posts").get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No video posts available.'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var post = snapshot.data!.docs[index];
            return VideoPostTile(videoUrl: post['videoUrl']);
          },
        );
      },
    );
  }
}

class VideoPostTile extends StatefulWidget {
  final String videoUrl;

  const VideoPostTile({super.key, required this.videoUrl});

  @override
  _VideoPostTileState createState() => _VideoPostTileState();
}

class _VideoPostTileState extends State<VideoPostTile> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            height: 200,
            child: _controller.value.isInitialized
                ? VideoPlayer(_controller)
                : const Center(child: CircularProgressIndicator()),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Video Post",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                });
              },
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
