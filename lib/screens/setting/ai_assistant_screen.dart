import 'package:flutter/material.dart';

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantState();
}

class _AIAssistantState extends State<AIAssistantScreen> {

  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = [];

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    String userMsg = _controller.text.trim();

    setState(() {
      messages.add({"role": "user", "msg": userMsg});
    });

    _controller.clear();

    // AI Auto-response (you can replace with real OpenAI API later)
    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        messages.add({
          "role": "ai",
          "msg": "I'm your AI Travel Assistant! I can help with:\n"
              "• Best places to visit\n"
              "• Weather info\n"
              "• Hotel recommendations\n"
              "• Food suggestions\n"
              "Just ask anything 😊"
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Travel Assistant"),
        backgroundColor: const Color(0xFF1746A2),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (_, i) {
                bool isUser = messages[i]["role"] == "user";
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: isUser
                          ? const Color(0xFF1746A2)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      messages[i]["msg"]!,
                      style: TextStyle(
                          color: isUser ? Colors.white : Colors.black87),
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Ask me anything...",
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF1746A2), size: 28),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
