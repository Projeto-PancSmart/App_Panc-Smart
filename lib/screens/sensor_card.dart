import 'package:flutter/material.dart';

class SensorCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const SensorCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Container(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            // icon circle
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  color.withAlpha((0.95 * 255).round()),
                  color.withAlpha((0.6 * 255).round())
                ]),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: color.withAlpha((0.18 * 255).round()),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ],
              ),
              child: Icon(icon, size: 28, color: Colors.white),
            ),
            const SizedBox(width: 12),
            // values
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withAlpha((0.8 * 255).round()))),
                  const SizedBox(height: 6),
                  Text(value,
                      style: theme.textTheme.headlineSmall?.copyWith(
                          fontSize: 18, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            // small chevron action
            Icon(Icons.chevron_right,
                color:
                    theme.colorScheme.onSurface.withAlpha((0.4 * 255).round())),
          ],
        ),
      ),
    );
  }
}
