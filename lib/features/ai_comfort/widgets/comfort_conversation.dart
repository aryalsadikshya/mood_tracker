import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colours.dart';
import '../models/comfort_message.dart';

class ComfortConversation extends StatelessWidget {
  final List<ComfortMessage> messages;
  final bool isThinking;
  final ScrollController scrollController;

  const ComfortConversation({
    super.key,
    required this.messages,
    required this.isThinking,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (messages.isEmpty && !isThinking) {
      return _EmptyConversation(isDark: isDark);
    }

    return Container(
      constraints: const BoxConstraints(
        maxHeight: 360,
      ),
      child: ListView.builder(
        controller: scrollController,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: messages.length + (isThinking ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == messages.length && isThinking) {
            return const _ThinkingBubble();
          }

          final message = messages[index];

          return _MessageBubble(
            message: message,
          );
        },
      ),
    );
  }
}

class _EmptyConversation extends StatelessWidget {
  final bool isDark;

  const _EmptyConversation({
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
            AppColors.nightCardSoft,
            AppColors.nightCard,
            AppColors.nightBackground,
          ]
              : const [
            AppColors.mint,
            AppColors.paleBlue,
            AppColors.blush,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark
              ? AppColors.nightBorder
              : Colors.white.withOpacity(0.9),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "🧸",
            style: TextStyle(fontSize: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Hi, I’m your little calm companion. Tell me what is on your mind.",
              style: GoogleFonts.poppins(
                fontSize: 14,
                height: 1.65,
                color: isDark
                    ? AppColors.nightText
                    : AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ComfortMessage message;

  const _MessageBubble({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isUser = message.role == ComfortMessageRole.user;

    return Align(
      alignment: isUser
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 290,
        ),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? isDark
              ? AppColors.nightBlue
              : AppColors.deepBlue
              : isDark
              ? AppColors.nightCardSoft
              : AppColors.paleBlue,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(22),
            topRight: const Radius.circular(22),
            bottomLeft: Radius.circular(
              isUser ? 22 : 6,
            ),
            bottomRight: Radius.circular(
              isUser ? 6 : 22,
            ),
          ),
          border: Border.all(
            color: isUser
                ? Colors.transparent
                : isDark
                ? AppColors.nightBorder
                : Colors.white.withOpacity(0.85),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser) ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "🧸",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    "Calm Companion",
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.nightBlue
                          : AppColors.deepBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),
            ],
            Text(
              message.text,
              style: GoogleFonts.poppins(
                fontSize: 13.5,
                height: 1.55,
                color: isUser
                    ? Colors.white
                    : isDark
                    ? AppColors.nightText
                    : AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _formatTime(message.createdAt),
              style: GoogleFonts.poppins(
                fontSize: 9.5,
                fontWeight: FontWeight.w500,
                color: isUser
                    ? Colors.white.withOpacity(0.72)
                    : isDark
                    ? AppColors.nightTextSoft.withOpacity(0.72)
                    : AppColors.textSoft.withOpacity(0.72),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12
        ? dateTime.hour - 12
        : dateTime.hour == 0
        ? 12
        : dateTime.hour;

    final minute = dateTime.minute.toString().padLeft(2, "0");
    final period = dateTime.hour >= 12 ? "PM" : "AM";

    return "$hour:$minute $period";
  }
}

class _ThinkingBubble extends StatefulWidget {
  const _ThinkingBubble();

  @override
  State<_ThinkingBubble> createState() => _ThinkingBubbleState();
}

class _ThinkingBubbleState extends State<_ThinkingBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 900,
      ),
    )..repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.nightCardSoft
              : AppColors.paleBlue,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
            bottomLeft: Radius.circular(6),
            bottomRight: Radius.circular(22),
          ),
          border: Border.all(
            color: isDark
                ? AppColors.nightBorder
                : Colors.white.withOpacity(0.85),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "🧸",
              style: TextStyle(fontSize: 19),
            ),
            const SizedBox(width: 10),
            AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                final value = animationController.value;

                return Row(
                  children: List.generate(
                    3,
                        (index) {
                      final threshold = index / 3;
                      final active =
                          (value - threshold).abs() < 0.25;

                      return AnimatedContainer(
                        duration: const Duration(
                          milliseconds: 180,
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 2,
                        ),
                        height: active ? 8 : 5,
                        width: active ? 8 : 5,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.nightBlue
                              : AppColors.deepBlue,
                          shape: BoxShape.circle,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}