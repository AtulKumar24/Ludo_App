import 'package:flutter/material.dart';
import '../Model/Responsive.dart';

class EmojiSection extends StatefulWidget {
  final Function(String)? onEmojiSelected;
  final List<String>? selectedEmojis;

  const EmojiSection({
    super.key,
    this.onEmojiSelected,
    this.selectedEmojis,
  });

  @override
  State<EmojiSection> createState() => _EmojiSectionState();
}

class _EmojiSectionState extends State<EmojiSection> {
  final List<String> _emojis = [
    '😎', // Smiling face with sunglasses
    '😂', // Face with tears of joy
    '😊', // Smiling face with closed eyes
    '🤣', // Rolling on the floor laughing
    '😢', // Crying face
    '🥰', // Smiling face with hearts
  ];

  String? _selectedEmoji;

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    double scale = responsive.scale;

    return Container(
      height: 60 * scale,
      decoration: BoxDecoration(
        color: Color(0xFF1A237E), // Dark blue background like in screenshot
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20 * scale),
          topRight: Radius.circular(20 * scale),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10 * scale,
            offset: Offset(0, -2 * scale),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16 * scale, vertical: 8 * scale),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _emojis.map((emoji) {
            bool isSelected = _selectedEmoji == emoji;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedEmoji = isSelected ? null : emoji;
                });
                if (widget.onEmojiSelected != null) {
                  widget.onEmojiSelected!(_selectedEmoji ?? '');
                }
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.all(8 * scale),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12 * scale),
                  border: isSelected 
                    ? Border.all(color: Colors.blue, width: 2 * scale)
                    : null,
                ),
                child: Text(
                  emoji,
                  style: TextStyle(
                    fontSize: 24 * scale,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
