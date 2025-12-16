import 'package:flutter/material.dart';
import 'package:glow_up/core/extensions.dart';

Widget emptyWidget(
  BuildContext context,
  String title,
  String subtitle, {
  IconData icon = Icons.photo_camera_front,
}) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: Theme.of(context).textTheme.titleLarge!.color!.lighten(),
          ),
          30.height(),
          Text(
            title.capitalize,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          16.height(),
          Text(
            subtitle.capitalize,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          40.height(),
          Icon(
            Icons.whatshot,
            size: 60,
            color: Theme.of(context).primaryColor.withOpacity(0.5),
          ),
        ],
      ),
    ),
  );
}
