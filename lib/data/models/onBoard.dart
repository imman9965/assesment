class OnBoardingModel {
  final String image;
  final String title;
  final String description;

  OnBoardingModel({
    required this.image,
    required this.title,
    required this.description,
  });
}


final List<OnBoardingModel> onboardingData = [
  OnBoardingModel(
    image: 'assets/splash_screens/onboarding0.png',
    title: "Welcome",
    description: "Don't cry because it's over, smile because it happened.",
  ),
  OnBoardingModel(
    image: 'assets/splash_screens/onboarding1.png',
    title: "Be Yourself",
    description: "Be yourself, everyone else is already taken.",
  ),
  OnBoardingModel(
    image: 'assets/splash_screens/onboarding2.png',
    title: "Knowledge",
    description: "So many books, so little time.",
  ),
  OnBoardingModel(
    image: 'assets/splash_screens/onboarding3.png',
    title: "Library",
    description: "A room without books is like a body without a soul.",
  ),
];