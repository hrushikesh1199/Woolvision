// lib/screens/dashboard_screen.dart
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/app_provider.dart';
import '../widgets/quality_score_ring.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late AnimationController _ambientController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;
  final List<_WoolFiber> _fibers = [];

  bool _isRpiConnected = false;
  bool _isConnecting = false;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();

    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOutQuart),
    );
    _headerSlide =
        Tween<Offset>(begin: const Offset(0, -0.08), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _headerController,
            curve: Curves.easeOutQuart,
          ),
        );
    _headerController.forward();

    // Controls the continuous falling animation loop
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25), // Slower for that floaty feel
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    final rng = math.Random();
    // High particle count for a rich ambient atmosphere
    for (int i = 0; i < 45; i++) _fibers.add(_WoolFiber(rng));
  }

  @override
  void dispose() {
    _headerController.dispose();
    _ambientController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // ── Raspberry Pi connection ───────────────────────────────────
  void _connectRpi() async {
    if (_isRpiConnected || _isConnecting) return;
    setState(() => _isConnecting = true);
    await Future.delayed(const Duration(seconds: 5));
    if (!mounted) return;
    setState(() {
      _isConnecting = false;
      _isRpiConnected = true;
    });
    _showSnackbar(
      'Raspberry Pi connected successfully',
      icon: Icons.memory_rounded,
      iconColor: AppColors.green,
    );
  }

  // ── Refresh data ──────────────────────────────────────────────
  void _refreshData() async {
    if (_isRefreshing) return;
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    context.read<AppProvider>().refreshData();
    setState(() => _isRefreshing = false);
  }

  // ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final data = provider.woolData;

    return Stack(
      children: [
        // Deep background neon glows
        Positioned(
          top: -100,
          right: -80,
          child: _glowBlob(450, AppColors.purple, 0.07),
        ),
        Positioned(
          bottom: -50,
          left: -100,
          child: _glowBlob(380, AppColors.cyan, 0.08),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.4,
          left: -50,
          child: _glowBlob(250, AppColors.green, 0.04),
        ),

        // Floating wool/feather system safely constrained to fill the screen
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _ambientController,
            builder: (_, __) => CustomPaint(
              // REMOVED Size.infinite to prevent the Null/NaN crash
              painter: _ParticlePainter(_fibers, _ambientController.value),
            ),
          ),
        ),

        SafeArea(
          bottom: false,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.only(top: 8),
                sliver: SliverToBoxAdapter(child: _buildHeader(provider)),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                sliver: SliverToBoxAdapter(child: _buildRpiButton()),
              ),
              if (_isRefreshing)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  sliver: SliverToBoxAdapter(child: _buildLoader()),
                )
              else ...[
                // ── Professional Metric Cards ──────────────────────────────
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.0,
                        ),
                    delegate: SliverChildListDelegate([
                      _buildCleanMetricCard(
                        title: 'MOISTURE',
                        value: '${data.moistureLevel}',
                        unit: '%',
                        icon: Icons.water_drop,
                        accentColor: AppColors.cyan,
                      ),
                      _buildCleanMetricCard(
                        title: 'COLOR GRADE',
                        value: data.colorGrade.contains(' ')
                            ? data.colorGrade.split(' ')[1]
                            : data.colorGrade,
                        unit: data.colorGrade.contains(' ')
                            ? data.colorGrade.split(' ')[0]
                            : '',
                        icon: Icons.remove_red_eye_rounded,
                        accentColor: AppColors.purple,
                      ),
                      _buildCleanMetricCard(
                        title: 'WEIGHT',
                        value: '${data.weight.toInt()}',
                        unit: 'g',
                        icon: Icons.movie_creation_outlined,
                        accentColor: AppColors.w70,
                      ),
                      _buildCleanMetricCard(
                        title: 'TEMP',
                        value: '${data.temperature}',
                        unit: '°C',
                        icon: Icons.calendar_today_rounded,
                        accentColor: AppColors.w70,
                      ),
                    ]),
                  ),
                ),
                // ── Quality ───────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
                    child: _buildQuality(data.qualityScore, data.qualityLabel),
                  ),
                ),
                // ── Chart ─────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                    child: _buildChart(data.trendData),
                  ),
                ),
                // ── Action buttons ────────────────────────────
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 110),
                  sliver: SliverToBoxAdapter(child: _buildActions()),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // ── Clean Data Metric Card ──────────────────────────────────────────────────
  Widget _buildCleanMetricCard({
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required Color accentColor,
  }) {
    final displayTitle = title
        .split(' ')
        .map((w) {
          if (w.isEmpty) return '';
          return w[0].toUpperCase() + w.substring(1).toLowerCase();
        })
        .join(' ');

    final isNeutral = accentColor == AppColors.w70;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.bg2,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isNeutral ? AppColors.border : accentColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isNeutral ? Colors.black12 : accentColor.withOpacity(0.08),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accentColor, size: 26),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: GoogleFonts.syne(
                  color: AppColors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.0,
                  height: 1.0,
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    unit,
                    style: GoogleFonts.dmSans(
                      color: AppColors.w70,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            displayTitle,
            style: GoogleFonts.dmSans(
              color: AppColors.w40,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────
  Widget _buildHeader(AppProvider provider) {
    return FadeTransition(
      opacity: _headerFade,
      child: SlideTransition(
        position: _headerSlide,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome back,', style: AppTextStyles.bodySmall),
                    const SizedBox(height: 2),
                    Text(provider.userName, style: AppTextStyles.displayMedium),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        AnimatedBuilder(
                          animation: _pulseAnim,
                          builder: (_, __) => Opacity(
                            opacity: _isRpiConnected ? _pulseAnim.value : 1.0,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: _isRpiConnected
                                    ? AppColors.green
                                    : AppColors.w40,
                                shape: BoxShape.circle,
                                boxShadow: _isRpiConnected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.green.withOpacity(
                                            0.5,
                                          ),
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                        ),
                                      ]
                                    : null,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          _isRpiConnected
                              ? 'Raspberry Pi • Live'
                              : 'Raspberry Pi • Disconnected',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: _isRpiConnected
                                ? AppColors.green
                                : AppColors.w40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Refresh
              GestureDetector(
                onTap: _refreshData,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.bg3,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: _isRefreshing
                      ? Center(
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                              color: AppColors.cyan,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.refresh_rounded,
                          color: AppColors.w70,
                          size: 18,
                        ),
                ),
              ),
              const SizedBox(width: 10),
              // Avatar
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                ),
                child: Center(
                  child: Text(
                    provider.userName.isNotEmpty
                        ? provider.userName[0].toUpperCase()
                        : 'U',
                    style: GoogleFonts.syne(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Raspberry Pi Button ───────────────────────────────────────
  Widget _buildRpiButton() {
    return GestureDetector(
      onTap: _connectRpi,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _isRpiConnected
              ? AppColors.green.withOpacity(0.05)
              : AppColors.bg2,
          border: Border.all(
            color: _isRpiConnected
                ? AppColors.green.withOpacity(0.3)
                : AppColors.border,
          ),
          boxShadow: _isRpiConnected
              ? [
                  BoxShadow(
                    color: AppColors.green.withOpacity(0.05),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                color: _isRpiConnected
                    ? AppColors.green.withOpacity(0.1)
                    : AppColors.bg3,
              ),
              child: Icon(
                _isRpiConnected
                    ? Icons.memory_rounded
                    : Icons.device_hub_rounded,
                color: _isRpiConnected ? AppColors.green : AppColors.w70,
                size: 18,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isRpiConnected
                        ? 'Raspberry Pi Connected'
                        : 'Connect Raspberry Pi',
                    style: AppTextStyles.labelLarge,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    _isRpiConnected
                        ? 'Receiving live sensor data'
                        : 'Tap to pair your sensor device',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            if (_isConnecting)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.cyan,
                ),
              )
            else if (_isRpiConnected)
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.green,
                size: 20,
              )
            else
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.w40,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  // ── Refresh loader ────────────────────────────────────────────
  Widget _buildLoader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: const AlwaysStoppedAnimation(AppColors.purple),
              backgroundColor: AppColors.purple.withOpacity(0.1),
            ),
          ),
          const SizedBox(height: 16),
          Text('Fetching new readings...', style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }

  // ── Quality Diagnostics ───────────────────────────────────────
  Widget _buildQuality(int score, String label) {
    return _Card(
      child: Column(
        children: [
          Row(
            children: [
              _accent(AppColors.accentGradient),
              const SizedBox(width: 12),
              Text('Quality Diagnostics', style: AppTextStyles.headingSmall),
              const Spacer(),
              _badge('BATCH A-192', AppColors.cyan),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              QualityScoreRing(score: score, label: label),
              const SizedBox(width: 22),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: AppTextStyles.displaySmall),
                    const SizedBox(height: 6),
                    Text(
                      'Premium grade fiber with minimal moisture variance.',
                      style: AppTextStyles.bodySmall.copyWith(height: 1.5),
                    ),
                    const SizedBox(height: 18),
                    _legend('Excellent', 90, AppColors.green),
                    const SizedBox(height: 5),
                    _legend('Acceptable', 70, AppColors.cyan),
                    const SizedBox(height: 5),
                    _legend('Subpar', 50, AppColors.pink),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legend(String label, int threshold, Color color) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text('$label (≥$threshold)', style: AppTextStyles.bodySmall),
      ],
    );
  }

  // ── Chart ─────────────────────────────────────────────────────
  Widget _buildChart(List<double> trendData) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _accent(AppColors.primaryGradient),
              const SizedBox(width: 12),
              Text('Trend Analysis', style: AppTextStyles.headingSmall),
              const Spacer(),
              Text('7-Day Average', style: AppTextStyles.bodySmall),
            ],
          ),
          const SizedBox(height: 26),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: AppColors.border,
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 20,
                      reservedSize: 30,
                      getTitlesWidget: (val, _) => Text(
                        '${val.toInt()}',
                        style: GoogleFonts.dmMono(
                          color: AppColors.w40,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (val, _) {
                        final i = val.toInt();
                        if (i >= 0 && i < days.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              days[i],
                              style: AppTextStyles.bodySmall,
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 40,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      trendData.length,
                      (i) => FlSpot(i.toDouble(), trendData[i]),
                    ),
                    isCurved: true,
                    curveSmoothness: 0.35,
                    gradient: AppColors.accentGradient,
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                        radius: 4,
                        color: AppColors.bg3,
                        strokeWidth: 2,
                        strokeColor: AppColors.cyan,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.purple.withOpacity(0.15),
                          AppColors.purple.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => AppColors.bg3,
                    tooltipPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    getTooltipItems: (spots) => spots
                        .map(
                          (s) => LineTooltipItem(
                            s.y.toStringAsFixed(1),
                            GoogleFonts.dmMono(
                              color: AppColors.cyan,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Action Buttons ────────────────────────────────────────────
  Widget _buildActions() {
    return Column(
      children: [
        _actionBtn(
          label: 'Export Analytics Report',
          icon: Icons.analytics_outlined,
          color: AppColors.purple,
          onTap: () => _showSnackbar('Generating PDF analytics...'),
        ),
        const SizedBox(height: 12),
        _actionBtn(
          label: 'Sync to Cloud Database',
          icon: Icons.cloud_sync_outlined,
          color: AppColors.cyan,
          onTap: () => _showSnackbar('Syncing to secure server...'),
        ),
      ],
    );
  }

  Widget _actionBtn({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: AppColors.bg2,
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 10),
            Text(label, style: AppTextStyles.labelLarge.copyWith(color: color)),
          ],
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────
  Widget _glowBlob(double size, Color color, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withOpacity(opacity), Colors.transparent],
        ),
      ),
    );
  }

  Widget _accent(LinearGradient g) => Container(
    width: 3,
    height: 16,
    decoration: BoxDecoration(
      gradient: g,
      borderRadius: BorderRadius.circular(2),
    ),
  );

  Widget _badge(String text, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: color.withOpacity(0.3), width: 0.8),
    ),
    child: Text(
      text,
      style: GoogleFonts.dmMono(
        color: color,
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.0,
      ),
    ),
  );

  void _showSnackbar(
    String msg, {
    IconData icon = Icons.check_circle_outline,
    Color iconColor = AppColors.green,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: iconColor, size: 18),
            const SizedBox(width: 10),
            Text(
              msg,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white),
            ),
          ],
        ),
        backgroundColor: AppColors.bg3,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: AppColors.border),
        ),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      ),
    );
  }
}

// ── Re-usable card shell ──────────────────────────────────────────────────────
class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.bg2,
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            spreadRadius: 2,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ── Particle System (Overhauled for Seamless, Flawless Physics) ───────────────
class _WoolFiber {
  double x, y, size, opacity, rotation;
  double speedMult, hOffset, hSpeedMult;

  _WoolFiber(math.Random r)
    : x = r.nextDouble(),
      y = r.nextDouble(),
      size = r.nextDouble() * 3.5 + 2.0,
      opacity = r.nextDouble() * 0.25 + 0.08,
      rotation = r.nextDouble() * math.pi,
      // Using whole integers guarantees that when `t` resets from 1.0 back to 0.0,
      // the modulo arithmetic loops perfectly without visual "snapping".
      speedMult = (r.nextInt(3) + 2).toDouble(),
      hOffset = r.nextDouble() * math.pi * 2,
      hSpeedMult = (r.nextInt(2) + 1).toDouble();
}

class _ParticlePainter extends CustomPainter {
  final List<_WoolFiber> fibers;
  final double t; // Ranges from 0.0 -> 1.0 over 25 seconds
  _ParticlePainter(this.fibers, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      // Gaussian blur creates the soft, out-of-focus fluffy look
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);

    for (final f in fibers) {
      // 1. Gravity: Because speedMult is an integer, `t * speedMult` lands on a whole number when t=1.0.
      double cy = (f.y + t * f.speedMult) % 1.0;

      // 2. Sway: Sine wave oscillation based on the exact same loop math.
      double cx =
          f.x + math.sin(t * math.pi * 2 * f.hSpeedMult + f.hOffset) * 0.08;

      // Wrap around X bounds gracefully
      if (cx < -0.1) cx += 1.2;
      if (cx > 1.1) cx -= 1.2;

      paint.color = AppColors.cyan.withOpacity(f.opacity);

      canvas.save();
      canvas.translate(cx * size.width, cy * size.height);
      canvas.rotate(
        f.rotation + math.sin(t * math.pi * 2 * f.hSpeedMult + f.hOffset) * 0.6,
      );

      // Draw a custom path (wispy leaf/feather shape) rather than a blocky oval
      Path path = Path();
      path.moveTo(0, -f.size * 2);
      path.quadraticBezierTo(f.size, 0, 0, f.size * 2);
      path.quadraticBezierTo(-f.size, 0, 0, -f.size * 2);
      canvas.drawPath(path, paint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter old) => old.t != t;
}
