import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_app/l10n/app_localizations.dart';
import '../theme/design_system.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.privacyPolicy,
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
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            const Text(
              'プライバシーポリシー（サンプル）\n\n'
              '1. 取得する情報 当社は、以下の情報を取得します。 ⽒名、電話番号、メールアドレス 銀行口座登録、ポイント利⽤履歴 端末情報、アクセスログ 端末識別⼦、Cookie 等の技術情報 \n\n'
              '2. 利⽤⽬的 取得した個⼈情報は、以下の⽬的で利⽤します。 本サービスの提供・運営 本⼈確認、不正利⽤防⽌ 問い合わせ対応 法令遵守および監査対応 \n\n'
              '3. 第三者提供 当社は、法令に基づく場合を除き、本⼈の同意なく個⼈情報を第三者に提供しません。 \n\n'
              '4. 業務委託 当社は、利⽤⽬的の達成に必要な範囲で、個⼈情報の取扱いを委託することがあります。 この場合、当社は、委託先に対して適切な監督を⾏います。\n\n'
              '5. 安全管理 当社は、個⼈情報の漏洩・滅失・毀損を防⽌するため、合理的な安全管理措置を講じま す。\n\n'
              ' 6. 開⽰・訂正・削除 利⽤者は、当社所定の⽅法により⾃⼰の個⼈情報の開⽰・訂正・削除を請求できます。\n\n',
              style: TextStyle(height: 1.6, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
