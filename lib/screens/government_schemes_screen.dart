import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';
import '../widgets/app_header.dart';

class GovernmentSchemesScreen extends StatelessWidget {
  const GovernmentSchemesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppHeader(
        title: "Government Schemes",
        currentPage: "government_schemes",
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.account_balance,
                      color: Colors.white,
                      size: 32,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Government Support for Women & Mothers',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Access official government websites and schemes designed to support women during pregnancy and motherhood.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // National Schemes Section
              _buildSectionHeader(
                context,
                'National Government Schemes',
                Icons.flag,
                AppColors.primary,
              ),
              const SizedBox(height: 16),
              
              _buildSchemeCard(
                title: 'Pradhan Mantri Matru Vandana Yojana (PMMVY)',
                description: 'Maternity benefit program providing financial assistance to pregnant and lactating mothers.',
                website: 'https://pmmvy.nic.in/',
                icon: Icons.pregnant_woman,
                color: AppColors.primary,
              ),
              
              _buildSchemeCard(
                title: 'Janani Suraksha Yojana (JSY)',
                description: 'Safe motherhood intervention to reduce maternal and neonatal mortality.',
                website: 'https://nhm.gov.in/index1.php?lang=1&level=3&sublinkid=841&lid=309',
                icon: Icons.health_and_safety,
                color: AppColors.success,
              ),
              
              _buildSchemeCard(
                title: 'Beti Bachao Beti Padhao',
                description: 'Government initiative to generate awareness and improve efficiency of welfare services for girls.',
                website: 'https://wcd.nic.in/bbbp-scheme',
                icon: Icons.school,
                color: AppColors.accent,
              ),
              
              _buildSchemeCard(
                title: 'Anganwadi Services (ICDS)',
                description: 'Integrated Child Development Services providing nutrition and healthcare.',
                website: 'https://icds-wcd.nic.in/',
                icon: Icons.child_care,
                color: AppColors.secondary,
              ),
              
              const SizedBox(height: 24),
              
              // Healthcare Resources Section
              _buildSectionHeader(
                context,
                'Healthcare Resources',
                Icons.local_hospital,
                AppColors.success,
              ),
              const SizedBox(height: 16),
              
              _buildSchemeCard(
                title: 'National Health Portal',
                description: 'Official health portal providing authentic health information and services.',
                website: 'https://www.nhp.gov.in/',
                icon: Icons.medical_services,
                color: AppColors.success,
              ),
              
              _buildSchemeCard(
                title: 'Ayushman Bharat',
                description: 'National Health Protection Scheme providing health insurance coverage.',
                website: 'https://pmjay.gov.in/',
                icon: Icons.favorite,
                color: AppColors.error,
              ),
              
              _buildSchemeCard(
                title: 'LaQshya - Labour Room Quality Improvement',
                description: 'Initiative to improve quality of care in labour rooms and maternity OTs.',
                website: 'https://nhm.gov.in/index1.php?lang=1&level=2&sublinkid=1019&lid=49',
                icon: Icons.local_hospital,
                color: AppColors.warning,
              ),
              
              const SizedBox(height: 24),
              
              // Women Empowerment Section
              _buildSectionHeader(
                context,
                'Women Empowerment',
                Icons.female,
                AppColors.accent,
              ),
              const SizedBox(height: 16),
              
              _buildSchemeCard(
                title: 'Ministry of Women & Child Development',
                description: 'Official ministry website with comprehensive information on women welfare schemes.',
                website: 'https://wcd.nic.in/',
                icon: Icons.female,
                color: AppColors.accent,
              ),
              
              _buildSchemeCard(
                title: 'Mahila Shakti Kendra',
                description: 'Community-level structures to empower rural women through skill development.',
                website: 'https://wcd.nic.in/schemes/mahila-shakti-kendra-msk',
                icon: Icons.groups,
                color: AppColors.secondary,
              ),
              
              _buildSchemeCard(
                title: 'Stand Up India',
                description: 'Facilitating bank loans for SC/ST and women entrepreneurs.',
                website: 'https://www.standupmitra.in/',
                icon: Icons.business_center,
                color: AppColors.primary,
              ),
              
              const SizedBox(height: 24),
              
              // Emergency & Helplines Section
              _buildSectionHeader(
                context,
                'Emergency & Helplines',
                Icons.phone,
                AppColors.error,
              ),
              const SizedBox(height: 16),
              
              _buildSchemeCard(
                title: 'Women Helpline - 181',
                description: '24x7 toll-free helpline for women in distress.',
                website: 'tel:181',
                icon: Icons.phone,
                color: AppColors.error,
              ),
              
              _buildSchemeCard(
                title: 'Child Helpline - 1098',
                description: '24-hour emergency phone service for children in need of care and protection.',
                website: 'tel:1098',
                icon: Icons.child_friendly,
                color: AppColors.warning,
              ),
              
              const SizedBox(height: 24),
              
              // Disclaimer
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'These are official government websites. Please verify eligibility criteria and application processes on the respective websites. For technical issues with websites, contact the respective government departments.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSectionHeader(BuildContext context, String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
  
  Widget _buildSchemeCard({
    required String title,
    required String description,
    required String website,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _launchURL(website),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.launch,
                            size: 16,
                            color: color,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Visit Website',
                            style: TextStyle(
                              fontSize: 14,
                              color: color,
                              fontWeight: FontWeight.w600,
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
      ),
    );
  }
  
  Future<void> _launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      // You could show a snackbar or dialog here to inform the user
    }
  }
}
