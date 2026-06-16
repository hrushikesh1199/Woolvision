// lib/screens/marketplace_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});
  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  int _selectedCategory = 0;
  final List<String> _categories = [
    'All',
    'Raw Wool',
    'Processed',
    'Merino',
    'Organic',
  ];

  final List<Map<String, dynamic>> _listings = [
    {
      'buyer': 'Pune Textile Mills Pvt Ltd',
      'location': 'Bhosari MIDC, Pune',
      'rating': 4.8,
      'reviews': 142,
      'grade': 'A+',
      'price': 340,
      'unit': 'per kg',
      'minQty': '50 kg',
      'type': 'Raw Wool',
      'verified': true,
      'badge': 'Top Buyer',
      'badgeColor': 0xFF2563FF,
      'distance': '18 km',
      'lastActive': '2 hrs ago',
    },
    {
      'buyer': 'Deccan Wool Exports',
      'location': 'Hadapsar, Pune',
      'rating': 4.6,
      'reviews': 89,
      'grade': 'A',
      'price': 295,
      'unit': 'per kg',
      'minQty': '100 kg',
      'type': 'Processed',
      'verified': true,
      'badge': 'Bulk Buyer',
      'badgeColor': 0xFF0B6FCC,
      'distance': '24 km',
      'lastActive': '5 hrs ago',
    },
    {
      'buyer': 'Mahadeo Fiber Traders',
      'location': 'Pimpri-Chinchwad, Pune',
      'rating': 4.3,
      'reviews': 57,
      'grade': 'B+',
      'price': 270,
      'unit': 'per kg',
      'minQty': '25 kg',
      'type': 'Raw Wool',
      'verified': false,
      'badge': 'New',
      'badgeColor': 0xFF00F5A0,
      'distance': '32 km',
      'lastActive': '1 day ago',
    },
    {
      'buyer': 'Sahyadri Merino House',
      'location': 'Kothrud, Pune',
      'rating': 4.9,
      'reviews': 203,
      'grade': 'Premium',
      'price': 520,
      'unit': 'per kg',
      'minQty': '200 kg',
      'type': 'Merino',
      'verified': true,
      'badge': 'Premium',
      'badgeColor': 0xFF9F6BFF,
      'distance': '12 km',
      'lastActive': '30 min ago',
    },
    {
      'buyer': 'NatureCraft Pune',
      'location': 'Wakad, Pune',
      'rating': 4.5,
      'reviews': 71,
      'grade': 'A',
      'price': 390,
      'unit': 'per kg',
      'minQty': '30 kg',
      'type': 'Organic',
      'verified': true,
      'badge': 'Eco Partner',
      'badgeColor': 0xFF00F5A0,
      'distance': '28 km',
      'lastActive': '3 hrs ago',
    },
    {
      'buyer': 'Shree Ram Wool Agency',
      'location': 'Yerawada, Pune',
      'rating': 4.1,
      'reviews': 34,
      'grade': 'B',
      'price': 240,
      'unit': 'per kg',
      'minQty': '20 kg',
      'type': 'Raw Wool',
      'verified': false,
      'badge': null,
      'badgeColor': null,
      'distance': '15 km',
      'lastActive': '2 days ago',
    },
  ];

  List<Map<String, dynamic>> get _filtered => _selectedCategory == 0
      ? _listings
      : _listings
            .where((l) => l['type'] == _categories[_selectedCategory])
            .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05060F),
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildStats()),
            SliverToBoxAdapter(child: _buildCategories()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
                child: Row(
                  children: [
                    Text(
                      '${_filtered.length} buyers found',
                      style: GoogleFonts.dmSans(
                        color: const Color(0xFF7B8EC8),
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.location_on_rounded,
                      color: Color(0xFF4F8EFF),
                      size: 13,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      'Pune Region',
                      style: GoogleFonts.dmSans(
                        color: const Color(0xFF4F8EFF),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: _buildCard(_filtered[i]),
                ),
                childCount: _filtered.length,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 110)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Marketplace',
                      style: GoogleFonts.outfit(
                        color: const Color(0xFFEFF2FF),
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Verified buyers · Pune region',
                      style: GoogleFonts.dmSans(
                        color: const Color(0xFF7B8EC8),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFF2563FF).withOpacity(0.10),
                  border: Border.all(
                    color: const Color(0xFF2563FF).withOpacity(0.25),
                    width: 0.8,
                  ),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: Color(0xFF4F8EFF),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFF0A0C1C),
              border: Border.all(
                color: const Color(0xFF2563FF).withOpacity(0.12),
                width: 0.8,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.search_rounded,
                  color: Color(0xFF3D4F7C),
                  size: 18,
                ),
                const SizedBox(width: 10),
                Text(
                  'Search buyers, locations...',
                  style: GoogleFonts.dmSans(
                    color: const Color(0xFF3D4F7C),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    final stats = [
      {'label': 'Avg. Price', 'value': '₹318/kg', 'change': '+4.2%'},
      {'label': 'Active Buyers', 'value': '47', 'change': '+3 new'},
      {'label': 'Demand', 'value': 'High', 'change': 'Seasonal'},
    ];
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF2563FF).withOpacity(0.07),
        border: Border.all(
          color: const Color(0xFF2563FF).withOpacity(0.20),
          width: 0.8,
        ),
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
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      s['label']!,
                      style: GoogleFonts.dmSans(
                        color: const Color(0xFF7B8EC8),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: const Color(0xFF00F5A0).withOpacity(0.10),
                      ),
                      child: Text(
                        s['change']!,
                        style: GoogleFonts.dmMono(
                          color: const Color(0xFF00F5A0),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (_, i) {
          final sel = _selectedCategory == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: sel ? const Color(0xFF2563FF) : const Color(0xFF0A0C1C),
                border: Border.all(
                  color: sel
                      ? const Color(0xFF2563FF)
                      : const Color(0xFF2563FF).withOpacity(0.12),
                  width: 0.8,
                ),
              ),
              child: Text(
                _categories[i],
                style: GoogleFonts.dmSans(
                  color: sel ? Colors.white : const Color(0xFF7B8EC8),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> l) {
    final accent = Color(l['badgeColor'] as int? ?? 0xFF2563FF);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF0A0C1C),
        border: Border.all(
          color: const Color(0xFF2563FF).withOpacity(0.10),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: accent.withOpacity(0.14),
                ),
                child: Center(
                  child: Text(
                    (l['buyer'] as String)[0],
                    style: GoogleFonts.outfit(
                      color: accent,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l['buyer'] as String,
                            style: GoogleFonts.outfit(
                              color: const Color(0xFFEFF2FF),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (l['verified'] == true)
                          const Icon(
                            Icons.verified_rounded,
                            color: Color(0xFF4F8EFF),
                            size: 15,
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          color: Color(0xFF3D4F7C),
                          size: 12,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          l['location'] as String,
                          style: GoogleFonts.dmSans(
                            color: const Color(0xFF7B8EC8),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '· ${l['distance']}',
                          style: GoogleFonts.dmSans(
                            color: const Color(0xFF3D4F7C),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Price row
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '₹${l['price']}',
                    style: GoogleFonts.outfit(
                      color: const Color(0xFFEFF2FF),
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    l['unit'] as String,
                    style: GoogleFonts.dmSans(
                      color: const Color(0xFF7B8EC8),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              _pill('Grade ${l['grade']}', const Color(0xFF2563FF)),
              const SizedBox(width: 8),
              _pill('Min ${l['minQty']}', const Color(0xFF3D4F7C)),
              const Spacer(),
              if (l['badge'] != null) _pill(l['badge'] as String, accent),
            ],
          ),
          const SizedBox(height: 14),
          // Rating row
          Row(
            children: [
              const Icon(
                Icons.star_rounded,
                color: Color(0xFFFFBB33),
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                '${l['rating']}',
                style: GoogleFonts.dmSans(
                  color: const Color(0xFFEFF2FF),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(${l['reviews']} reviews)',
                style: GoogleFonts.dmSans(
                  color: const Color(0xFF3D4F7C),
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              Text(
                l['lastActive'] as String,
                style: GoogleFonts.dmSans(
                  color: const Color(0xFF3D4F7C),
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // CTA row
          Row(
            children: [
              Expanded(child: _outlineBtn('View Profile', onTap: () {})),
              const SizedBox(width: 10),
              Expanded(child: _solidBtn('Contact Buyer', onTap: () {})),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pill(String text, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(7),
      color: color.withOpacity(0.12),
      border: Border.all(color: color.withOpacity(0.25), width: 0.6),
    ),
    child: Text(
      text,
      style: GoogleFonts.dmSans(
        color: color,
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  Widget _outlineBtn(String label, {required VoidCallback onTap}) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white.withOpacity(0.03),
            border: Border.all(
              color: const Color(0xFF2563FF).withOpacity(0.18),
              width: 0.8,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.dmSans(
                color: const Color(0xFFEFF2FF),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );

  Widget _solidBtn(String label, {required VoidCallback onTap}) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              colors: [Color(0xFF2563FF), Color(0xFF00CFFD)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.dmSans(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
}
