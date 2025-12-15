import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:glow_up/core/extensions.dart';
import 'package:glow_up/widgets/custom_button.dart';
import 'package:table_calendar/table_calendar.dart'; // pubspec: table_calendar: ^3.0.9

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  // Dummy past posts for Trophy Room calendar
  final List<DateTime> _winDates = [
    DateTime(2025, 12, 1),
    DateTime(2025, 12, 3),
    DateTime(2025, 12, 5),
    DateTime(2025, 12, 6),
    DateTime(2025, 12, 11),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Theme.of(context).textTheme.titleMedium!.color,
            ),
            onPressed: null,
          ),
          IconButton(
            icon: Icon(
              Icons.share,
              color: Theme.of(context).textTheme.titleMedium!.color,
            ),
            onPressed: null,
          ),
          // IconButton(
          //   icon: Icon(Icons.edit, color: Theme.of(context).textTheme.titleMedium!.color),
          //   onPressed: null,
          // ),
        ],
      ),
      body: ListView(
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
                    child: const CircleAvatar(
                      radius: 48,
                      backgroundImage: CachedNetworkImageProvider(
                        'https://via.placeholder.com/150',
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '@StyleQueen',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const Text(
                'Fashion enthusiast & daily battler',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 32),

              // Streak Card
              Container(
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
                    const SizedBox(height: 8),
                    Text(
                      '12 Days',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontSize: 32,
                          ),
                    ),
                    Text(
                      'ON FIRE',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Stats Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatCard(context, '45', 'WINS'),
                  _buildStatCard(context, '102', 'BATTLES'),
                  _buildStatCard(context, '12k', 'VOTES'),
                ],
              ),
              const SizedBox(height: 40),

              // Trophy Room Calendar
              Row(
                children: [
                  Icon(
                    Icons.emoji_events,
                    color: Theme.of(context).primaryColor,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Trophy Room',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Spacer(),
                  DropdownButton<String>(
                    value: 'December',
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white70,
                    ),
                    dropdownColor: Colors.grey[900],
                    underline: Container(),
                    style: const TextStyle(color: Colors.white),
                    items: ['October', 'November', 'December'].map((
                      String month,
                    ) {
                      return DropdownMenuItem<String>(
                        value: month,
                        child: Text(month),
                      );
                    }).toList(),
                    onChanged: (_) {},
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TableCalendar(
                firstDay: DateTime.utc(2025, 10, 1),
                lastDay: DateTime.utc(2025, 12, 31),
                focusedDay: DateTime.now(),
                calendarFormat: CalendarFormat.month,
                headerVisible: false,
                daysOfWeekHeight: 40,
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.white70),
                  weekendStyle: TextStyle(color: Colors.white70),
                ),
                calendarStyle: CalendarStyle(
                  defaultTextStyle: const TextStyle(color: Colors.white70),
                  weekendTextStyle: const TextStyle(color: Colors.white70),
                  outsideTextStyle: const TextStyle(color: Colors.white30),
                  todayDecoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                  todayTextStyle: const TextStyle(color: Colors.white),
                ),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    final hasWin = _winDates.any(
                      (d) => d.day == day.day && d.month == day.month,
                    );
                    if (!hasWin) {
                      return Center(
                        child: Text(
                          '${day.day}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      );
                    }
                    return Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            backgroundImage: CachedNetworkImageProvider(
                              'https://via.placeholder.com/80',
                            ), // Replace with actual win photo
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

              const SizedBox(height: 50),

              // New Battle Button
              CustomButton(
                text: "new battle",
                onTap: () {
                  //Change tab to battle
                },
              ),

              20.height(),

              // Gallery View Below (All Past Posts)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Gallery',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.8,
                ),
                itemCount: 15, // Dummy count
                itemBuilder: (context, index) {
                  // Use real URLs in production
                  final urls = [
                    'https://assets.vogue.com/photos/616062ff816ea2de6ec85809/master/w_2560%2Cc_limit/00_story.jpg',
                    'https://media.istockphoto.com/id/2161831582/photo/portrait-of-luxury-modern-woman-in-new-york-city.jpg?s=612x612&w=0&k=20&c=Xa9jp15HVew7wxFRYxXTJB6bl-rNBCFbj2JFV8miPzo=',
                    'https://media.istockphoto.com/id/1489381517/photo/portrait-of-gorgeous-brunette-woman-standing-city-street-fashion-model-wears-black-leather.jpg?s=612x612&w=0&k=20&c=Ji-vXNMVdjtgiO0ZH1B5d5BbIhmpwngkhx1u4QaiG1g=',
                    'http://www.panaprium.com/cdn/shop/articles/different_fashion_styles_up_f6d5fe49-b92d-4840-bb1d-c57b86907c27.jpg?v=1760958147&width=1024',
                    'https://www.panaprium.com/cdn/shop/articles/how_dress_badass_girl_1000.jpg?v=1664341397',
                    'https://photos.peopleimages.com/picture/202211/2539340-fashion-style-and-woman-on-rooftop-in-city-with-stylish-trendy-and-modern-outfit.-summer-freedom-and-carefree-girl-in-town-with-creative-cool-and-designer-clothes-on-weekend-by-urban-building-fit_400_400.jpg',
                    'https://www.shutterstock.com/image-photo/full-length-fashionable-blonde-woman-260nw-2450203741.jpg',
                    'https://foxylabny.com/wp-content/uploads/2025/08/unnamed-2-1-1024x574.webp',
                    'https://c8.alamy.com/comp/3A51KWH/portrait-of-an-african-american-woman-standing-with-hands-on-hips-looking-away-in-an-urban-streetscape-a-trendy-street-style-scene-with-a-bold-colorful-outfit-and-modern-fashion-vibe-ideal-for-lifestyle-and-fashion-campaigns-3A51KWH.jpg',
                    'https://cdn.mos.cms.futurecdn.net/TDqFXPmU8KXtvVQCeBAbi9.jpg',
                    'https://www.shutterstock.com/image-photo/full-body-young-happy-man-260nw-2574530679.jpg',
                    'https://gentwith.com/wp-content/uploads/2021/02/10-Men%E2%80%99s-Style-Tips-To-Look-Powerful.jpg',
                    'https://i.ytimg.com/vi/dyGZhARaSYg/maxresdefault.jpg',
                    'https://americantall.com/cdn/shop/articles/Denim-Style-Guide-Banner.jpg?v=1696359361',
                    'https://m.media-amazon.com/images/S/aplus-media-library-service-media/ebbab5a5-f399-421b-8f91-d3d26cfd5fe5.__CR0,0,600,450_PT0_SX600_V1___.jpg',
                  ];
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(urls[index % urls.length]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
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
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
