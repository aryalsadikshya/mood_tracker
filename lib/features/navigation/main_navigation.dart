import 'package:flutter/material.dart';
import '../../core/navigation/soft_page_route.dart';
import '../../core/theme/app_colours.dart';
import '../home/screens/home_screen.dart';
import '../mood/screen/journal_screen.dart';
import '../profile/profile_screen.dart';
import '../mood/screen/add_mood_screen.dart';
import '../insights/insights_screen.dart';
import '../wellness/wellness_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../settings/screens/notification_permission_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentIndex = 0;

  final List<Widget> screens = [
    const HomeScreen(),
    const JournalScreen(),
    const InsightsScreen(),
    const WellnessScreen(),
    const ProfileScreen(),

  ];

  @override
  void initState() {
    super.initState();
    askNotificationOnce();
  }

  Future<void> askNotificationOnce() async {
    final prefs = await SharedPreferences.getInstance();
    final alreadyAsked = prefs.getBool("askedNotificationPermission") ?? false;

    if (alreadyAsked) return;

    await prefs.setBool("askedNotificationPermission", true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      openSoftPage(
        context,
        const NotificationPermissionScreen(),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: screens[currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: currentIndex == 0
          ? const _BreathingFab()
          : null,

      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.whiteGlass,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withOpacity(0.9)),
          boxShadow: [
            BoxShadow(
              color: AppColors.softPurple.withOpacity(0.2),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },

            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,

            selectedItemColor: AppColors.lakeBlue,
            unselectedItemColor: AppColors.textSoft,

            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontSize: 12),

            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book_rounded),
                label: "Journal",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.insights_rounded),
                label: "Insights",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.spa_rounded),
                label: "Wellness",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _BreathingFab extends StatefulWidget {
  const _BreathingFab();

  @override
  State<_BreathingFab> createState() => _BreathingFabState();
}

class _BreathingFabState extends State<_BreathingFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulse = Tween<double>(begin: 1.0, end: 1.18).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void openAddMood() {
    openSoftPage(
      context,
      const AddMoodScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, child) {
        return Transform.translate(
          offset: const Offset(0, -12),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.scale(
                scale: _pulse.value,
                child: Container(
                  height: 76,
                  width: 76,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.lakeBlue.withOpacity(0.18),
                  ),
                ),
              ),

              Transform.scale(
                scale: _pulse.value * 1.08,
                child: Container(
                  height: 92,
                  width: 92,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.lakeBlue.withOpacity(0.09),
                  ),
                ),
              ),

              FloatingActionButton(
                elevation: 0,
                backgroundColor: AppColors.lakeBlue,
                foregroundColor: Colors.white,
                onPressed: openAddMood,
                child: const Icon(Icons.add_rounded, size: 34),
              ),
            ],
          ),
        );
      },
    );
  }
}