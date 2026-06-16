// lib/screens/chatbot_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});
  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();
  bool _isTyping = false;
  late AnimationController _dotController;

  final List<Map<String, dynamic>> _messages = [
    {
      'role': 'assistant',
      'text':
          'Hello! I\'m WoolAI, your intelligent wool quality assistant.\n\nI can help you analyse batch data, suggest optimal selling prices, and give insights from your Raspberry Pi sensor readings.\n\nHow can I assist you today?',
      'time': '10:00 AM',
    },
  ];

  final List<String> _quickPrompts = [
    'Ideal moisture for wool?',
    'Analyse my current batch',
    'Best time to sell in Pune?',
    'How to improve quality score?',
  ];

  final _smartReplies = {
    'moisture':
        'The ideal moisture content for raw wool is **10–17 %**.\n\nYour current reading of 14 % is within the premium range.\n\n• Below 10 % → Wool becomes brittle\n• 10–17 % → Premium, maximises weight & softness ✅\n• Above 17 % → Risk of mould, shorter shelf life\n\nYour batch is performing excellently!',
    'batch':
        '📊 **Batch A-192 Analysis**\n\n• Moisture: 14 % ✅ Optimal\n• Weight: 842 g ✅ Good yield\n• Temperature: 23 °C ✅ Ideal\n• Quality Score: 87 / 100 → Grade A\n\n💡 This batch qualifies for Premium and Merino buyers. Expected range: ₹310–₹360 / kg in Pune market.',
    'sell':
        '📅 **Peak demand periods in Pune:**\n\n• Oct–Dec → Winter apparel production. Prices up ~15–20 %\n• Mar–Apr → Export season for blankets\n\n📉 **Low demand:** Jun–Aug (Monsoon)\n\n💡 Current timing (Apr) is stable at ₹295–₹340 / kg. Consider holding until October for ~15 % higher returns.',
    'quality':
        'To improve your score from 87 → 90+:\n\n1. Keep moisture between 12–15 % (yours: 14 % ✅)\n2. Maintain storage at 18–24 °C (yours: 23 °C ✅)\n3. Sort out coarse fibres during processing\n4. Shear in early morning for best fibre integrity\n5. Add mineral supplements 3 months before shearing\n\nEstimated improvement: +5 to +8 points.',
  };

  @override
  void initState() {
    super.initState();
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    _dotController.dispose();
    super.dispose();
  }

  void _send(String text) async {
    if (text.trim().isEmpty) return;
    _input.clear();
    setState(() {
      _messages.add({'role': 'user', 'text': text, 'time': _now()});
      _isTyping = true;
    });
    _scrollBottom();
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    setState(() {
      _isTyping = false;
      _messages.add({
        'role': 'assistant',
        'text': _reply(text),
        'time': _now(),
      });
    });
    _scrollBottom();
  }

  String _reply(String q) {
    final lower = q.toLowerCase();
    if (lower.contains('moisture') || lower.contains('ideal'))
      return _smartReplies['moisture']!;
    if (lower.contains('batch') ||
        lower.contains('analyse') ||
        lower.contains('current'))
      return _smartReplies['batch']!;
    if (lower.contains('sell') ||
        lower.contains('time') ||
        lower.contains('pune'))
      return _smartReplies['sell']!;
    if (lower.contains('quality') ||
        lower.contains('score') ||
        lower.contains('improve'))
      return _smartReplies['quality']!;
    return 'Based on your sensor data, your Batch A-192 is performing at Grade A quality (87/100). Moisture is optimal at 14 % and temperature is stable.\n\nWould you like a deeper analysis or pricing recommendations for the Pune market?';
  }

  String _now() {
    final t = DateTime.now();
    final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
    return '$h:${t.minute.toString().padLeft(2, '0')} ${t.hour < 12 ? 'AM' : 'PM'}';
  }

  void _scrollBottom() => Future.delayed(const Duration(milliseconds: 120), () {
    if (_scroll.hasClients) {
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05060F),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView.builder(
                controller: _scroll,
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                physics: const BouncingScrollPhysics(),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (_, i) {
                  if (_isTyping && i == _messages.length) return _buildTyping();
                  return _buildMsg(_messages[i]);
                },
              ),
            ),
            _buildQuickPrompts(),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF05060F),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF2563FF).withOpacity(0.12),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [Color(0xFF2563FF), Color(0xFF00CFFD)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WoolAI Assistant',
                  style: GoogleFonts.outfit(
                    color: const Color(0xFFEFF2FF),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF00F5A0),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Online · AI-Powered',
                      style: GoogleFonts.dmSans(
                        color: const Color(0xFF00F5A0),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFF2563FF).withOpacity(0.08),
              border: Border.all(
                color: const Color(0xFF2563FF).withOpacity(0.15),
                width: 0.6,
              ),
            ),
            child: const Icon(
              Icons.more_horiz_rounded,
              color: Color(0xFF4F8EFF),
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMsg(Map<String, dynamic> msg) {
    final isUser = msg['role'] == 'user';
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  colors: [Color(0xFF2563FF), Color(0xFF00CFFD)],
                ),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 14,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isUser ? 16 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 16),
                    ),
                    gradient: isUser
                        ? const LinearGradient(
                            colors: [Color(0xFF2563FF), Color(0xFF1A4CC0)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isUser ? null : const Color(0xFF0A0C1C),
                    border: isUser
                        ? null
                        : Border.all(
                            color: const Color(0xFF2563FF).withOpacity(0.10),
                            width: 0.6,
                          ),
                  ),
                  child: Text(
                    msg['text'] as String,
                    style: GoogleFonts.dmSans(
                      color: isUser ? Colors.white : const Color(0xFFD6DFF5),
                      fontSize: 14,
                      height: 1.55,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  msg['time'] as String,
                  style: GoogleFonts.dmSans(
                    color: const Color(0xFF3D4F7C),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildTyping() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                colors: [Color(0xFF2563FF), Color(0xFF00CFFD)],
              ),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 14,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(16),
              ),
              color: const Color(0xFF0A0C1C),
              border: Border.all(
                color: const Color(0xFF2563FF).withOpacity(0.10),
                width: 0.6,
              ),
            ),
            child: Row(
              children: List.generate(
                3,
                (i) => AnimatedBuilder(
                  animation: _dotController,
                  builder: (_, __) => Opacity(
                    opacity: i == 0
                        ? _dotController.value
                        : i == 1
                        ? (1 - _dotController.value) * 0.7 + 0.3
                        : _dotController.value * 0.5 + 0.3,
                    child: Container(
                      margin: EdgeInsets.only(right: i < 2 ? 4 : 0),
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4F8EFF),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickPrompts() {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        itemCount: _quickPrompts.length,
        itemBuilder: (_, i) => GestureDetector(
          onTap: () => _send(_quickPrompts[i]),
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFF2563FF).withOpacity(0.10),
              border: Border.all(
                color: const Color(0xFF2563FF).withOpacity(0.28),
                width: 0.7,
              ),
            ),
            child: Text(
              _quickPrompts[i],
              style: GoogleFonts.dmSans(
                color: const Color(0xFF4F8EFF),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        decoration: BoxDecoration(
          color: const Color(0xFF05060F),
          border: Border(
            top: BorderSide(
              color: const Color(0xFF2563FF).withOpacity(0.10),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: const Color(0xFF0A0C1C),
                  border: Border.all(
                    color: const Color(0xFF2563FF).withOpacity(0.18),
                    width: 0.8,
                  ),
                ),
                child: TextField(
                  controller: _input,
                  style: GoogleFonts.dmSans(
                    color: const Color(0xFFEFF2FF),
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Ask about your wool...',
                    hintStyle: GoogleFonts.dmSans(
                      color: const Color(0xFF3D4F7C),
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onSubmitted: _send,
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => _send(_input.text),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2563FF), Color(0xFF00CFFD)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
