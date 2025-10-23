import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class PortfolioView extends StatefulWidget {
  const PortfolioView({super.key});

  @override
  State<PortfolioView> createState() => _PortfolioViewState();
}

class _PortfolioViewState extends State<PortfolioView>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f172a),
      body: SingleChildScrollView(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                _buildHeader(),
                _buildAbout(),
                _buildSkills(),
                _buildExperience(),
                _buildProjects(),
                _buildContact(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1200),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            padding: const EdgeInsets.all(40),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1e293b), Color(0xFF334155)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Hero(
                  tag: 'profile',
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF60a5fa).withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 60,
                      backgroundColor: Color(0xFF60a5fa),
                      child: Icon(Icons.person, size: 60, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Shivam Agrawal',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Application Developer | Mobile Expert',
                  style: TextStyle(fontSize: 20, color: Color(0xFF94a3b8)),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  children: [
                    _buildAnimatedSkillChip('Kotlin', 0),
                    _buildAnimatedSkillChip('Flutter', 200),
                    _buildAnimatedSkillChip('Android', 400),
                    _buildAnimatedSkillChip('Firebase', 600),
                    _buildAnimatedSkillChip('MVVM', 800),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedSkillChip(String skill, int delay) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Chip(
            label: Text(skill),
            backgroundColor: const Color(0xFF60a5fa),
            labelStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAbout() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                const Text(
                  'About Me',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF60a5fa),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Experienced Android and Flutter Developer with a track record of delivering 30+ mobile apps using Kotlin, Java, and Flutter. Proficient in MVVM architecture, RESTful APIs, Firebase, and Play Store deployment. Adept at fostering collaboration across teams to produce high-quality, scalable Android solutions with optimal performance and sleek UI/UX design. Recognized for strong skills in app development and a proven ability to meet project deadlines effectively.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFf8fafc),
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAnimatedStatCard('6+', 'Years Experience', 0),
                    _buildAnimatedStatCard('30+', 'Apps Built', 200),
                    _buildAnimatedStatCard('12+', 'Technologies', 400),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedStatCard(String number, String label, int delay) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1e293b),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    number,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF60a5fa),
                    ),
                  ),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF94a3b8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSkills() {
    return Container(
      padding: const EdgeInsets.all(40),
      color: const Color(0xFF1e293b),
      child: Column(
        children: [
          const Text(
            'Technical Skills',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF60a5fa),
            ),
          ),
          const SizedBox(height: 30),
          Wrap(
            spacing: 15,
            runSpacing: 15,
            children: [
              _buildAnimatedSkillCard(
                Icons.android,
                'Kotlin',
                'Native Android',
                0,
              ),
              _buildAnimatedSkillCard(
                Icons.code,
                'Java',
                'Object-Oriented',
                100,
              ),
              _buildAnimatedSkillCard(
                Icons.architecture,
                'MVVM',
                'Architecture Pattern',
                200,
              ),
              _buildAnimatedSkillCard(
                Icons.flutter_dash,
                'Dart',
                'Flutter Framework',
                300,
              ),
              _buildAnimatedSkillCard(
                Icons.android,
                'Android SDK',
                'Development Kit',
                400,
              ),
              _buildAnimatedSkillCard(
                Icons.api,
                'Retrofit',
                'REST API Client',
                500,
              ),
              _buildAnimatedSkillCard(
                Icons.storage,
                'Room',
                'Local Database',
                600,
              ),
              _buildAnimatedSkillCard(
                Icons.build_circle,
                'Dagger',
                'Dependency Injection',
                700,
              ),
              _buildAnimatedSkillCard(
                Icons.cloud,
                'Firebase',
                'Backend Services',
                800,
              ),
              _buildAnimatedSkillCard(
                Icons.notifications,
                'OneSignal',
                'Push Notifications',
                900,
              ),
              _buildAnimatedSkillCard(
                Icons.map,
                'Google Maps',
                'Location Services',
                1000,
              ),
              _buildAnimatedSkillCard(
                Icons.developer_mode,
                'Android Studio',
                'IDE',
                1100,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedSkillCard(
    IconData icon,
    String title,
    String subtitle,
    int delay,
  ) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: MouseRegion(
            onEnter: (_) {},
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 160,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0f172a),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF60a5fa), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF60a5fa).withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(icon, size: 32, color: const Color(0xFF60a5fa)),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF94a3b8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildExperience() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          const Text(
            'Work Experience',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF60a5fa),
            ),
          ),
          const SizedBox(height: 30),
          _buildAnimatedExperienceCard(
            'Senior Application Developer',
            'Tech Solutions Ltd',
            'Jan 2022 - Present',
            'Lead mobile app development using Kotlin, Flutter, MVVM, and Firebase',
            0,
          ),
          _buildAnimatedExperienceCard(
            'Application Developer',
            'Mobile Innovations',
            'Jun 2020 - Dec 2021',
            'Developed cross-platform apps with Dart, REST APIs, and Play Store deployment',
            200,
          ),
          _buildAnimatedExperienceCard(
            'Junior Application Developer',
            'Digital StartUp',
            'Jan 2018 - May 2020',
            'Built Android applications using Java, Android SDK, and modern UI/UX patterns',
            400,
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedExperienceCard(
    String role,
    String company,
    String duration,
    String description,
    int delay,
  ) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(50 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1e293b),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '$company • $duration',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF60a5fa),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF94a3b8),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProjects() {
    return Container(
      padding: const EdgeInsets.all(40),
      color: const Color(0xFF1e293b),
      child: Column(
        children: [
          const Text(
            'Featured Projects',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF60a5fa),
            ),
          ),
          const SizedBox(height: 30),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _buildAnimatedProjectCard(
                'E-Commerce App',
                'Kotlin + MVVM + Room',
                Icons.shopping_cart,
                0,
              ),
              _buildAnimatedProjectCard(
                'Chat App',
                'Flutter + Firebase',
                Icons.chat,
                200,
              ),
              _buildAnimatedProjectCard(
                'Weather App',
                'Android + Retrofit',
                Icons.wb_sunny,
                400,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedProjectCard(
    String title,
    String tech,
    IconData icon,
    int delay,
  ) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: 200,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF0f172a),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF60a5fa).withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(icon, size: 40, color: const Color(0xFF60a5fa)),
                const SizedBox(height: 15),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  tech,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF94a3b8),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContact() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                const Text(
                  'Get In Touch',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF60a5fa),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildContactButton(
                      Icons.email,
                      'Email',
                      'mailto:agarwalsatyam027@gmail.com',
                    ),
                    _buildContactButton(
                      Icons.phone,
                      'Call',
                      'tel:+918058083031',
                    ),
                    _buildContactButton(
                      Icons.work,
                      'LinkedIn',
                      'https://www.linkedin.com/in/satyam-a-a36b3217b',
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back to App'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF60a5fa),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContactButton(IconData icon, String label, String url) {
    return ElevatedButton.icon(
      onPressed: () => _launchUrl(url),
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1e293b),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
