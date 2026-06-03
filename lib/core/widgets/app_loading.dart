import 'package:flutter/material.dart';

import '../theme/app_colours.dart';

class AppLoading extends StatelessWidget {
  final String? message;

  const AppLoading({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            color: AppColors.lakeBlue,
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}