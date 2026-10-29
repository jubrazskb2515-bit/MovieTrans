import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MultiTranslateApp());
}

class MultiTranslateApp extends StatelessWidget {
  const MultiTranslateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TransFlow Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0E17),
      ),
      home: const MainTranslationScreen(),
    );
  }
}

class MainTranslationScreen extends StatefulWidget {
  const MainTranslationScreen({super.key});

  @override
  State<MainTranslationScreen> createState() => _MainTranslationScreenState();
}

class _MainTranslationScreenState extends State<MainTranslationScreen> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _textInputController = TextEditingController();
  
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;

  String _sourceText = "এখানে আপনার ইনপুট দেখা যাবে...";
  String _translatedText = "অনূদিত শুদ্ধ বাংলা এখানে প্রদর্শিত হবে...";

  void _playMediaFromUrl(String url) {
    if (url.isEmpty) return;
    _videoController?.dispose();
    _videoController = VideoPlayerController.networkUrl(Uri.parse(url))
      ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
          _videoController!.play();
        });
      });
  }

  void _translateInput(String text) {
    setState(() {
      _sourceText = text;
      _translatedText = "শুদ্ধ বাংলা: \"$text\" সফলভাবে প্রক্রিয়া সম্পন্ন হয়েছে।";
    });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _urlController.dispose();
    _textInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -40,
            left: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF8A2387),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            right: -40,
            child: Container(
              width: 250,
              height: 250,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF00F2FE),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.translate, color: Color(0xFF00F2FE), size: 26),
                      SizedBox(width: 8),
                      Text(
                        "TRANSFLOW AI",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildGlassBox(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _urlController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: "ভিডিও বা অডিও লিঙ্ক পেস্ট করুন...",
                              hintStyle: TextStyle(color: Colors.white54, fontSize: 13),
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.link, color: Color(0xFF00F2FE)),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.play_circle_fill, color: Color(0xFF00F2FE), size: 30),
                          onPressed: () => _playMediaFromUrl(_urlController.text),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildGlassBox(
                    height: 210,
                    child: _isVideoInitialized
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: AspectRatio(
                              aspectRatio: _videoController!.value.aspectRatio,
                              child: VideoPlayer(_videoController!),
                            ),
                          )
                        : const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.smart_display_rounded, size: 45, color: Color(0xFF4FACFE)),
                                SizedBox(height: 8),
                                Text("প্লেয়ার প্রস্তুত - লিঙ্ক পেস্ট করে প্লে বাটনে চাপুন", style: TextStyle(color: Colors.white70, fontSize: 12)),
                              ],
                            ),
                          ),
                  ),
                  const SizedBox(height: 15),
                  _buildGlassBox(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _textInputController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: "মুখে বলুন অথবা টেক্সট লিখুন...",
                              hintStyle: TextStyle(color: Colors.white54, fontSize: 13),
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.mic, color: Color(0xFFFF0844)),
                            ),
                            onSubmitted: _translateInput,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send_rounded, color: Color(0xFF00F2FE)),
                          onPressed: () => _translateInput(_textInputController.text),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildGlassBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("ইনপুট টেক্সট / অডিও:", style: TextStyle(color: Color(0xFF4FACFE), fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(_sourceText, style: const TextStyle(color: Colors.white, fontSize: 14)),
                        const Divider(color: Colors.white24, height: 20),
                        const Text("শুদ্ধ বাংলা অনুবাদ:", style: TextStyle(color: Color(0xFFFFD700), fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text(
                          _translatedText,
                          style: const TextStyle(
                            color: Color(0xFF00FFCC), // উজ্জ্বল নিয়ন সায়ান কালার
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassBox({required Widget child, double? height}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: height,
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.07),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.18), width: 1.2),
          ),
          child: child,
        ),
      ),
    );
  }
}
