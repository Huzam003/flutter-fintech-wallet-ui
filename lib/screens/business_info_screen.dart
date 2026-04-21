import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/design_system.dart';

class BusinessInfoScreen extends StatelessWidget {
  const BusinessInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          '事業者情報',
          style: GoogleFonts.inter(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryBlue),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // FTS Logo
            Center(
              child: Image.asset(
                'assets/icons/fts_logo.png',
                height: 227,
                width: 227,
              ),
            ),
            const SizedBox(height: 30),

            // Section Title
            Text(
              '事業者情報（サンプル）',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),

            // Business Details
            _buildInfoRow('事業者名', '株式会社ジャパンエクスチェンジ'),
            _buildInfoRow('所在地', '〒151-0066 東京都渋谷区西原 2-5-10 西原ヒルズ'),
            _buildInfoRow('代表者', '代表取締役 山下 幸男'),
            _buildInfoRow('問い合わせ先', '***@jpx.jp'),
            _buildInfoRow('受付時間', '平日 10:00〜18:00'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Text('：', style: TextStyle(color: Colors.white)),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
