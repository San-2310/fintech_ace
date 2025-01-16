// chatbot_page.dart
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatbotPage extends StatefulWidget {
  final String initialQuestion;
  final String initialAnswer;

  const ChatbotPage({
    Key? key,
    required this.initialQuestion,
    required this.initialAnswer,
  }) : super(key: key);

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isEnglish = true;
  late GenerativeModel _model;
  late ChatSession _chat;

  // Suggestion chips for common follow-up questions
  final List<String> _englishSuggestions = [
    'Can you explain more?',
    'Give me an example',
    'What are the risks?',
    'Why is this important?',
  ];

  final List<String> _hindiSuggestions = [
    'और विस्तार से बताएं',
    'एक उदाहरण दें',
    'इसमें क्या जोखिम हैं?',
    'यह महत्वपूर्ण क्यों है?',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize the chat with context about being a financial advisor
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: 'AIzaSyAsIWg2xV5Dv-2-IR4pZBZOKwg4wbfI6So',
    );
    _chat = _model.startChat(history: [
      Content.text(
          "You are a helpful financial advisor assistant. The user will ask questions about finance in India. "
          "Keep the context of previous messages in mind when answering follow-up questions. "
          "If the user asks for elaboration, provide more detailed explanations with examples."),
    ]);

    // Add initial FAQ Q&A
    _messages.add({
      'role': 'user',
      'content': widget.initialQuestion,
    });
    _messages.add({
      'role': 'bot',
      'content': widget.initialAnswer,
    });
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'role': 'user',
        'content': message,
      });
    });

    _controller.clear();
    _scrollToBottom();

    try {
      // Enhance the prompt to maintain context
      String languagePrompt = _isEnglish
          ? "Respond in English with detailed information, keeping in mind the previous context: "
          : "पिछले संदर्भ को ध्यान में रखते हुए हिंदी में विस्तृत जानकारी दें: ";

      final response = await _chat.sendMessage(
        Content.text(languagePrompt + message),
      );

      setState(() {
        _messages.add({
          'role': 'bot',
          'content': response.text ?? 'Sorry, I couldn\'t process that.',
        });
      });
    } catch (e) {
      setState(() {
        _messages.add({
          'role': 'bot',
          'content': _isEnglish
              ? 'Sorry, an error occurred. Please try again.'
              : 'क्षमा करें, कोई त्रुटि हुई। कृपया पुनः प्रयास करें।',
        });
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDE0F5),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Financial Assistant'),
        actions: [
          Switch(
            value: _isEnglish,
            onChanged: (value) {
              setState(() {
                _isEnglish = value;
              });
            },
          ),
          Text(_isEnglish ? 'ENG' : 'हिंदी'),
        ],
        backgroundColor: const Color(0xFFDDE0F5),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['role'] == 'user';

                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    decoration: BoxDecoration(
                      color: isUser
                          ? const Color.fromARGB(255, 57, 118, 209)
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message['content']!,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Suggestion chips
          if (_messages.isNotEmpty)
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _isEnglish
                    ? _englishSuggestions.length
                    : _hindiSuggestions.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      label: Text(_isEnglish
                          ? _englishSuggestions[index]
                          : _hindiSuggestions[index]),
                      onPressed: () => _sendMessage(_isEnglish
                          ? _englishSuggestions[index]
                          : _hindiSuggestions[index]),
                    ),
                  );
                },
              ),
            ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: _isEnglish
                          ? 'Ask follow-up questions...'
                          : 'अधिक जानकारी पूछें...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Colors.blue[900],
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
