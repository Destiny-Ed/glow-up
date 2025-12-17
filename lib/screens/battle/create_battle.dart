import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glow_up/core/extensions.dart';
import 'package:glow_up/providers/battle_viewmodel.dart';
import 'package:glow_up/providers/user_view_model.dart';
import 'package:glow_up/widgets/custom_button.dart';
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
    'High School Vibe',
    'Swag King',
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text('New Battle'),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Draft',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose Theme',
                style: Theme.of(context).textTheme.headlineMedium,
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
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.whatshot,
                            color: Theme.of(
                              context,
                            ).textTheme.headlineMedium!.color,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Trending',
                            style: Theme.of(context).textTheme.titleMedium,
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
                          onSelected: (_) => setState(
                            () => _customThemeController.text = theme,
                          ),
                          backgroundColor: Theme.of(context).cardColor,
                          selectedColor: Theme.of(
                            context,
                          ).primaryColor.withOpacity(0.3),
                          labelStyle: TextStyle(
                            color: selected
                                ? Theme.of(context).primaryColor
                                : Theme.of(
                                    context,
                                  ).textTheme.headlineMedium!.color,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),

              20.height(),

              // Custom Theme Field
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextFormField(
                  controller: _customThemeController,
                  style: Theme.of(context).textTheme.titleMedium,
                  decoration: InputDecoration(
                    hintText: 'Or enter custom theme...',
                    hintStyle: Theme.of(context).textTheme.titleMedium,
                    prefixIcon: Icon(
                      Icons.edit,
                      color: Theme.of(
                        context,
                      ).textTheme.titleMedium!.color!.darken(),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),

              32.height(),

              // Select Opponents
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Opponents',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    '${_selectedOpponents.length}/5 Selected',
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).textTheme.titleMedium!.color!.darken(),
                    ),
                  ),
                ],
              ),
              16.height(),

              // Selected Opponents Horizontal Scroll
              SizedBox(
                height: 50,
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
                            border: Border.all(
                              color: Theme.of(context).cardColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Center(
                            child: Text(
                              '+',
                              style: Theme.of(context).textTheme.titleMedium,
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
                                backgroundImage: CachedNetworkImageProvider(
                                  'https://i.pravatar.cc/150?u=$opponentUid',
                                ),
                              ),
                              6.height(),
                              Text(
                                'Friend',
                                style: Theme.of(context).textTheme.titleMedium,
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
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Theme.of(context).cardColor,
                              child: Icon(
                                Icons.close,
                                size: 16,
                                color: Theme.of(
                                  context,
                                ).textTheme.titleMedium!.color!,
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
              Text(
                'Duration',
                style: Theme.of(context).textTheme.headlineMedium,
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
              Text(
                'Add Caption (Optional)',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              12.height(),
              Container(
                padding: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextFormField(
                  controller: _captionController,
                  maxLength: 140,
                  maxLines: 3,
                  style: Theme.of(context).textTheme.titleMedium,
                  decoration: InputDecoration(
                    hintText: 'Trash talk or set specific rules...',
                    hintStyle: Theme.of(context).textTheme.titleMedium,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                    ),
                    counterStyle: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
              32.height(),

              // Send Challenge Button
              CustomButton(
                text: battleVm.isLoading ? "loading..." : "send challenge",
                bgColor: canSend
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).cardColor,

                onTap: canSend && !battleVm.isLoading
                    ? () async {
                        await battleVm.createBattle(
                          theme: theme,
                          caption: _captionController.text.isEmpty
                              ? null
                              : _captionController.text,
                          duration: _duration,
                          opponentUids: _selectedOpponents,
                        );

                        if (battleVm.hasError) {
                          Fluttertoast.showToast(
                            msg:
                                battleVm.errorMessage ??
                                "failed to create challenge",
                          );
                          return;
                        }

                        if (!mounted) return;

                        Fluttertoast.showToast(msg: 'Challenge sent! 🔥');

                        Navigator.pop(context);
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFriendPicker(BuildContext context, List<String> friendUids) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      builder: (_) => Container(
        height: 400,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Add Opponent',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Divider(color: Theme.of(context).textTheme.headlineMedium!.color),
            Expanded(
              child: ListView.builder(
                itemCount: friendUids.length,
                itemBuilder: (context, index) {
                  final uid = friendUids[index];
                  final isSelected = _selectedOpponents.contains(uid);

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                        'https://i.pravatar.cc/150?u=$uid',
                      ),
                    ),
                    title: Text(
                      'Friend $uid',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    trailing: isSelected
                        ? Icon(
                            Icons.check,
                            color: Theme.of(context).primaryColor,
                          )
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
          color: selected ? Theme.of(context).primaryColor : Colors.white10,
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
