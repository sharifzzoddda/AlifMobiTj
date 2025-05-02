import 'dart:convert';
import 'package:aliftj/comments_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  List<Post> allInfo = [];
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    getPost();
  }

  Future<void> getPost() async {
    try {
      var response = await http.get(
        Uri.parse("https://jsonplaceholder.typicode.com/posts"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          allInfo =
              (jsonDecode(response.body) as List)
                  .map((e) => Post.fromJson(e))
                  .toList();
        });
      } else {
        print(response.body);
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Post Page",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body:
          allInfo.isEmpty
              ? ListView.builder(
                itemCount: 6,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) => const PostShimmer(),
              )
              : ListView.builder(
                itemCount: allInfo.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final post = allInfo[index];
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      height: 333,
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 30,
                      ),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(color: Colors.green.shade400),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset(
                                "assets/images/image.png",
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(
                            '👤 ${post.userId}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "📃 ${post.title}",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "✍️ ${post.body}",
                            overflow: TextOverflow.ellipsis,
                          ),

                          Center(
                            child: IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => const CommentsPage(),
                                );
                              },
                              icon: const Icon(Icons.comment_bank_outlined),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}

class PostShimmer extends StatelessWidget {
  const PostShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: double.infinity,
        height: 280,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 60),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 80, height: 20, color: Colors.white),
            SizedBox(height: 8),
            Container(width: double.infinity, height: 20, color: Colors.white),
            SizedBox(height: 8),
            Container(width: double.infinity, height: 80, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class Post {
  int userId;
  int id;
  String title;
  String body;

  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    userId: json["userId"],
    id: json["id"],
    title: json["title"],
    body: json["body"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "title": title,
    "body": body,
  };
}
