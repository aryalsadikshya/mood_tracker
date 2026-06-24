class OnboardingData {
  final String title;
  final String description;
  final String image;

  OnboardingData({
    required this.title,
    required this.description,
    required this.image,
  });
}

List<OnboardingData> onboardingPages = [
  OnboardingData(
    title: "Track Your Emotions",
    description: "Understand your feelings daily and discover patterns.",
    image: "assets/images/1onboarding.jpg",
  ),
  OnboardingData(
    title: "Build Healthy Habits",
    description: "Small reflections create meaningful growth.",
    image: "assets/images/2onboarding.jpg",
  ),
  OnboardingData(
    title: "Your Safe Space",
    description: "Journal, reflect, and care for your mind.",
    image: "assets/images/3onboarding.jpg",
  ),
];