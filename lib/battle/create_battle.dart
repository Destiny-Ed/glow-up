// lib/screens/create_battle_screen.dart

import 'package:flutter/material.dart';

class CreateBattleScreen extends StatefulWidget {
  const CreateBattleScreen({super.key});

  @override
  State<CreateBattleScreen> createState() => _CreateBattleScreenState();
}

class _CreateBattleScreenState extends State<CreateBattleScreen> {
  final TextEditingController _customThemeController = TextEditingController();
  final TextEditingController _captionController = TextEditingController();

  String _selectedDuration = '24h'; // 24h, 48h, until_all
  final List<Map<String, dynamic>> _selectedOpponents = [];
  final List<String> _trendingThemes = [
    'Streetwear',
    'Vintage',
    'Gym Fit',
    'Date Night',
    '90s Vibes',
    'Office Slay',
    'Festival Look',
  ];

  // Dummy friends list for selection
  final List<Map<String, dynamic>> _friends = [
    {
      'name': 'Sarah',
      'username': '@sarah_k',
      'avatar': 'https://via.placeholder.com/80',
    },
    {
      'name': 'Elena',
      'username': '@elena_style',
      'avatar': 'https://via.placeholder.com/80',
    },
    {
      'name': 'Jordan',
      'username': '@j_smith99',
      'avatar': 'https://via.placeholder.com/80',
    },
    {
      'name': 'Mike',
      'username': '@mike_drips',
      'avatar': 'https://via.placeholder.com/80',
    },
    {
      'name': 'Marcus',
      'username': '@mchen_designs',
      'avatar': 'https://via.placeholder.com/80',
    },
  ];

  @override
  void dispose() {
    _customThemeController.dispose();
    _captionController.dispose();
    super.dispose();
  }

  void _addOpponent(Map<String, dynamic> friend) {
    if (_selectedOpponents.length < 5 &&
        !_selectedOpponents.any((e) => e['username'] == friend['username'])) {
      setState(() => _selectedOpponents.add(friend));
    }
  }

  void _removeOpponent(String username) {
    setState(
      () => _selectedOpponents.removeWhere((e) => e['username'] == username),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool canSend =
        _selectedOpponents.isNotEmpty &&
        (_customThemeController.text.isNotEmpty ||
            _trendingThemes.contains(_customThemeController.text));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'New Battle',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {}, // Drafts
            child: const Text(
              'Drafts',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose Theme',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Trending Themes
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.whatshot, color: Colors.black, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Trending',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  ..._trendingThemes.map(
                    (theme) => Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ChoiceChip(
                        label: Text(theme),
                        selected: _customThemeController.text == theme,
                        onSelected: (_) =>
                            setState(() => _customThemeController.text = theme),
                        backgroundColor: Colors.white10,
                        selectedColor: Colors.green.withOpacity(0.3),
                        labelStyle: TextStyle(
                          color: _customThemeController.text == theme
                              ? Colors.green
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Custom Theme Field
            TextField(
              controller: _customThemeController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Or enter custom theme...',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.edit, color: Colors.white54),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 32),

            // Select Opponents
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Opponents',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_selectedOpponents.length}/5 Selected',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Selected Opponents Horizontal Scroll
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _selectedOpponents.length + 1,
                itemBuilder: (context, index) {
                  if (index == _selectedOpponents.length) {
                    return GestureDetector(
                      onTap: () {
                        // Show friend picker bottom sheet
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.grey[900],
                          builder: (_) => _buildFriendPicker(),
                        );
                      },
                      child: Container(
                        width: 80,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white30,
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.transparent,
                        ),
                        child: const Center(
                          child: Text(
                            '+',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  final opponent = _selectedOpponents[index];
                  return Stack(
                    children: [
                      Container(
                        width: 80,
                        margin: const EdgeInsets.only(right: 12),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 36,
                              backgroundImage: NetworkImage(opponent['avatar']),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              opponent['name'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => _removeOpponent(opponent['username']),
                          child: const CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 32),

            // Duration
            const Text(
              'Duration',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _durationChip('24h', true),
                const SizedBox(width: 12),
                _durationChip('48h', false),
                const SizedBox(width: 12),
                _durationChip('Until all post', false),
              ],
            ),

            const SizedBox(height: 32),

            // Caption
            const Text(
              'Add Caption (Optional)',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _captionController,
              maxLength: 140,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Trash talk or set specific rules...',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                counterText: '${_captionController.text.length}/140',
                counterStyle: const TextStyle(color: Colors.white54),
              ),
            ),

            const Spacer(),

            // Send Challenge Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canSend
                    ? () {
                        // Send battle
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Challenge sent! 🔥')),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canSend ? Colors.green : Colors.grey[800],
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: canSend ? 10 : 0,
                  shadowColor: canSend ? Colors.green.withOpacity(0.5) : null,
                ),
                child: Text(
                  'Send Challenge >',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: canSend ? Colors.black : Colors.white54,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _durationChip(String label, bool selected) {
    return GestureDetector(
      onTap: () => setState(() => _selectedDuration = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? Colors.green : Colors.white10,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildFriendPicker() {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'Add Opponent',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(color: Colors.white30),
          Expanded(
            child: ListView.builder(
              itemCount: _friends.length,
              itemBuilder: (context, index) {
                final friend = _friends[index];
                final isSelected = _selectedOpponents.any(
                  (e) => e['username'] == friend['username'],
                );
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(friend['avatar']),
                  ),
                  title: Text(
                    friend['name'],
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    friend['username'],
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () {
                    _addOpponent(friend);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
