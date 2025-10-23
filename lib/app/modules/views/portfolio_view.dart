import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class PortfolioView extends StatelessWidget {
  const PortfolioView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f172a),
      body: SingleChildScrollView(
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
    );
  }

  Widget _buildHeader() {
    return Container(
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
          const CircleAvatar(
            radius: 60,
            backgroundColor: Color(0xFF60a5fa),
            child: Icon(Icons.person, size: 60, color: Colors.white),
          ),
          const SizedBox(height: 20),
          const Text(
            'Satyam Agrawal',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Senior SRE/DevOps Engineer',
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFF94a3b8),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            children: [
              _buildSkillChip('AWS'),
              _buildSkillChip('Kubernetes'),
              _buildSkillChip('Docker'),
              _buildSkillChip('Terraform'),
              _buildSkillChip('Python'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String skill) {
    return Chip(
      label: Text(skill),
      backgroundColor: const Color(0xFF60a5fa),
      labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildAbout() {
    return Container(
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
            'Senior SRE/DevOps Engineer with 4+ years of experience in cloud infrastructure, automation, and system reliability. Specialized in AWS, GCP, Kubernetes, and CI/CD pipelines.',
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
              _buildStatCard('4+', 'Years Experience'),
              _buildStatCard('50+', 'Projects Completed'),
              _buildStatCard('3', 'Companies'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String number, String label) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1e293b),
        borderRadius: BorderRadius.circular(12),
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
              _buildSkillCard(Icons.cloud, 'AWS/GCP', 'Cloud Platforms'),
              _buildSkillCard(Icons.settings, 'Kubernetes', 'Container Orchestration'),
              _buildSkillCard(Icons.code, 'Python/Bash', 'Scripting & Automation'),
              _buildSkillCard(Icons.security, 'DevSecOps', 'Security & Monitoring'),
              _buildSkillCard(Icons.build, 'CI/CD', 'Jenkins, GitLab CI'),
              _buildSkillCard(Icons.storage, 'Terraform', 'Infrastructure as Code'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkillCard(IconData icon, String title, String subtitle) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0f172a),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF60a5fa), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: const Color(0xFF60a5fa)),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF94a3b8),
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
          _buildExperienceCard(
            'Sr. SRE/DevOps Engineer',
            'Fleetx',
            'Apr 2024 - Present',
            'Built CI/CD pipelines, migrated to Kubernetes, implemented security monitoring',
          ),
          _buildExperienceCard(
            'DevOps Engineer',
            'Ontic',
            'Sep 2023 - Apr 2024',
            'Managed GCP Kubernetes clusters, designed CI/CD workflows with Helm',
          ),
          _buildExperienceCard(
            'DevOps Engineer',
            'Nykaa',
            'Sep 2021 - Sep 2023',
            'Deployed scalable apps on ECS/EKS, automated workflows with Python/Lambda',
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceCard(String role, String company, String duration, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1e293b),
        borderRadius: BorderRadius.circular(12),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildProjectCard('Task Manager', 'Django + PostgreSQL', Icons.task),
              _buildProjectCard('ML Recognition', 'OpenCV + Python', Icons.visibility),
              _buildProjectCard('Web to App', 'Flutter + Dart', Icons.web),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(String title, String tech, IconData icon) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0f172a),
        borderRadius: BorderRadius.circular(12),
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
          ),
        ],
      ),
    );
  }

  Widget _buildContact() {
    return Container(
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
              _buildContactButton(Icons.email, 'Email', 'mailto:agarwalsatyam027@gmail.com'),
              _buildContactButton(Icons.phone, 'Call', 'tel:+918058083031'),
              _buildContactButton(Icons.work, 'LinkedIn', 'https://www.linkedin.com/in/satyam-a-a36b3217b'),
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
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
          ),
        ],
      ),
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