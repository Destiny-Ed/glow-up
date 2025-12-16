import 'package:flutter/material.dart';
import 'package:glow_up/core/extensions.dart';
import 'package:glow_up/providers/battle_viewmodel.dart';
import 'package:glow_up/providers/user_view_model.dart';
import 'package:provider/provider.dart';

class CreateBattleScreen extends StatefulWidget {
  const CreateBattleScreen({super.key});

  @override
  State<CreateBattleScreen> createState() => _CreateBattleScreenState();
}

class _CreateBattleScreenState extends State<CreateBattleScreen> {
  final TextEditingController _customThemeController = TextEditingController();
  final TextEditingController _captionController = TextEditingController();

  String _selectedDuration = '24h';
  final List<String> _selectedOpponents = [];
  final List<String> _trendingThemes = [
    'Streetwear',
    'Vintage',
    'Gym Fit',
    'Date Night',
    '90s Vibes',
    'Office Slay',
    'Festival Look',
  ];

  Duration get _duration {
    switch (_selectedDuration) {
      case '48h':
        return const Duration(hours: 48);
      case 'Until all post':
        return const Duration(days: 30); // Long duration
      default:
        return const Duration(hours: 24);
    }
  }

  @override
  void dispose() {
    _customThemeController.dispose();
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userVm = context.read<UserViewModel>();
    final battleVm = context.read<BattleViewModel>();

    final friends = userVm.user?.friendUids ?? [];

    final theme = _customThemeController.text.isNotEmpty
        ? _customThemeController.text
        : _trendingThemes.firstWhere(
            (t) => t.toLowerCase() == _customThemeController.text.toLowerCase(),
            orElse: () => _customThemeController.text,
          );

    final canSend = _selectedOpponents.isNotEmpty && theme.isNotEmpty;

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
            16.height(),

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
                  12.width(),
                  ..._trendingThemes.map((theme) {
                    final selected = _customThemeController.text == theme;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ChoiceChip(
                        label: Text(theme),
                        selected: selected,
                        onSelected: (_) =>
                            setState(() => _customThemeController.text = theme),
                        backgroundColor: Colors.white10,
                        selectedColor: Colors.green.withOpacity(0.3),
                        labelStyle: TextStyle(
                          color: selected ? Colors.green : Colors.white,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            20.height(),

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

            32.height(),

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
            16.height(),

            // Selected Opponents Horizontal Scroll
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _selectedOpponents.length + 1,
                itemBuilder: (context, index) {
                  if (index == _selectedOpponents.length) {
                    return GestureDetector(
                      onTap: () => _showFriendPicker(context, friends),
                      child: Container(
                        width: 80,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white30, width: 2),
                          borderRadius: BorderRadius.circular(40),
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

                  final opponentUid = _selectedOpponents[index];
                  return Stack(
                    children: [
                      Container(
                        width: 80,
                        margin: const EdgeInsets.only(right: 12),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 36,
                              backgroundImage: NetworkImage(
                                'https://i.pravatar.cc/150?u=$opponentUid',
                              ),
                            ),
                            6.height(),
                            Text(
                              'Friend',
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
                          onTap: () => setState(
                            () => _selectedOpponents.remove(opponentUid),
                          ),
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

            32.height(),

            // Duration
            const Text(
              'Duration',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            16.height(),
            Row(
              children: [
                _durationChip('24h', _selectedDuration == '24h'),
                12.width(),
                _durationChip('48h', _selectedDuration == '48h'),
                12.width(),
                _durationChip(
                  'Until all post',
                  _selectedDuration == 'Until all post',
                ),
              ],
            ),

            32.height(),

            // Caption
            const Text(
              'Add Caption (Optional)',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            12.height(),
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
                counterStyle: const TextStyle(color: Colors.white54),
              ),
            ),

            const Spacer(),

            // Send Challenge Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canSend && !battleVm.isLoading
                    ? () async {
                        await battleVm.createBattle(
                          theme: theme,
                          caption: _captionController.text.isEmpty
                              ? null
                              : _captionController.text,
                          duration: _duration,
                          opponentUids: _selectedOpponents,
                        );

                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Challenge sent! 🔥')),
                        );

                        Navigator.pop(context);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canSend ? Colors.green : Colors.grey[800],
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: canSend ? 10 : 0,
                ),
                child: battleVm.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Send Challenge >',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFriendPicker(BuildContext context, List<String> friendUids) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      builder: (_) => Container(
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
                itemCount: friendUids.length,
                itemBuilder: (context, index) {
                  final uid = friendUids[index];
                  final isSelected = _selectedOpponents.contains(uid);

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/150?u=$uid',
                      ),
                    ),
                    title: Text(
                      'Friend $uid',
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedOpponents.remove(uid);
                        } else if (_selectedOpponents.length < 5) {
                          _selectedOpponents.add(uid);
                        }
                      });
                      Navigator.pop(context);
                    },
                  );
                },
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
}
