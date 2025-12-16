import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:glow_up/core/extensions.dart';
import 'package:glow_up/models/post_model.dart';
import 'package:glow_up/providers/post_vm.dart';
import 'package:glow_up/providers/user_view_model.dart';
import 'package:glow_up/screens/leaderboard/leaderboard.dart';
import 'package:glow_up/screens/settings/notification.dart';
import 'package:glow_up/screens/settings/settings.dart';
import 'package:glow_up/widgets/custom_button.dart';
import 'package:glow_up/widgets/empty_state.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Theme.of(context).textTheme.titleLarge!.color,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.share,
              color: Theme.of(context).textTheme.titleLarge!.color,
            ),
            onPressed: null,
          ),
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Theme.of(context).textTheme.titleLarge!.color,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ActivityScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer2<UserViewModel, PostViewModel>(
        builder: (context, userVm, postVm, child) {
          final user = userVm.user;
          final myPosts = postVm.myPosts;

          if (user == null) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          }

          // Extract win dates from posts (or from user.winDates if you store them)
          final Set<DateTime> winDates = {};
          // Example: mark days with high fireCount as wins (replace with real logic)
          for (var post in myPosts) {
            if (post.fireCount > 100) {
              // or from daily_winners
              winDates.add(post.timestamp);
            }
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              // Profile Header
              Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: CircleAvatar(
                          radius: 48,
                          backgroundImage: user.profilePictureUrl != null
                              ? CachedNetworkImageProvider(
                                  user.profilePictureUrl!,
                                )
                              : null,
                          child: user.profilePictureUrl == null
                              ? Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Theme.of(
                                    context,
                                  ).textTheme.titleLarge!.color,
                                )
                              : null,
                        ),
                      ),
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                  16.height(),
                  Text(
                    '@${user.userName ?? 'username'}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    user.bio ?? 'Fashion enthusiast & daily battler',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  32.height(),

                  // Streak Card
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LeaderboardScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.whatshot,
                            color: Theme.of(context).primaryColor,
                            size: 48,
                          ),
                          8.height(),
                          Text(
                            '${user.streakCount} Days',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 32,
                                ),
                          ),
                          Text(
                            'ON FIRE',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  32.height(),

                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatCard(
                        context,
                        user.winDates.length > 999
                            ? '${(user.winDates.length / 1000).toStringAsFixed(1)}k'
                            : '${user.winDates.length}',
                        'WINS',
                      ),
                      _buildStatCard(
                        context,
                        user.battles > 999
                            ? '${(user.battles / 1000).toStringAsFixed(1)}k'
                            : '${user.battles}',
                        'BATTLES',
                      ),
                      _buildStatCard(
                        context,
                        user.votes > 999
                            ? '${(user.votes / 1000).toStringAsFixed(1)}k'
                            : '${user.votes}',
                        'VOTES',
                      ),
                    ],
                  ),
                  40.height(),

                  // Trophy Room Calendar
                  Row(
                    children: [
                      Icon(
                        Icons.emoji_events,
                        color: Theme.of(context).primaryColor,
                        size: 28,
                      ),
                      8.width(),
                      Text(
                        'Trophy Room',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const Spacer(),
                      DropdownButton<String>(
                        value: 'December',
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Theme.of(context).textTheme.titleLarge!.color,
                        ),
                        dropdownColor: Theme.of(context).cardColor,
                        underline: Container(),
                        style: Theme.of(context).textTheme.titleLarge,
                        items: ['October', 'November', 'December']
                            .map(
                              (month) => DropdownMenuItem(
                                value: month,
                                child: Text(
                                  month,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (_) {},
                      ),
                    ],
                  ),
                  16.height(),

                  TableCalendar(
                    firstDay: DateTime.utc(2025, 10, 1),
                    lastDay: DateTime.utc(2025, 12, 31),
                    focusedDay: DateTime.now(),
                    calendarFormat: CalendarFormat.month,
                    headerVisible: false,
                    daysOfWeekHeight: 40,
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: Theme.of(context).textTheme.titleMedium!,
                      weekendStyle: Theme.of(context).textTheme.titleMedium!,
                    ),
                    calendarStyle: CalendarStyle(
                      defaultTextStyle: Theme.of(
                        context,
                      ).textTheme.titleMedium!,
                      weekendTextStyle: Theme.of(
                        context,
                      ).textTheme.titleMedium!,
                      outsideTextStyle: const TextStyle(color: Colors.white30),
                      todayDecoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        ),
                      ),
                      todayTextStyle: Theme.of(context).textTheme.titleMedium!,
                    ),
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, focusedDay) {
                        final hasPost = myPosts.any(
                          (post) =>
                              post.timestamp.year == day.year &&
                              post.timestamp.month == day.month &&
                              post.timestamp.day == day.day,
                        );

                        final postOnDay = myPosts.firstWhere(
                          (post) =>
                              post.timestamp.year == day.year &&
                              post.timestamp.month == day.month &&
                              post.timestamp.day == day.day,
                          orElse: () => PostModel(
                            id: "",
                            userId: "",
                            imageUrl: "",
                            timestamp: DateTime.now(),
                          ),
                        );

                        if (!hasPost || postOnDay.id.isEmpty) {
                          return Center(
                            child: Text(
                              '${day.day}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          );
                        }

                        return Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: CachedNetworkImageProvider(
                                  postOnDay.imageUrl,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  50.height(),

                  // New Battle Button
                  CustomButton(
                    text: "new battle",
                    onTap: () {
                      // Navigate to Battle tab (or open create battle)
                    },
                  ),

                  20.height(),

                  // Gallery View Below
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Gallery',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  16.height(),

                  myPosts.isEmpty
                      ? emptyWidget(
                          context,
                          "No posts yet",
                          "Start posting daily fits to build your gallery!",
                          icon: Icons.photo_library,
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 0.8,
                              ),
                          itemCount: myPosts.length,
                          itemBuilder: (context, index) {
                            final post = myPosts[index];
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: post.imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    Container(color: Colors.white10),
                              ),
                            );
                          },
                        ),

                  40.height(),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

Widget _buildStatCard(BuildContext context, String value, String label) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      children: [
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontSize: 28),
        ),
        Text(label, style: Theme.of(context).textTheme.titleSmall),
      ],
    ),
  );
}
