import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_app/l10n/app_localizations.dart';
import '../theme/design_system.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.termsOfUse,
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
              '利⽤規約（サンプル）\n\n'
              '第 1 条（⽬的） 本利⽤規約（以下「本規約」といいます）は、株式会社ジャパンエクスチェンジ（以下 「当社」といいます）が提供するポイントサービス「GLAUX・FTS」（以下「本サービ ス」といいます）の利⽤条件を定めるものです。 利⽤者は、本規約に同意の上、本サービスを利⽤するものとします。 \n\n'
              '第 2 条（ポイントの性質） 本サービスにおいて発⾏されるポイント（以下「本ポイント」といいます）は、当社が定 める加盟店舗においてのみ利⽤可能な、6 か⽉間の有効期限を有するポイントです。 本ポイントは、資⾦決済法上の前払式⽀払⼿段には該当しないものとして設計・運⽤され ています。 本ポイントは、現⾦、有価証券、電⼦マネー等への交換はできません。\n\n'
              '第3 条（ポイントの発⾏） 本ポイントは、利⽤者が当社指定の⽅法により対価を⽀払った場合に発⾏されます。 ポイントの発⾏時期は、当社所定の確認⼿続完了後とします。 技術的または⾦融機関の事情により、ポイント反映まで時間を要する場合があります。 \n\n'
              '第 4 条（ポイントの有効期限） 本ポイントの有効期限は、発⾏⽇から 6 か⽉間とします。 有効期限を経過したポイントは、理由の如何を問わず⾃動的に失効し、利⽤・返⾦・再発 ⾏はできません。\n\n'
              '第 5 条（ポイントの利⽤） 本ポイントは、加盟店舗における商品またはサービスの⽀払いにのみ利⽤できます。 ⼀部商品・サービスについてはポイント利⽤が制限される場合があります。 加盟店舗の都合、システム制約、法令その他の理由により、ポイントの利⽤可否は変動す る場合があります。\n\n'
              '第6 条（ポイントの払い戻し） 本ポイントは、原則として払い戻しできません。 ただし、以下の場合に限り、当社の判断により払い戻しを⾏うことがあります。 システム障害等、当社の責に帰すべき事由により利⽤不能となった場合 払い戻しの可否、⽅法および条件については、当社が合理的裁量により判断するものとし ます。\n\n'
              '第7 条（禁⽌事項） 利⽤者は、以下の⾏為を⾏ってはなりません。 不正取得、不正利⽤ 第三者への譲渡・貸与・担保提供 法令または公序良俗に反する⾏為 \n\n'
              '第 8 条（免責） 当社は、加盟店舗が提供する商品・サービスの内容について⼀切の責任を負いません。 天災、通信障害、⾦融機関の障害等、当社の合理的⽀配を超える事由による損害について 責任を負いません。 \n\n'
              '第9 条（規約の変更） 当社は、必要に応じて本規約を変更することができます。変更後の規約は、アプリ内掲⽰ をもって効⼒を⽣じます。 変更後も本サービスを利⽤した場合、当該変更に同意したものとみなします。\n\n'
              '第 10 条（準拠法・管轄） 本規約は⽇本法に準拠し、本サービスに関する紛争は東京地⽅裁判所を第⼀審の専属的合 意管轄裁判所とします。\n\n',
              style: TextStyle(height: 1.6, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
