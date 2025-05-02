import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({super.key});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  List<Comments> allInfo = [];
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    getPost();
  }

  Future<void> getPost() async {
    try {
      var response = await http.get(
        Uri.parse("https://jsonplaceholder.typicode.com/comments"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          allInfo =
              (jsonDecode(response.body) as List)
                  .map((e) => Comments.fromJson(e))
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
      appBar: AppBar(centerTitle: true, title: Text("Comments")),
      body:
          allInfo.isEmpty
              ? ListView.builder(
                itemCount: 6,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) => const PostShimmer(),
              )
              : ListView.builder(
                itemCount: allInfo.length,
                padding: const EdgeInsets.all(5),
                itemBuilder: (context, index) {
                  final comments = allInfo[index];
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 8,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.account_circle, size: 30),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                comments.email,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              SizedBox(
                                width: 300,
                                child: Text(
                                  "✍️ ${comments.body}",
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
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
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(radius: 25, backgroundColor: Colors.white),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 120, height: 20, color: Colors.white),
                const SizedBox(height: 6),
                Container(width: 200, height: 20, color: Colors.white),
                const SizedBox(height: 10),
                Container(width: 250, height: 20, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Comments {
  String email;
  String body;

  Comments({required this.email, required this.body});

  factory Comments.fromJson(Map<String, dynamic> json) =>
      Comments(email: json["email"], body: json["body"]);

  Map<String, dynamic> toJson() => {"email": email, "body": body};
}
