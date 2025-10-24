import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lottie/lottie.dart';

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
  int _currentTabIndex = 0;

  final List<GlobalKey> _sectionKeys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(), // Contact section
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
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
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    int newIndex = 0;
    
    // Check if we're near the bottom (contact section)
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      newIndex = 6; // Contact tab
    } else {
      for (int i = 0; i < _sectionKeys.length - 1; i++) {
        final context = _sectionKeys[i].currentContext;
        if (context != null) {
          final box = context.findRenderObject() as RenderBox?;
          if (box != null) {
            final position = box.localToGlobal(Offset.zero).dy;
            if (position <= 200) {
              newIndex = i;
            }
          }
        }
      }
    }
    
    if (newIndex != _currentTabIndex) {
      setState(() {
        _currentTabIndex = newIndex;
        _tabController.animateTo(newIndex);
      });
    }
  }

  void _scrollToSection(int index) {
    if (index == 0) {
      // Home section - scroll to top
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    } else if (index == 6) {
      // Contact section - scroll to bottom
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    } else {
      final context = _sectionKeys[index].currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
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

                    Container(key: _sectionKeys[0], child: const SizedBox.shrink()),
                    Container(key: _sectionKeys[1], child: _buildSkills()),
                    Container(key: _sectionKeys[2], child: _buildExperience()),
                    Container(key: _sectionKeys[3], child: _buildProjects()),
                    Container(key: _sectionKeys[4], child: _buildEducation()),
                    Container(key: _sectionKeys[5], child: _buildLanguages()),
                    Container(key: _sectionKeys[6], child: _buildContact()),
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
          Tab(text: 'Home'),
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
        final isTablet =
            constraints.maxWidth > 768 && constraints.maxWidth <= 1200;
        final isMobile = constraints.maxWidth <= 768;

        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1200),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                padding: EdgeInsets.all(isWeb ? 40 : (isTablet ? 30 : 20)),
                decoration: const BoxDecoration(color: Color(0xFF1e293b)),
                child: isMobile
                    ? Column(
                        children: [
                          _buildProfileSection(isWeb, isTablet, isMobile),
                          const SizedBox(height: 20),
                          _buildAboutSection(isWeb, isTablet, isMobile),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: _buildProfileSection(isWeb, isTablet, isMobile),
                          ),
                          SizedBox(width: isWeb ? 40 : 30),
                          Expanded(
                            flex: 2,
                            child: _buildAboutSection(isWeb, isTablet, isMobile),
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

  Widget _buildProfileSection(bool isWeb, bool isTablet, bool isMobile) {
    return Column(
      children: [
        Hero(
          tag: 'profile',
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 2000),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, animValue, child) {
                return Transform.rotate(
                  angle: animValue * 0.1,
                  child: Container(
                    width: isWeb ? 120 : (isTablet ? 100 : 80),
                    height: isWeb ? 120 : (isTablet ? 100 : 80),
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
                    child: Lottie.asset(
                      'assets/lottie/profile.json',
                      fit: BoxFit.contain,
                      repeat: true,
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
          'Senior Mobile Application Developer',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF94a3b8),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: isWeb ? 20 : 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildHeaderStatBox(
              '6+',
              'Years Experience',
              isWeb,
              isTablet,
            ),
            SizedBox(width: isWeb ? 20 : 15),
            _buildHeaderStatBox(
              '30+',
              'Apps Delivered',
              isWeb,
              isTablet,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAboutSection(bool isWeb, bool isTablet, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isWeb ? 24 : (isTablet ? 20 : 16)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1e293b),
            const Color(0xFF334155),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF60a5fa).withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF60a5fa).withOpacity(0.2),
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
                'About Me',
                style: TextStyle(
                  fontSize: isWeb ? 20 : (isTablet ? 18 : 16),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: isWeb ? 20 : 15),
          Text(
            'Experienced Android and Flutter Developer with a track record of delivering 30+ mobile apps using Kotlin, Java, and Flutter. Proficient in MVVM architecture, RESTful APIs, Firebase, and Play Store deployment.',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFFe2e8f0),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Adept at fostering collaboration across teams to produce high-quality, scalable Android solutions with optimal performance and sleek UI/UX design.',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFFe2e8f0),
              height: 1.6,
            ),
          ),
          SizedBox(height: isWeb ? 20 : 15),
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
      ),
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
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              onTap: () => _launchUrl(url),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [const Color(0xFF60a5fa), const Color(0xFF3b82f6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF60a5fa).withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: Colors.white,
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = constraints.maxWidth > 1200;
        final isTablet =
            constraints.maxWidth > 768 && constraints.maxWidth <= 1200;
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
              _buildAboutContent(),
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
        final isTablet =
            MediaQuery.of(context).size.width > 768 &&
            MediaQuery.of(context).size.width <= 1200;

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
                    border: Border.all(
                      color: const Color(0xFF60a5fa).withOpacity(0.3),
                    ),
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
                                    color: const Color(
                                      0xFF60a5fa,
                                    ).withOpacity(0.4),
                                    blurRadius: 25,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Container(
                                width: isWeb ? 100 : (isTablet ? 80 : 70),
                                height: isWeb ? 100 : (isTablet ? 80 : 70),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF60a5fa),
                                      Color(0xFF3b82f6),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Lottie.asset(
                                  'assets/lottie/profile.json',
                                  fit: BoxFit.contain,
                                  repeat: true,
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
        final isTablet =
            MediaQuery.of(context).size.width > 768 &&
            MediaQuery.of(context).size.width <= 1200;

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
        final isTablet =
            MediaQuery.of(context).size.width > 768 &&
            MediaQuery.of(context).size.width <= 1200;

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
                    border: Border.all(
                      color: const Color(0xFF60a5fa).withOpacity(0.2),
                    ),
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
        final isTablet =
            constraints.maxWidth > 768 && constraints.maxWidth <= 1200;
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isMobile) ...[
                    Expanded(flex: isWeb ? 1 : 2, child: _buildSkillsSidebar()),
                    SizedBox(width: isWeb ? 30 : 20),
                  ],
                  Expanded(
                    flex: isMobile ? 1 : (isWeb ? 2 : 3),
                    child: _buildSkillsGrid(),
                  ),
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
                      Container(
                        width: 40,
                        height: 40,
                        child: Lottie.asset(
                          'assets/lottie/coding.json',
                          fit: BoxFit.contain,
                          repeat: true,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildSkillCategory(
                        'Mobile Development',
                        Icons.phone_android,
                        ['Kotlin', 'Java', 'Dart'],
                      ),
                      _buildSkillCategory('Architecture', Icons.architecture, [
                        'MVVM',
                        'Clean Architecture',
                      ]),
                      _buildSkillCategory('Backend & APIs', Icons.api, [
                        'Retrofit',
                        'REST APIs',
                      ]),
                      _buildSkillCategory('Database', Icons.storage, [
                        'Room',
                        'SQLite',
                      ]),
                      _buildSkillCategory('Tools', Icons.build, [
                        'Android Studio',
                        'Git',
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
            _buildAnimatedSkillCard(
              Icons.android,
              'Kotlin',
              'Native Android',
              0,
            ),
            _buildAnimatedSkillCard(Icons.code, 'Java', 'Object-Oriented', 100),
            _buildAnimatedSkillCard(
              Icons.flutter_dash,
              'Flutter',
              'Cross Platform',
              200,
            ),
            _buildAnimatedSkillCard(
              Icons.architecture,
              'MVVM',
              'Architecture',
              300,
            ),
            _buildAnimatedSkillCard(Icons.api, 'Retrofit', 'REST APIs', 400),
            _buildAnimatedSkillCard(Icons.cloud, 'Firebase', 'Backend', 500),
          ],
        );
      },
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
          child: _FlipCard(icon: icon, title: title, subtitle: subtitle),
        );
      },
    );
  }

  Widget _buildExperience() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = constraints.maxWidth > 1200;
        final isTablet =
            constraints.maxWidth > 768 && constraints.maxWidth <= 1200;

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

  Widget _buildEducation() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = constraints.maxWidth > 1200;
        final isTablet =
            constraints.maxWidth > 768 && constraints.maxWidth <= 1200;

        return Container(
          padding: EdgeInsets.all(isWeb ? 40 : (isTablet ? 30 : 20)),
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
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      padding: EdgeInsets.all(
                        isWeb ? 30 : (isTablet ? 24 : 20),
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0f172a), Color(0xFF1e293b)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF60a5fa).withOpacity(0.3),
                        ),
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
                          Text(
                            '🎓',
                            style: TextStyle(
                              fontSize: isWeb ? 50 : (isTablet ? 45 : 40),
                            ),
                          ),
                          SizedBox(height: isWeb ? 16 : 12),
                          Text(
                            'Bachelor of Technology (B.Tech)',
                            style: TextStyle(
                              fontSize: isWeb ? 22 : (isTablet ? 20 : 18),
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: isWeb ? 8 : 6),
                          Text(
                            'Computer Science Engineering',
                            style: TextStyle(
                              fontSize: isWeb ? 16 : (isTablet ? 14 : 13),
                              color: const Color(0xFF94a3b8),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: isWeb ? 16 : 12),
                          Container(
                            width: double.infinity,
                            height: 6,
                            decoration: BoxDecoration(
                              color: const Color(0xFF334155),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: 1.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF10b981),
                                      Color(0xFF059669),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: isWeb ? 16 : 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildEducationDetail(
                                Icons.location_on,
                                'Rajasthan Technical University',
                                isWeb,
                                isTablet,
                              ),
                              _buildEducationDetail(
                                Icons.calendar_today,
                                '2014 - 2018',
                                isWeb,
                                isTablet,
                              ),
                            ],
                          ),
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

  Widget _buildEducationDetail(
    IconData icon,
    String text,
    bool isWeb,
    bool isTablet,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: isWeb ? 16 : 14, color: const Color(0xFF60a5fa)),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: isWeb ? 12 : (isTablet ? 11 : 10),
            color: const Color(0xFF94a3b8),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguages() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = constraints.maxWidth > 1200;
        final isTablet =
            constraints.maxWidth > 768 && constraints.maxWidth <= 1200;
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
                      padding: EdgeInsets.all(
                        isWeb ? 30 : (isTablet ? 24 : 20),
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0f172a), Color(0xFF1e293b)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF60a5fa).withOpacity(0.3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF60a5fa).withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: isMobile
                          ? Column(
                              children: [
                                _buildLanguageItem(
                                  '🇺🇸',
                                  'English',
                                  'Professional Working Proficiency',
                                  0.9,
                                ),
                                const SizedBox(height: 20),
                                _buildLanguageItem(
                                  '🇮🇳',
                                  'Hindi',
                                  'Full Professional Proficiency',
                                  1.0,
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: _buildLanguageItem(
                                    '🇺🇸',
                                    'English',
                                    'Professional Working Proficiency',
                                    0.9,
                                  ),
                                ),
                                const SizedBox(width: 30),
                                Expanded(
                                  child: _buildLanguageItem(
                                    '🇮🇳',
                                    'Hindi',
                                    'Full Professional Proficiency',
                                    1.0,
                                  ),
                                ),
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

  Widget _buildLanguageItem(
    String flag,
    String language,
    String proficiency,
    double level,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = MediaQuery.of(context).size.width > 1200;
        final isTablet =
            MediaQuery.of(context).size.width > 768 &&
            MediaQuery.of(context).size.width <= 1200;

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

  Widget _buildLanguageCard(
    String language,
    String proficiency,
    IconData icon,
    int delay,
  ) {
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
                  border: Border.all(
                    color: const Color(0xFFf59e0b).withOpacity(0.3),
                  ),
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
        final isTablet =
            constraints.maxWidth > 768 && constraints.maxWidth <= 1200;
        final isMobile = constraints.maxWidth <= 768;

        return Container(
          padding: EdgeInsets.all(isWeb ? 40 : (isTablet ? 30 : 20)),
          color: const Color(0xFF0f172a),
          child: Column(
            children: [
              Text(
                'Contact',
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
                          colors: [Color(0xFF1e293b), Color(0xFF334155)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF60a5fa).withOpacity(0.3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF60a5fa).withOpacity(0.2),
                            blurRadius: 25,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF60a5fa).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Icon(
                              Icons.connect_without_contact,
                              size: isWeb ? 32 : (isTablet ? 28 : 24),
                              color: const Color(0xFF60a5fa),
                            ),
                          ),
                          SizedBox(height: isWeb ? 16 : 12),
                          Text(
                            'Let\'s Connect',
                            style: TextStyle(
                              fontSize: isWeb ? 24 : (isTablet ? 20 : 18),
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: isWeb ? 8 : 6),
                          Text(
                            'Ready to collaborate? Get in touch!',
                            style: TextStyle(
                              fontSize: isWeb ? 14 : (isTablet ? 13 : 12),
                              color: const Color(0xFF94a3b8),
                            ),
                          ),
                          SizedBox(height: isWeb ? 30 : 24),
                          isMobile
                              ? Column(
                                  children: [
                                    _buildContactCard(
                                      Icons.email_outlined,
                                      'Email',
                                      'shivamcsaiet316@gmail.com',
                                      'mailto:shivamcsaiet316@gmail.com',
                                      isWeb,
                                      isTablet,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildContactCard(
                                      Icons.phone_outlined,
                                      'Phone',
                                      '+91 90574 48064',
                                      'tel:+919057448064',
                                      isWeb,
                                      isTablet,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildContactCard(
                                      Icons.work_outline,
                                      'LinkedIn',
                                      'shivam20797',
                                      'https://www.linkedin.com/in/shivam20797',
                                      isWeb,
                                      isTablet,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildContactCard(
                                      Icons.web_outlined,
                                      'Portfolio',
                                      'shivam20797.github.io',
                                      'https://shivam20797.github.io/web-app/',
                                      isWeb,
                                      isTablet,
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildContactCard(
                                            Icons.email_outlined,
                                            'Email',
                                            'shivamcsaiet316@gmail.com',
                                            'mailto:shivamcsaiet316@gmail.com',
                                            isWeb,
                                            isTablet,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: _buildContactCard(
                                            Icons.phone_outlined,
                                            'Phone',
                                            '+91 90574 48064',
                                            'tel:+919057448064',
                                            isWeb,
                                            isTablet,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildContactCard(
                                            Icons.work_outline,
                                            'LinkedIn',
                                            'shivam20797',
                                            'https://www.linkedin.com/in/shivam20797',
                                            isWeb,
                                            isTablet,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: _buildContactCard(
                                            Icons.web_outlined,
                                            'Portfolio',
                                            'shivam20797.github.io',
                                            'https://shivam20797.github.io/web-app/',
                                            isWeb,
                                            isTablet,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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

  Widget _buildContactCard(
    IconData icon,
    String title,
    String subtitle,
    String url,
    bool isWeb,
    bool isTablet,
  ) {
    return InkWell(
      onTap: () => _launchUrl(url),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(isWeb ? 16 : (isTablet ? 14 : 12)),
        decoration: BoxDecoration(
          color: const Color(0xFF0f172a),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF60a5fa).withOpacity(0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: isWeb ? 24 : (isTablet ? 22 : 20),
              color: const Color(0xFF60a5fa),
            ),
            SizedBox(height: isWeb ? 8 : 6),
            Text(
              title,
              style: TextStyle(
                fontSize: isWeb ? 14 : (isTablet ? 13 : 12),
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: isWeb ? 4 : 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: isWeb ? 11 : (isTablet ? 10 : 9),
                color: const Color(0xFF94a3b8),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjects() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = constraints.maxWidth > 1200;
        final isTablet =
            constraints.maxWidth > 768 && constraints.maxWidth <= 1200;
        final isMobile = constraints.maxWidth <= 768;

        return Container(
          padding: EdgeInsets.all(isWeb ? 40 : (isTablet ? 30 : 20)),
          decoration: BoxDecoration(
            color: const Color(0xFF0f172a),
            image: DecorationImage(
              image: NetworkImage(
                'data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="dots" width="20" height="20" patternUnits="userSpaceOnUse"><circle cx="10" cy="10" r="1" fill="%23334155" opacity="0.3"/></pattern></defs><rect width="100" height="100" fill="url(%23dots)"/></svg>',
              ),
              repeat: ImageRepeat.repeat,
              opacity: 0.4,
            ),
          ),
          child: Column(
            children: [
              Text(
                'Projects',
                style: TextStyle(
                  fontSize: isWeb ? 28 : (isTablet ? 24 : 20),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF60a5fa),
                ),
              ),
              SizedBox(height: isWeb ? 30 : 20),
              _buildProjectCategory(
                '🟩 Featured Applications',
                'Available on Google Play Store',
                [
                  {
                    'name': 'Mars',
                    'desc': 'Safety & Inspection App',
                    'icon': Icons.security,
                    'url':
                        'https://play.google.com/store/apps/details?id=com.iinorth.mars&hl=en_IN',
                  },
                  {
                    'name': 'iSpray',
                    'desc': 'Location & Mapping Utility',
                    'icon': Icons.map,
                    'url':
                        'https://play.google.com/store/apps/details?id=com.iinorth.spray&hl=en_IN',
                  },
                  {
                    'name': 'GeoPhotos',
                    'desc': 'Image Location Tagging',
                    'icon': Icons.photo_camera,
                    'url':
                        'https://play.google.com/store/apps/details?id=app.geophotos&hl=en_IN',
                  },
                  {
                    'name': 'Shubhashish WaterWise',
                    'desc': 'Utility Management System',
                    'icon': Icons.business,
                    'url':
                        'https://play.google.com/store/apps/details?id=app.swm&hl=en_IN',
                  },
                  {
                    'name': 'Hy U',
                    'desc': 'Social Media Platform',
                    'icon': Icons.chat_bubble,
                    'url':
                        'https://play.google.com/store/apps/details?id=idf.apton.hyu&hl=en_IN',
                  },
                ],
                0,
              ),
              const SizedBox(height: 30),
              _buildProjectCategory(
                '🟦 Government & Enterprise',
                'Large-scale solutions',
                [
                  {
                    'name': 'Infra Verification',
                    'desc': 'Agricultural Management',
                    'icon': Icons.agriculture,
                    'url':
                        'https://play.google.com/store/apps/details?id=com.jvvnl.agri&hl=en_IN',
                  },
                  {
                    'name': 'NDFDC',
                    'desc': 'Development Corporation',
                    'icon': Icons.account_balance,
                  },
                  {
                    'name': 'Parking JSCL',
                    'desc': 'Smart Parking System',
                    'icon': Icons.local_parking,
                    'url':
                        'https://play.google.com/store/apps/details?id=com.jscl.parking&hl=en_IN',
                  },
                ],
                200,
              ),
              const SizedBox(height: 30),
              _buildProjectCategory(
                '🟨 International Projects',
                'Global client solutions',
                [
                  {
                    'name': 'IntElux',
                    'desc': 'IoT Lighting Control',
                    'icon': Icons.lightbulb,
                    'url':
                        'https://play.google.com/store/search?q=intelux&c=apps&hl=en_IN',
                  },
                ],
                400,
              ),
              const SizedBox(height: 30),
              _buildProjectSummary(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProjectCategory(
    String title,
    String subtitle,
    List<Map<String, dynamic>> projects,
    int delay,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = constraints.maxWidth > 1200;
        final isTablet =
            constraints.maxWidth > 768 && constraints.maxWidth <= 1200;
        final isMobile = constraints.maxWidth <= 768;

        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 800 + delay),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(30 * (1 - value), 0),
              child: Opacity(
                opacity: value,
                child: Container(
                  padding: EdgeInsets.all(isWeb ? 24 : (isTablet ? 20 : 16)),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1e293b).withOpacity(0.7),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF475569).withOpacity(0.4),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: isWeb ? 18 : (isTablet ? 16 : 15),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: isWeb ? 14 : (isTablet ? 12 : 11),
                          color: const Color(0xFF94a3b8),
                        ),
                      ),
                      SizedBox(height: isWeb ? 16 : 12),
                      isMobile
                          ? Column(
                              children: projects
                                  .map(
                                    (project) => Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: _buildProjectItem(
                                        project,
                                        isWeb,
                                        isTablet,
                                        isMobile,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: isWeb
                                        ? 4
                                        : (isTablet ? 3 : 2),
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                    childAspectRatio: isWeb
                                        ? 3.0
                                        : (isTablet ? 2.8 : 2.5),
                                  ),
                              itemCount: projects.length,
                              itemBuilder: (context, index) =>
                                  _buildProjectItem(
                                    projects[index],
                                    isWeb,
                                    isTablet,
                                    isMobile,
                                  ),
                            ),
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

  Widget _buildProjectItem(
    Map<String, dynamic> project,
    bool isWeb,
    bool isTablet,
    bool isMobile,
  ) {
    return Container(
      padding: EdgeInsets.all(isWeb ? 12 : (isTablet ? 10 : 8)),
      decoration: BoxDecoration(
        color: const Color(0xFF334155).withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF64748b).withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF64748b).withOpacity(0.4),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  project['icon'],
                  size: isWeb ? 16 : 14,
                  color: const Color(0xFF94a3b8),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  project['name'],
                  style: TextStyle(
                    fontSize: isWeb ? 12 : (isTablet ? 11 : 10),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            project['desc'],
            style: TextStyle(
              fontSize: isWeb ? 9 : (isTablet ? 8 : 7),
              color: const Color(0xFF94a3b8),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (project['url'] != null) ...[
            const SizedBox(height: 6),
            InkWell(
              onTap: () => _launchUrl(project['url']),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF60a5fa).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF60a5fa).withOpacity(0.5),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.play_arrow,
                      size: 10,
                      color: const Color(0xFF60a5fa),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      'Play Store',
                      style: TextStyle(
                        fontSize: isWeb ? 8 : 7,
                        color: const Color(0xFF60a5fa),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeaderStatBox(
    String number,
    String label,
    bool isWeb,
    bool isTablet,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isWeb ? 16 : 12,
        vertical: isWeb ? 12 : 8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF334155).withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF60a5fa).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: isWeb ? 18 : (isTablet ? 16 : 14),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF60a5fa),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: isWeb ? 11 : (isTablet ? 10 : 9),
              color: const Color(0xFF94a3b8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectSummary() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = constraints.maxWidth > 1200;
        final isTablet =
            constraints.maxWidth > 768 && constraints.maxWidth <= 1200;

        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1000),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                padding: EdgeInsets.all(isWeb ? 24 : (isTablet ? 20 : 16)),
                decoration: BoxDecoration(
                  color: const Color(0xFF1e293b),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF475569).withOpacity(0.5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.check_circle,
                        size: isWeb ? 32 : (isTablet ? 28 : 24),
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: isWeb ? 20 : 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '✅ Summary',
                            style: TextStyle(
                              fontSize: isWeb ? 18 : (isTablet ? 16 : 15),
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Developed 10+ production-ready applications across commercial, government, and international domains with Play Store deployment.',
                            style: TextStyle(
                              fontSize: isWeb ? 14 : (isTablet ? 12 : 11),
                              color: Colors.white.withOpacity(0.9),
                              height: 1.4,
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
      },
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final Map<String, dynamic> project;
  final bool isWeb;
  final bool isTablet;
  final bool isMobile;
  final Function(String) onLaunch;

  const _ProjectCard({
    required this.project,
    required this.isWeb,
    required this.isTablet,
    required this.isMobile,
    required this.onLaunch,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _toggleExpand,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedBuilder(
        animation: _expandAnimation,
        builder: (context, child) {
          return Container(
            padding: EdgeInsets.all(
              widget.isWeb ? 12 : (widget.isTablet ? 10 : 8),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF334155).withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF64748b).withOpacity(0.4),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF64748b).withOpacity(0.4),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        widget.project['icon'],
                        size: widget.isWeb ? 16 : 14,
                        color: const Color(0xFF94a3b8),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.project['name'],
                        style: TextStyle(
                          fontSize: widget.isWeb
                              ? 12
                              : (widget.isTablet ? 11 : 10),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      size: 16,
                      color: const Color(0xFF94a3b8),
                    ),
                  ],
                ),
                if (_expandAnimation.value > 0)
                  SizeTransition(
                    sizeFactor: _expandAnimation,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.project['desc'],
                            style: TextStyle(
                              fontSize: widget.isWeb
                                  ? 10
                                  : (widget.isTablet ? 9 : 8),
                              color: const Color(0xFF94a3b8),
                            ),
                          ),
                          if (widget.project['url'] != null)
                            Column(
                              children: [
                                const SizedBox(height: 8),
                                InkWell(
                                  onTap: () =>
                                      widget.onLaunch(widget.project['url']),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF60a5fa,
                                      ).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(
                                          0xFF60a5fa,
                                        ).withOpacity(0.5),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.play_arrow,
                                          size: 12,
                                          color: const Color(0xFF60a5fa),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Play Store',
                                          style: TextStyle(
                                            fontSize: widget.isWeb ? 9 : 8,
                                            color: const Color(0xFF60a5fa),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
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
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
                final cardWidth = parentWidth > 800
                    ? 140.0
                    : (parentWidth > 400 ? 120.0 : 100.0);
                final cardHeight = parentWidth > 800
                    ? 120.0
                    : (parentWidth > 400 ? 100.0 : 90.0);

                return Container(
                  width: cardWidth,
                  height: cardHeight,
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
