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
    GlobalKey(),
    GlobalKey(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
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

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
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
                    Container(key: _sectionKeys[4], child: _buildEducation()),
                    Container(key: _sectionKeys[5], child: _buildLanguages()),
                    _buildContact(),
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
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
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
        isScrollable: true,
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        tabs: const [
          Tab(text: 'About'),
          Tab(text: 'Skills'),
          Tab(text: 'Experience'),
          Tab(text: 'Projects'),
          Tab(text: 'Education'),
          Tab(text: 'Languages'),
          Tab(text: 'Contact'),
        ],
      ),

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = constraints.maxWidth > 1200;
        final isTablet = constraints.maxWidth > 768 && constraints.maxWidth <= 1200;
        final isMobile = constraints.maxWidth <= 768;

        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1200),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                padding: EdgeInsets.all(isWeb ? 40 : (isTablet ? 30 : 20)),
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
                        child: TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 2000),
                          tween: Tween(begin: 0.0, end: 1.0),
                          builder: (context, animValue, child) {
                            return Transform.rotate(
                              angle: animValue * 0.1,
                              child: CircleAvatar(
                                radius: isWeb ? 60 : (isTablet ? 50 : 40),
                                backgroundColor: const Color(0xFF60a5fa),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        const Color(0xFF60a5fa),
                                        const Color(0xFF3b82f6),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.smart_toy,
                                    size: isWeb ? 60 : (isTablet ? 50 : 40),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: isWeb ? 20 : 15),
                    Text(
                      'Shivam Agrawal',
                      style: TextStyle(
                        fontSize: isWeb ? 36 : (isTablet ? 28 : 24),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isWeb ? 10 : 8),
                    Text(
                      'Application Developer | Mobile Expert',
                      style: TextStyle(
                        fontSize: isWeb ? 20 : (isTablet ? 16 : 14),
                        color: const Color(0xFF94a3b8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isWeb ? 20 : 15),
                    if (isMobile)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildContactIcon(Icons.email, 'mailto:shivamcsaiet316@gmail.com', 0),
                          _buildContactIcon(Icons.phone, 'tel:+919057448064', 100),
                          _buildContactIcon(Icons.work, 'https://www.linkedin.com/in/shivam20797', 200),
                          _buildContactIcon(Icons.web, 'https://shivam20797.github.io/web-app/', 300),
                        ],
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildContactIcon(Icons.email, 'mailto:shivamcsaiet316@gmail.com', 0),
                          _buildContactIcon(Icons.phone, 'tel:+919057448064', 100),
                          _buildContactIcon(Icons.work, 'https://www.linkedin.com/in/shivam20797', 200),
                          _buildContactIcon(Icons.web, 'https://shivam20797.github.io/web-app/', 300),
                        ],
                      ),
                    SizedBox(height: isWeb ? 20 : 15),
                    Wrap(
                      spacing: isWeb ? 10 : 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildAnimatedSkillChip('Kotlin', 0),
                        _buildAnimatedSkillChip('Flutter', 200),
                        _buildAnimatedSkillChip('Android', 400),
                        _buildAnimatedSkillChip('Firebase', 600),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
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
                child: Icon(icon, color: Colors.white, size: 20),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = constraints.maxWidth > 1200;
        final isTablet = constraints.maxWidth > 768 && constraints.maxWidth <= 1200;
        final isMobile = constraints.maxWidth <= 768;

        return Container(
          padding: EdgeInsets.all(isWeb ? 40 : (isTablet ? 30 : 20)),
          child: Column(
            children: [
              Text(
                'About Me',
                style: TextStyle(
                  fontSize: isWeb ? 28 : (isTablet ? 24 : 20),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF60a5fa),
                ),
              ),
              SizedBox(height: isWeb ? 30 : 20),
              if (isMobile)
                Column(
                  children: [
                    _buildProfileSidebar(),
                    const SizedBox(height: 20),
                    _buildAboutContent(),
                  ],
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: isWeb ? 1 : 2, child: _buildProfileSidebar()),
                    SizedBox(width: isWeb ? 30 : 20),
                    Expanded(flex: isWeb ? 2 : 3, child: _buildAboutContent()),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileSidebar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = MediaQuery.of(context).size.width > 1200;
        final isTablet = MediaQuery.of(context).size.width > 768 && MediaQuery.of(context).size.width <= 1200;
        
        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 800),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(-30 * (1 - value), 0),
              child: Opacity(
                opacity: value,
                child: Container(
                  padding: EdgeInsets.all(isWeb ? 24 : (isTablet ? 20 : 16)),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1e293b), Color(0xFF334155)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF60a5fa).withOpacity(0.3)),
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
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 2000),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, animValue, child) {
                          return Transform.rotate(
                            angle: animValue * 0.1,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF60a5fa).withOpacity(0.4),
                                    blurRadius: 25,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: isWeb ? 50 : (isTablet ? 40 : 35),
                                backgroundColor: const Color(0xFF60a5fa),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF60a5fa), Color(0xFF3b82f6)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.smart_toy,
                                    size: isWeb ? 50 : (isTablet ? 40 : 35),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: isWeb ? 20 : 15),
                      _buildQuickStats(),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildQuickStats() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = MediaQuery.of(context).size.width > 1200;
        final isTablet = MediaQuery.of(context).size.width > 768 && MediaQuery.of(context).size.width <= 1200;
        
        return Column(
          children: [
            _buildStatRow(Icons.work_outline, '6+ Years', 'Experience', 0),
            SizedBox(height: isWeb ? 12 : 8),
            _buildStatRow(Icons.apps, '30+ Apps', 'Delivered', 200),
            SizedBox(height: isWeb ? 12 : 8),
            _buildStatRow(Icons.code, '15+ Tech', 'Stack', 400),
          ],
        );
      },
    );
  }

  Widget _buildStatRow(IconData icon, String number, String label, int delay) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(20 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF60a5fa).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 16, color: const Color(0xFF60a5fa)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        number,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF94a3b8),
                        ),
                      ),
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

  Widget _buildAboutContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = MediaQuery.of(context).size.width > 1200;
        final isTablet = MediaQuery.of(context).size.width > 768 && MediaQuery.of(context).size.width <= 1200;
        
        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1000),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(30 * (1 - value), 0),
              child: Opacity(
                opacity: value,
                child: Container(
                  padding: EdgeInsets.all(isWeb ? 30 : (isTablet ? 24 : 20)),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFf8fafc), Color(0xFFe2e8f0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF60a5fa).withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF60a5fa).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.person_outline,
                              color: Color(0xFF60a5fa),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Professional Summary',
                            style: TextStyle(
                              fontSize: isWeb ? 20 : (isTablet ? 18 : 16),
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1e293b),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isWeb ? 20 : 15),
                      Text(
                        'Experienced Android and Flutter Developer with a track record of delivering 30+ mobile apps using Kotlin, Java, and Flutter. Proficient in MVVM architecture, RESTful APIs, Firebase, and Play Store deployment.',
                        style: TextStyle(
                          fontSize: isWeb ? 16 : (isTablet ? 14 : 13),
                          color: const Color(0xFF475569),
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: isWeb ? 20 : 15),
                      Text(
                        'Adept at fostering collaboration across teams to produce high-quality, scalable Android solutions with optimal performance and sleek UI/UX design.',
                        style: TextStyle(
                          fontSize: isWeb ? 16 : (isTablet ? 14 : 13),
                          color: const Color(0xFF475569),
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: isWeb ? 25 : 20),
                      _buildSkillHighlights(),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSkillHighlights() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = MediaQuery.of(context).size.width > 1200;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10b981).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.star_outline,
                    color: Color(0xFF10b981),
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Core Expertise',
                  style: TextStyle(
                    fontSize: isWeb ? 16 : 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1e293b),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildSkillChip('Kotlin'),
                _buildSkillChip('Flutter'),
                _buildSkillChip('Android'),
                _buildSkillChip('MVVM'),
                _buildSkillChip('Firebase'),
                _buildSkillChip('REST APIs'),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildSkillChip(String skill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF60a5fa).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF60a5fa).withOpacity(0.3)),
      ),
      child: Text(
        skill,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF60a5fa),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }



  Widget _buildSkills() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = constraints.maxWidth > 1200;
        final isTablet = constraints.maxWidth > 768 && constraints.maxWidth <= 1200;
        final isMobile = constraints.maxWidth <= 768;

        return Container(
          padding: EdgeInsets.all(isWeb ? 40 : (isTablet ? 30 : 20)),
          color: const Color(0xFF1e293b),
          child: Column(
            children: [
              Text(
                'Technical Skills',
                style: TextStyle(
                  fontSize: isWeb ? 28 : (isTablet ? 24 : 20),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF60a5fa),
                ),
              ),
              SizedBox(height: isWeb ? 30 : 20),
              if (isMobile)
                Column(
                  children: [
                    _buildSkillsSidebar(),
                    const SizedBox(height: 20),
                    _buildSkillsGrid(),
                  ],
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: isWeb ? 1 : 2, child: _buildSkillsSidebar()),
                    SizedBox(width: isWeb ? 30 : 20),
                    Expanded(flex: isWeb ? 2 : 3, child: _buildSkillsGrid()),
                  ],
                ),
            ],
          ),
        );
      },
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
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0f172a),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF60a5fa).withOpacity(0.3),
                    ),
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
                      _buildSkillCategory('Mobile Development', Icons.phone_android, ['Kotlin', 'Java', 'Dart']),
                      _buildSkillCategory('Architecture', Icons.architecture, ['MVVM', 'Clean Architecture']),
                      _buildSkillCategory('Backend & APIs', Icons.api, ['Retrofit', 'REST APIs']),
                      _buildSkillCategory('Database', Icons.storage, ['Room', 'SQLite']),
                      _buildSkillCategory('Tools', Icons.build, ['Android Studio', 'Git']),
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
          colors: [Color(0xFFe0f2fe), Color(0xFFb3e5fc)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF60a5fa).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF60a5fa).withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.connect_without_contact, color: const Color(0xFF1976d2), size: 20),
              const SizedBox(width: 8),
              const Text(
                'Get In Touch',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1976d2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildModernContactItem(Icons.email_outlined, 'Email Me', 'mailto:shivamcsaiet316@gmail.com'),
          _buildModernContactItem(Icons.phone_outlined, 'Call Me', 'tel:+919057448064'),
          _buildModernContactItem(Icons.work_outline, 'LinkedIn', 'https://www.linkedin.com/in/shivam20797'),
          _buildModernContactItem(Icons.language, 'Portfolio', 'https://shivam20797.github.io/web-app/'),
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF60a5fa).withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF60a5fa).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: const Color(0xFF1976d2)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF1976d2),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 12, color: const Color(0xFF1976d2).withOpacity(0.6)),
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
          ...skills.map(
            (skill) => Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 4),
              child: Text(
                '• $skill',
                style: const TextStyle(fontSize: 12, color: Color(0xFF94a3b8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = constraints.maxWidth > 800;
        final spacing = isWeb ? 15.0 : 10.0;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          alignment: WrapAlignment.center,
          children: [
            _buildAnimatedSkillCard(Icons.android, 'Kotlin', 'Native Android', 0),
            _buildAnimatedSkillCard(Icons.code, 'Java', 'Object-Oriented', 100),
            _buildAnimatedSkillCard(Icons.flutter_dash, 'Flutter', 'Cross Platform', 200),
            _buildAnimatedSkillCard(Icons.architecture, 'MVVM', 'Architecture', 300),
            _buildAnimatedSkillCard(Icons.api, 'Retrofit', 'REST APIs', 400),
            _buildAnimatedSkillCard(Icons.cloud, 'Firebase', 'Backend', 500),
          ],
        );
      },
    );
  }

  Widget _buildAnimatedSkillCard(IconData icon, String title, String subtitle, int delay) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: _FlipCard(icon: icon, title: title, subtitle: subtitle),
        );
      },
    );
  }

  Widget _buildExperience() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = constraints.maxWidth > 1200;
        final isTablet = constraints.maxWidth > 768 && constraints.maxWidth <= 1200;

        return Container(
          padding: EdgeInsets.all(isWeb ? 40 : (isTablet ? 30 : 20)),
          child: Column(
            children: [
              Text(
                'Work Experience',
                style: TextStyle(
                  fontSize: isWeb ? 28 : (isTablet ? 24 : 20),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF60a5fa),
                ),
              ),
              SizedBox(height: isWeb ? 30 : 20),
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
      },
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

  Widget _buildEducation() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = constraints.maxWidth > 1200;
        final isTablet = constraints.maxWidth > 768 && constraints.maxWidth <= 1200;

        return Container(
          padding: EdgeInsets.all(isWeb ? 40 : (isTablet ? 30 : 20)),
          color: const Color(0xFF1e293b),
          child: Column(
            children: [
              Text(
                'Education',
                style: TextStyle(
                  fontSize: isWeb ? 28 : (isTablet ? 24 : 20),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF60a5fa),
                ),
              ),
              SizedBox(height: isWeb ? 30 : 20),
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 800),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(30 * (1 - value), 0),
                    child: Opacity(
                      opacity: value,
                      child: Container(
                        padding: EdgeInsets.all(isWeb ? 24 : (isTablet ? 20 : 16)),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFf8fafc), Color(0xFFe2e8f0)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF60a5fa).withOpacity(0.3)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF60a5fa).withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: constraints.maxWidth <= 600
                            ? Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(isWeb ? 16 : 12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF60a5fa).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.school,
                                      size: isWeb ? 32 : (isTablet ? 28 : 24),
                                      color: const Color(0xFF1976d2),
                                    ),
                                  ),
                                  SizedBox(height: isWeb ? 16 : 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Bachelor of Technology (B.Tech)',
                                        style: TextStyle(
                                          fontSize: isWeb ? 18 : (isTablet ? 16 : 15),
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF1976d2),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        'Computer Science',
                                        style: TextStyle(
                                          fontSize: isWeb ? 16 : (isTablet ? 14 : 13),
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF475569),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: isWeb ? 8 : 6),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.location_on_outlined,
                                            size: isWeb ? 16 : 14,
                                            color: const Color(0xFF64748b),
                                          ),
                                          const SizedBox(width: 4),
                                          Flexible(
                                            child: Text(
                                              'Rajasthan Technical University, India',
                                              style: TextStyle(
                                                fontSize: isWeb ? 14 : (isTablet ? 12 : 11),
                                                color: const Color(0xFF64748b),
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.calendar_today_outlined,
                                            size: isWeb ? 16 : 14,
                                            color: const Color(0xFF64748b),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '07/2014 - 07/2018',
                                            style: TextStyle(
                                              fontSize: isWeb ? 14 : (isTablet ? 12 : 11),
                                              color: const Color(0xFF64748b),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(isWeb ? 16 : 12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF60a5fa).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.school,
                                      size: isWeb ? 32 : 28,
                                      color: const Color(0xFF1976d2),
                                    ),
                                  ),
                                  SizedBox(width: isWeb ? 20 : 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Bachelor of Technology (B.Tech)',
                                          style: TextStyle(
                                            fontSize: isWeb ? 18 : 16,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF1976d2),
                                          ),
                                        ),
                                        Text(
                                          'Computer Science',
                                          style: TextStyle(
                                            fontSize: isWeb ? 16 : 14,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF475569),
                                          ),
                                        ),
                                        SizedBox(height: isWeb ? 8 : 6),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on_outlined,
                                              size: isWeb ? 16 : 14,
                                              color: const Color(0xFF64748b),
                                            ),
                                            const SizedBox(width: 4),
                                            Flexible(
                                              child: Text(
                                                'Rajasthan Technical University, India',
                                                style: TextStyle(
                                                  fontSize: isWeb ? 14 : 12,
                                                  color: const Color(0xFF64748b),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_today_outlined,
                                              size: isWeb ? 16 : 14,
                                              color: const Color(0xFF64748b),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '07/2014 - 07/2018',
                                              style: TextStyle(
                                                fontSize: isWeb ? 14 : 12,
                                                color: const Color(0xFF64748b),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguages() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = constraints.maxWidth > 1200;
        final isTablet = constraints.maxWidth > 768 && constraints.maxWidth <= 1200;
        final isMobile = constraints.maxWidth <= 768;

        return Container(
          padding: EdgeInsets.all(isWeb ? 40 : (isTablet ? 30 : 20)),
          color: const Color(0xFF1e293b),
          child: Column(
            children: [
              Text(
                'Languages',
                style: TextStyle(
                  fontSize: isWeb ? 28 : (isTablet ? 24 : 20),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF60a5fa),
                ),
              ),
              SizedBox(height: isWeb ? 30 : 20),
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 800),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      padding: EdgeInsets.all(isWeb ? 30 : (isTablet ? 24 : 20)),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0f172a), Color(0xFF1e293b)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF60a5fa).withOpacity(0.3)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF60a5fa).withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: if (isMobile)
                        Column(
                          children: [
                            _buildLanguageItem('🇺🇸', 'English', 'Professional Working Proficiency', 0.9),
                            const SizedBox(height: 20),
                            _buildLanguageItem('🇮🇳', 'Hindi', 'Full Professional Proficiency', 1.0),
                          ],
                        )
                      else
                        Row(
                          children: [
                            Expanded(child: _buildLanguageItem('🇺🇸', 'English', 'Professional Working Proficiency', 0.9)),
                            const SizedBox(width: 30),
                            Expanded(child: _buildLanguageItem('🇮🇳', 'Hindi', 'Full Professional Proficiency', 1.0)),
                          ],
                        ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageItem(String flag, String language, String proficiency, double level) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = MediaQuery.of(context).size.width > 1200;
        final isTablet = MediaQuery.of(context).size.width > 768 && MediaQuery.of(context).size.width <= 1200;
        
        return Column(
          children: [
            Text(
              flag,
              style: TextStyle(fontSize: isWeb ? 40 : (isTablet ? 35 : 30)),
            ),
            SizedBox(height: isWeb ? 12 : 8),
            Text(
              language,
              style: TextStyle(
                fontSize: isWeb ? 18 : (isTablet ? 16 : 15),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: isWeb ? 8 : 6),
            Text(
              proficiency,
              style: TextStyle(
                fontSize: isWeb ? 12 : (isTablet ? 11 : 10),
                color: const Color(0xFF94a3b8),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isWeb ? 12 : 8),
            Container(
              width: double.infinity,
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFF334155),
                borderRadius: BorderRadius.circular(3),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: level,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF60a5fa), Color(0xFF3b82f6)],
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLanguageCard(String language, String proficiency, IconData icon, int delay) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final parentWidth = MediaQuery.of(context).size.width;
        final isWeb = parentWidth > 1200;
        final isTablet = parentWidth > 768 && parentWidth <= 1200;
        
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 800 + delay),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                padding: EdgeInsets.all(isWeb ? 20 : (isTablet ? 16 : 14)),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFfef3c7), Color(0xFFfde68a)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFf59e0b).withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFf59e0b).withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(isWeb ? 12 : (isTablet ? 10 : 8)),
                      decoration: BoxDecoration(
                        color: const Color(0xFFf59e0b).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        icon,
                        size: isWeb ? 28 : (isTablet ? 24 : 20),
                        color: const Color(0xFFd97706),
                      ),
                    ),
                    SizedBox(height: isWeb ? 12 : 8),
                    Text(
                      language,
                      style: TextStyle(
                        fontSize: isWeb ? 18 : (isTablet ? 16 : 15),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFd97706),
                      ),
                    ),
                    SizedBox(height: isWeb ? 4 : 2),
                    Text(
                      proficiency,
                      style: TextStyle(
                        fontSize: isWeb ? 13 : (isTablet ? 12 : 11),
                        color: const Color(0xFF92400e),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildContact() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = constraints.maxWidth > 1200;
        final isTablet = constraints.maxWidth > 768 && constraints.maxWidth <= 1200;

        return Container(
          padding: EdgeInsets.all(isWeb ? 40 : (isTablet ? 30 : 20)),
          color: const Color(0xFF0f172a),
          child: Column(
            children: [
              Text(
                'Get In Touch',
                style: TextStyle(
                  fontSize: isWeb ? 28 : (isTablet ? 24 : 20),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF60a5fa),
                ),
              ),
              SizedBox(height: isWeb ? 30 : 20),
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 800),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: _buildModernContactCard(),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProjects() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = constraints.maxWidth > 1200;
        final isTablet = constraints.maxWidth > 768 && constraints.maxWidth <= 1200;
        final isMobile = constraints.maxWidth <= 768;

        return Container(
          padding: EdgeInsets.all(isWeb ? 40 : (isTablet ? 30 : 20)),
          color: const Color(0xFF0f172a),
          child: Column(
            children: [
              Text(
                'Featured Projects',
                style: TextStyle(
                  fontSize: isWeb ? 28 : (isTablet ? 24 : 20),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF60a5fa),
                ),
              ),
              SizedBox(height: isWeb ? 30 : 20),
              if (isMobile)
                Column(
                  children: [
                    _buildAnimatedProjectCard('E-Commerce App', 'Kotlin + MVVM + Room', Icons.shopping_cart, 0),
                    const SizedBox(height: 20),
                    _buildAnimatedProjectCard('Chat App', 'Flutter + Firebase', Icons.chat, 200),
                    const SizedBox(height: 20),
                    _buildAnimatedProjectCard('Weather App', 'Android + Retrofit', Icons.wb_sunny, 400),
                  ],
                )
              else
                Wrap(
                  spacing: isWeb ? 20 : 15,
                  runSpacing: isWeb ? 20 : 15,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildAnimatedProjectCard('E-Commerce App', 'Kotlin + MVVM + Room', Icons.shopping_cart, 0),
                    _buildAnimatedProjectCard('Chat App', 'Flutter + Firebase', Icons.chat, 200),
                    _buildAnimatedProjectCard('Weather App', 'Android + Retrofit', Icons.wb_sunny, 400),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimatedProjectCard(String title, String tech, IconData icon, int delay) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final parentWidth = MediaQuery.of(context).size.width;
        final isWeb = parentWidth > 1200;
        final isTablet = parentWidth > 768 && parentWidth <= 1200;
        final isMobile = parentWidth <= 768;

        final cardWidth = isMobile ? double.infinity : (isTablet ? 180.0 : 200.0);

        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 600 + delay),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                width: isMobile ? null : cardWidth,
                constraints: isMobile ? const BoxConstraints(maxWidth: 300) : null,
                padding: EdgeInsets.all(isWeb ? 20 : (isTablet ? 16 : 14)),
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
                    Icon(
                      icon,
                      size: isWeb ? 40 : (isTablet ? 35 : 30),
                      color: const Color(0xFF60a5fa),
                    ),
                    SizedBox(height: isWeb ? 15 : 10),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: isWeb ? 16 : (isTablet ? 14 : 13),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      tech,
                      style: TextStyle(
                        fontSize: isWeb ? 12 : (isTablet ? 11 : 10),
                        color: const Color(0xFF94a3b8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
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

class _FlipCardState extends State<_FlipCard> with SingleTickerProviderStateMixin {
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                final parentWidth = constraints.maxWidth;
                final cardWidth = parentWidth > 800 ? 140.0 : (parentWidth > 400 ? 120.0 : 100.0);
                final cardHeight = parentWidth > 800 ? 120.0 : (parentWidth > 400 ? 100.0 : 90.0);

                return Container(
                  width: cardWidth,
                  height: cardHeight,
                  decoration: BoxDecoration(
                    color: isShowingFront ? const Color(0xFF0f172a) : const Color(0xFF60a5fa),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF60a5fa), width: 1),
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
                );
              },
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
            style: const TextStyle(fontSize: 9, color: Color(0xFF94a3b8)),
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
            style: TextStyle(fontSize: 9, color: Colors.white.withOpacity(0.8)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}