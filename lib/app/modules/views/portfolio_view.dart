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
  late TabController _tabController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late ScrollController _scrollController;

  final List<GlobalKey> _sectionKeys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _scrollController = ScrollController();
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
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(int index) {
    final context = _sectionKeys[index].currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f172a),
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    _buildHeader(),
                    Container(key: _sectionKeys[0], child: _buildAbout()),
                    Container(key: _sectionKeys[1], child: _buildSkills()),
                    Container(key: _sectionKeys[2], child: _buildExperience()),
                    Container(key: _sectionKeys[3], child: _buildProjects()),
                  ],
                ),
              ),
            ),
          ),
          _buildWatermark(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF1e293b),
      elevation: 0,
      title: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 800),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: const Text(
              'Shivam Agrawal',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: const Color(0xFF60a5fa),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        onTap: _scrollToSection,
        tabs: const [
          Tab(text: 'About'),
          Tab(text: 'Skills'),
          Tab(text: 'Experience'),
          Tab(text: 'Projects'),
        ],
      ),
      actions: [
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1000),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Get.back(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildWatermark() {
    return Positioned(
      bottom: 20,
      right: 20,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 1500),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Opacity(
            opacity: value * 0.6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF60a5fa).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: const Text(
                '© Shivam Agrawal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildContactIcon(Icons.email, 'mailto:shivamcsaiet316@gmail.com', 0),
                    _buildContactIcon(Icons.phone, 'tel:+919057448064', 100),
                    _buildContactIcon(Icons.work, 'https://www.linkedin.com/in/shivam20797', 200),
                    _buildContactIcon(Icons.web, 'https://shivam20797.github.io/web-app/', 300),
                  ],
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

  Widget _buildContactIcon(IconData icon, String url, int delay) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: InkWell(
              onTap: () => _launchUrl(url),
              borderRadius: BorderRadius.circular(25),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sidebar
              Expanded(
                flex: 1,
                child: _buildSkillsSidebar(),
              ),
              const SizedBox(width: 30),
              // Main Skills Grid
              Expanded(
                flex: 2,
                child: _buildSkillsGrid(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSidebar() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(-30 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: Column(
              children: [
                // Contact Section
                _buildModernContactCard(),
                const SizedBox(height: 20),
                // Skills Categories
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0f172a),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF60a5fa).withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Skill Categories',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF60a5fa),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildSkillCategory('Mobile Development', Icons.phone_android, [
                        'Kotlin', 'Java', 'Dart', 'Android SDK'
                      ]),
                      _buildSkillCategory('Architecture', Icons.architecture, [
                        'MVVM', 'Clean Architecture'
                      ]),
                      _buildSkillCategory('Backend & APIs', Icons.api, [
                        'Retrofit', 'Firebase', 'REST APIs'
                      ]),
                      _buildSkillCategory('Database', Icons.storage, [
                        'Room', 'SQLite'
                      ]),
                      _buildSkillCategory('Tools & Services', Icons.build, [
                        'Android Studio', 'Git', 'OneSignal'
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernContactCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF60a5fa), Color(0xFF3b82f6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF60a5fa).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Let\'s Connect',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildModernContactItem(
            Icons.email_rounded,
            'shivamcsaiet316@gmail.com',
            'mailto:shivamcsaiet316@gmail.com',
          ),
          _buildModernContactItem(
            Icons.phone_rounded,
            '+91 9057448064',
            'tel:+919057448064',
          ),
          _buildModernContactItem(
            Icons.work_rounded,
            'LinkedIn Profile',
            'https://www.linkedin.com/in/shivam20797',
          ),
          _buildModernContactItem(
            Icons.web_rounded,
            'Portfolio Website',
            'https://shivam20797.github.io/web-app/',
          ),
        ],
      ),
    );
  }

  Widget _buildModernContactItem(IconData icon, String text, String url) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _launchUrl(url),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkillCategory(String title, IconData icon, List<String> skills) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: const Color(0xFF60a5fa)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...skills.map((skill) => Padding(
            padding: const EdgeInsets.only(left: 24, bottom: 4),
            child: Text(
              '• $skill',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF94a3b8),
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildSkillsGrid() {
    return Wrap(
      spacing: 15,
      runSpacing: 15,
      children: [
        _buildAnimatedSkillCard(Icons.android, 'Kotlin', 'Native Android', 0),
        _buildAnimatedSkillCard(Icons.code, 'Java', 'Object-Oriented', 100),
        _buildAnimatedSkillCard(Icons.flutter_dash, 'Dart', 'Flutter Framework', 200),
        _buildAnimatedSkillCard(Icons.architecture, 'MVVM', 'Architecture Pattern', 300),
        _buildAnimatedSkillCard(Icons.api, 'Retrofit', 'REST API Client', 400),
        _buildAnimatedSkillCard(Icons.cloud, 'Firebase', 'Backend Services', 500),
        _buildAnimatedSkillCard(Icons.storage, 'Room', 'Local Database', 600),
        _buildAnimatedSkillCard(Icons.developer_mode, 'Android Studio', 'IDE', 700),
      ],
    );
  }

  Widget _buildAnimatedSkillCard(IconData icon, String title, String subtitle, int delay) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: _FlipCard(
            icon: icon,
            title: title,
            subtitle: subtitle,
          ),
        );
      },
    );
  }
}

class _FlipCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FlipCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  State<_FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<_FlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flip() {
    if (_isFlipped) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    _isFlipped = !_isFlipped;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flip,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final isShowingFront = _animation.value < 0.5;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(_animation.value * 3.14159),
            child: Container(
              width: 140,
              height: 120,
              decoration: BoxDecoration(
                color: isShowingFront
                    ? const Color(0xFF0f172a)
                    : const Color(0xFF60a5fa),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF60a5fa),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF60a5fa).withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: isShowingFront
                  ? _buildFrontCard()
                  : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(3.14159),
                      child: _buildBackCard(),
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFrontCard() {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(widget.icon, size: 28, color: const Color(0xFF60a5fa)),
          const SizedBox(height: 6),
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            widget.subtitle,
            style: const TextStyle(
              fontSize: 9,
              color: Color(0xFF94a3b8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBackCard() {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.star, size: 28, color: Colors.white),
          const SizedBox(height: 6),
          const Text(
            'Expert Level',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            '5+ Years Experience',
            style: TextStyle(
              fontSize: 9,
              color: Colors.white.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
            'Application Development Team Lead',
            'Appentus Technologies',
            'Nov 2019 - Oct 2025',
            'A results-oriented Senior Team Lead – Android & Flutter Developer with over 5 years of experience designing, developing, and deploying scalable mobile applications. Skilled in Kotlin, Java, and Flutter, with hands-on expertise in MVVM architecture, RESTful APIs, Firebase, and Play Store deployment.',
            0,
          ),
          _buildAnimatedExperienceCard(
            'Android Developer',
            'iSkylar Technologies',
            'Mar 2019 - Nov 2019',
            'Worked as an Android Developer, focusing on learning core Android development concepts and building small-scale applications using Java. Developed and maintained 2 Android projects, gaining hands-on experience in UI design, activity lifecycle management, and API integration.',
            200,
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedExperienceCard(String role, String company, String duration, String description, int delay) {
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
              _buildAnimatedProjectCard('E-Commerce App', 'Kotlin + MVVM + Room', Icons.shopping_cart, 0),
              _buildAnimatedProjectCard('Chat App', 'Flutter + Firebase', Icons.chat, 200),
              _buildAnimatedProjectCard('Weather App', 'Android + Retrofit', Icons.wb_sunny, 400),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedProjectCard(String title, String tech, IconData icon, int delay) {
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
                  color: const Color(0xFF60a5fa).withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
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

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}