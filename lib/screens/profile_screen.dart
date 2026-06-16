// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/app_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    final stats = [
      {'label': 'Batches', 'value': '24'},
      {'label': 'Sold (kg)', 'value': '1,840'},
      {'label': 'Revenue', 'value': '₹5.6L'},
      {'label': 'Rating', 'value': '4.8★'},
    ];

    final menuItems = [
      {
        'icon': Icons.sensors_rounded,
        'title': 'Device Settings',
        'subtitle': 'Manage Raspberry Pi & sensors',
        'color': 0xFF2563FF,
      },
      {
        'icon': Icons.notifications_rounded,
        'title': 'Notifications',
        'subtitle': 'Alerts, reports, market updates',
        'color': 0xFF00CFFD,
      },
      {
        'icon': Icons.language_rounded,
        'title': 'Language',
        'subtitle': 'English (India)',
        'color': 0xFF7C3AED,
      },
      {
        'icon': Icons.lock_rounded,
        'title': 'Privacy & Security',
        'subtitle': 'Account protection',
        'color': 0xFF00F5A0,
      },
      {
        'icon': Icons.help_rounded,
        'title': 'Help & Support',
        'subtitle': 'FAQs, contact us',
        'color': 0xFFFFBB33,
      },
      {
        'icon': Icons.info_rounded,
        'title': 'About WoolSense',
        'subtitle': 'Version 1.0.0',
        'color': 0xFF3D4F7C,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF05060F),
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                child: Text(
                  'Profile',
                  style: GoogleFonts.outfit(
                    color: const Color(0xFFEFF2FF),
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(child: _profileCard(provider, stats)),
            SliverToBoxAdapter(child: _badges()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 10),
                child: Text(
                  'SETTINGS',
                  style: GoogleFonts.dmSans(
                    color: const Color(0xFF3D4F7C),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: _menuItem(menuItems[i]),
                ),
                childCount: menuItems.length,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: const Color(0xFFFF3D6B).withOpacity(0.08),
                      border: Border.all(
                        color: const Color(0xFFFF3D6B).withOpacity(0.22),
                        width: 0.8,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Sign Out',
                        style: GoogleFonts.dmSans(
                          color: const Color(0xFFFF3D6B),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 110)),
          ],
        ),
      ),
    );
  }

  Widget _profileCard(AppProvider provider, List<Map<String, String>> stats) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF0A0C1C),
        border: Border.all(
          color: const Color(0xFF2563FF).withOpacity(0.18),
          width: 0.8,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF2563FF), Color(0xFF00CFFD)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Text(
                    provider.userName.isNotEmpty
                        ? provider.userName[0].toUpperCase()
                        : 'U',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.userName,
                      style: GoogleFonts.outfit(
                        color: const Color(0xFFEFF2FF),
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Premium Wool Farmer',
                      style: GoogleFonts.dmSans(
                        color: const Color(0xFF4F8EFF),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          color: Color(0xFF3D4F7C),
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Nasik, Maharashtra',
                          style: GoogleFonts.dmSans(
                            color: const Color(0xFF7B8EC8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFF2563FF).withOpacity(0.08),
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  color: Color(0xFF4F8EFF),
                  size: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black.withOpacity(0.22),
            ),
            child: Row(
              children: stats
                  .map(
                    (s) => Expanded(
                      child: Column(
                        children: [
                          Text(
                            s['value']!,
                            style: GoogleFonts.outfit(
                              color: const Color(0xFFEFF2FF),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            s['label']!,
                            style: GoogleFonts.dmSans(
                              color: const Color(0xFF7B8EC8),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _badges() {
    final badges = [
      {
        'icon': Icons.verified_rounded,
        'label': 'Verified',
        'color': 0xFF2563FF,
      },
      {'icon': Icons.star_rounded, 'label': 'Top Seller', 'color': 0xFFFFBB33},
      {'icon': Icons.eco_rounded, 'label': 'Eco Cert', 'color': 0xFF00F5A0},
    ];
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF0A0C1C),
        border: Border.all(
          color: const Color(0xFF2563FF).withOpacity(0.10),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Text(
            'Achievements',
            style: GoogleFonts.outfit(
              color: const Color(0xFFEFF2FF),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          ...badges.map(
            (b) => Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(b['color'] as int).withOpacity(0.12),
                border: Border.all(
                  color: Color(b['color'] as int).withOpacity(0.25),
                  width: 0.6,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    b['icon'] as IconData,
                    color: Color(b['color'] as int),
                    size: 13,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    b['label'] as String,
                    style: GoogleFonts.dmSans(
                      color: Color(b['color'] as int),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(Map<String, dynamic> item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xFF0A0C1C),
        border: Border.all(
          color: const Color(0xFF2563FF).withOpacity(0.08),
          width: 0.6,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(item['color'] as int).withOpacity(0.12),
            ),
            child: Icon(
              item['icon'] as IconData,
              color: Color(item['color'] as int),
              size: 18,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'] as String,
                  style: GoogleFonts.outfit(
                    color: const Color(0xFFEFF2FF),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  item['subtitle'] as String,
                  style: GoogleFonts.dmSans(
                    color: const Color(0xFF7B8EC8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: Color(0xFF3D4F7C),
            size: 18,
          ),
        ],
      ),
    );
  }
}
