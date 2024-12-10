import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:memorie/constants/colors.dart';
import 'package:memorie/constants/stage_list.dart';
import 'package:memorie/screens/sub_stage_selection_screen.dart';
import 'package:memorie/utils/ad_id.dart';
import 'package:memorie/widgets/back_button.dart';
import 'package:memorie/widgets/stage_card.dart';

class StageSelectionScreen extends StatefulWidget {
  const StageSelectionScreen({super.key});

  @override
  State<StageSelectionScreen> createState() => _StageSelectionScreenState();
}

class _StageSelectionScreenState extends State<StageSelectionScreen> {
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  final id = getAdBannerUnitId();

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: id,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('lib/assets/backgrounds/bg.png'),
              fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.centerLeft, // ボタンを左揃え
                  child: BackButtonWidget(
                    label: 'Back',
                    iconColor: AppColors.black,
                    textColor: AppColors.black,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    itemCount: stages.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, // 横に表示するアイテム数は1
                      mainAxisSpacing: 4.0,
                      childAspectRatio: 4 / 1,
                    ),
                    itemBuilder: (context, index) {
                      final stage = stages[index]; // ここはMainStageが格納されている想定
                      return InkWell(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SubStageSelectionScreen(stage: stage),
                            ),
                          );

                          if (result == true) {
                            setState(() {});
                          }
                        },
                        child: StageCard(stage: stage),
                      );
                    },
                  ),
                ),
              ),
              if (_isBannerAdReady)
                SizedBox(
                  width: _bannerAd.size.width.toDouble(),
                  height: _bannerAd.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
