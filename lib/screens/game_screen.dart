// lib/screens/game_screen.dart

import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:memorie/constants/colors.dart';
import 'package:memorie/models/stage.dart';
import 'package:memorie/services/stage_persistence_service.dart';
import 'package:memorie/utils/ad_id.dart';
import 'package:memorie/widgets/grid_cell.dart';
import 'package:memorie/widgets/setting_button.dart';
import 'package:memorie/widgets/title_painter.dart';

class GameScreen extends StatefulWidget {
  final GameStage gameStage;
  final String backGroundImagePath;

  const GameScreen(
      {super.key, required this.gameStage, required this.backGroundImagePath});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  List<int> _sequence = []; // 発光シーケンス（マスのインデックス）どの順で発行するかをランダムに保持
  int _currentStep = -1; // 現在の発光ステップ (-1は非アクティブ)
  bool _isUserTurn = false; // ユーザーの入力が可能かどうか
  List<int> _userInput = []; // ユーザーの入力シーケンス
  int _misTappedIndex = -1; // 誤タップしたマスのインデックス

  // シーケンス中かどうか
  bool _isDisplayingSequence = false;

  // バナーのテキストを制御するためのフィールド
  String _bannerText = '';

  // クリア判定
  bool _isResultOverlayVisible = false;
  bool _isResultSuccess = false;

  final Random _random = Random();

  // ポーズ状態を管理するためのフィールド
  bool _isPaused = false;

  // アニメーション関連のフィールド
  late final AnimationController _bannerController = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );

  // テキストのスライドアニメーション
  late final Animation<Offset> _textSlideAnimation = Tween<Offset>(
    begin: const Offset(1.0, 0.0), // テキストがボックス右外から開始
    end: const Offset(0.0, 0.0), // テキストがボックス内で停止
  ).animate(CurvedAnimation(
    parent: _bannerController,
    curve: Curves.easeInOut,
  ));

  late final Animation<double> _widthAnimation = Tween<double>(
    begin: 0.0,
    end: MediaQuery.of(context).size.width, // 画面幅いっぱい
  ).animate(CurvedAnimation(
    parent: _bannerController,
    curve: Curves.easeInOut,
  ));

  // ブラシストロークとスプラッターのデータ
  late final List<Path> brushPaths = [];
  late final List<Offset> splatterPositions = [];

  // バナー広告の表示
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  final id = getAdBannerUnitId();

  // インタースティシャル広告の表示
  InterstitialAd? _interstitialAd;

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: getAdInterstitialUnitId(), // インタースティシャル広告のIDを取得
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print('InterstitialAd loaded.');
          _interstitialAd = ad;
          // フルスクリーンコンテンツコールバックを設定
          _interstitialAd?.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _loadInterstitialAd(); // 次回のために再度ロード
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _loadInterstitialAd(); // 再度ロード
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          print("インタースティシャル広告のロード失敗");
          print('InterstitialAd failed to load: $error');
          // 必要に応じて数秒後や次のステップで再ロードを試すことも可能
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
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
    _generateBrushElements();
    _startGame();
    _bannerController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _bannerController.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  // Memory... バナーを表示してアニメーションを開始
  void _showMemoryBanner() async {
    setState(() {
      _bannerText = 'Memory...';
    });
    await Future.delayed(const Duration(milliseconds: 500));

    // バナーアニメーションの開始
    _bannerController.forward();
    // バナーがスライドし終わるまで待機
    await Future.delayed(const Duration(seconds: 2));
    // バナーをリセット
    _bannerController.reset();
    setState(() {
      _bannerText = '';
    });
    // シーケンスの表示を開始
    _displaySequence();
  }

  // ゲーム開始時の初期化
  void _startGame() {
    setState(() {
      _isDisplayingSequence = true;
    });
    _generateSequence();

    _showMemoryBanner();
  }

  // ランダムなシーケンスを生成し、発光順を生成する
  void _generateSequence() {
    // シーケンスを生成
    // trueのマスのインデックスを生成
    _sequence =
        List.generate(widget.gameStage.gridItems.length, (index) => index)
            .where((index) => widget.gameStage.gridItems[index].isViewGrid)
            .toList();
    // リストをシャッフルしてランダムな順序にする
    _sequence.shuffle(_random);
  }

  // START!バナーを表示
  void _showStartBanner() async {
    setState(() {
      _bannerText = 'Do it!';
    });
    // 0.5秒待機
    await Future.delayed(const Duration(milliseconds: 500));

    _bannerController.forward();

    await Future.delayed(const Duration(seconds: 2));

    _bannerController.reset();
    setState(() {
      _bannerText = '';
    });

    setState(() {
      _isUserTurn = true;
    });
    setState(() {
      _isDisplayingSequence = false;
    });
  }

  // ブラシストロークとスプラッターを生成
  void _generateBrushElements() {
    const strokeCount = 200; // ストローク数を調整
    const size = Size(500, 50); // ペイントエリアのサイズに合わせて調整

    // ブラシストロークの生成
    for (int i = 0; i < strokeCount; i++) {
      Path path = Path();
      double startX = _random.nextDouble() * size.width;
      double startY = _random.nextDouble() * size.height;

      path.moveTo(startX, startY);

      int controlPoints = _random.nextInt(3) + 1;
      for (int j = 0; j < controlPoints; j++) {
        double controlX = _random.nextDouble() * size.width;
        double controlY = _random.nextDouble() * size.height;
        double endX = _random.nextDouble() * size.width;
        double endY = _random.nextDouble() * size.height;
        path.quadraticBezierTo(controlX, controlY, endX, endY);
      }

      brushPaths.add(path);
    }

    // スプラッターの位置を生成
    for (int i = 0; i < strokeCount * 2; i++) {
      double x = _random.nextDouble() * size.width;
      double y = _random.nextDouble() * size.height;
      splatterPositions.add(Offset(x, y));
    }
  }

  // シーケンスを順番に表示
  void _displaySequence() async {
    setState(() {
      // 非アクティブ状態 = タップ不可
      _currentStep = -1;
    });

    // ゲーム開始前の待機時間
    await Future.delayed(const Duration(seconds: 1));

    for (int index in _sequence) {
      setState(() {
        _currentStep = index;
      });
      _playNormalSound();

      // 発光時間
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _currentStep = -1;
      });
      // 非アクティブ時間
      await Future.delayed(const Duration(milliseconds: 1));
    }
    _showStartBanner();
  }

  // ユーザーがマスをタップした時の処理
  void _handleUserTap(int index) {
    if (!_isUserTurn) return;

    setState(() {
      _userInput.add(index);
    });

    if (_userInput[_userInput.length - 1] != _sequence[_userInput.length - 1]) {
      _playMisSound();
      // 不正解
      setState(() {
        _misTappedIndex = index; // ミスタップしたインデックスを記録
      });
      _showResultDialog(false);
      return;
    }

    if (_userInput.length == _sequence.length) {
      // クリア
      _playCorrectSound();
      unlockNextStage(widget.gameStage.id);
      _showResultDialog(true);
      return;
    }

    _playNormalSound();
  }

  Future<void> _playCorrectSound() async {
    final player = AudioPlayer();
    await player.play(AssetSource('audio/se/clear_tap.mp3'), volume: 1.2);
  }

  Future<void> _playMisSound() async {
    final player = AudioPlayer();
    await player.play(AssetSource('audio/se/mis_tap.mp3'));
  }

  Future<void> _playNormalSound() async {
    final player = AudioPlayer();
    await player.play(AssetSource('audio/se/normal_tap.mp3'));
  }

  void _showResultOverlay(bool isSuccess) {
    setState(() {
      _isResultOverlayVisible = true;
      _isResultSuccess = isSuccess;
    });

    int random = Random().nextInt(100);
    // 50%の確率でインタースティシャル広告を表示
    if (random < 50) {
      if (_interstitialAd != null) {
        _interstitialAd?.show();
        // show()後はonAdDismissedFullScreenContentでdisposeされるため_ad = null扱い不要
      }
    }
  }

  void _showResultDialog(bool isSuccess) {
    _showResultOverlay(isSuccess);
  }

  // ゲームを再スタート
  void _restartGame() {
    setState(() {
      _sequence = [];
      _currentStep = -1;
      _isUserTurn = false;
      _userInput = [];
      _misTappedIndex = -1;
    });
    _startGame();
  }

  // 歯車ボタンが押されたときに呼ばれるメソッド
  void _onSettingsButtonPressed() {
    if (_isDisplayingSequence) {
      return;
    }

    setState(() {
      _isPaused = true;
    });
  }

  // ポーズメニューの"再開"ボタンが押されたとき
  void _resumeGame() {
    setState(() {
      _isPaused = false;
    });
  }

  // ポーズメニューの"やめる"ボタンが押されたとき
  void _quitGame() {
    Navigator.pop(context);
  }

  void _handleResultOk() {
    setState(() {
      _isResultOverlayVisible = false;
    });
    widget.gameStage.isCleared = true;
    saveStageStates();

    // 成功時に前の画面に戻る際にtrueを返す
    Navigator.pop(context, true);
  }

  void _retryGame() {
    setState(() {
      _isResultOverlayVisible = false;
    });
    _restartGame();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.backGroundImagePath),
                  fit: BoxFit.cover,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: SettingButtonWidget(
                          iconSize: 24,
                          fontSize: 24,
                          iconColor: AppColors.black,
                          onPressed: _onSettingsButtonPressed, // コールバックを渡す
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      // ステージタイトル
                      Stack(
                        children: [
                          CustomPaint(
                            painter: BrushBackgroundPainter(
                              brushPaths: brushPaths,
                              splatterPositions: splatterPositions,
                              color: AppColors.white,
                              splatterRadius: 10.0, // スプラッターの半径を調整
                            ),
                          ),
                          Center(
                            child: Text(
                              widget.gameStage.name,
                              style: GoogleFonts.rockSalt(
                                textStyle: const TextStyle(
                                  fontSize: 36.0,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      // ゲームの中心となるマスウィジェットのグリッド
                      Expanded(
                        child: Center(
                          child: SizedBox(
                            width: 280, // グリッドの幅を指定
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.white.withOpacity(0.8),
                                borderRadius:
                                    BorderRadius.circular(16.0), // 角丸を指定
                              ),
                              padding:
                                  const EdgeInsets.all(20.0), // 必要に応じてパディングを追加
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      widget.gameStage.columnCount, // 列数を設定
                                  mainAxisSpacing: 8.0,
                                  crossAxisSpacing: 8.0,
                                ),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: widget
                                    .gameStage.gridItems.length, // 2x2なので4つのマス
                                itemBuilder: (context, index) {
                                  final gridItem =
                                      widget.gameStage.gridItems[index];
                                  if (gridItem.isViewGrid) {
                                    return GridCellWidget(
                                      isActive: _currentStep == index,
                                      isUserTurn: _isUserTurn,
                                      onTap: () => _handleUserTap(index),
                                      isCorrectTapped:
                                          _userInput.contains(index),
                                      isMisTapped: _misTappedIndex == index,
                                    );
                                  } else {
                                    // 空のスペースを保持
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.transparent, // 必要に応じて色を設定
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
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
            ),
            // バナーアニメーション
            if (_bannerText.isNotEmpty)
              Align(
                alignment: Alignment.centerRight, // ボックスの起点を右に設定
                child: Container(
                  width: _widthAnimation.value,
                  alignment: Alignment.center,
                  height: 120, // バナーの高さ
                  decoration: BoxDecoration(
                    color: _bannerText == 'START!'
                        ? AppColors.cream
                        : AppColors.grey,
                  ),
                  child: SlideTransition(
                    position: _textSlideAnimation,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        _bannerText,
                        maxLines: 1, // テキストを一行に制限
                        overflow: TextOverflow.fade,
                        style: GoogleFonts.hahmlet(
                          textStyle: const TextStyle(
                            fontSize: 48.0,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            if (_isPaused)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.8),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'PAUSE',
                          style: GoogleFonts.rockSalt(
                            textStyle: const TextStyle(
                              fontSize: 36.0,
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 120),
                        TextButton(
                          onPressed: _resumeGame,
                          style: TextButton.styleFrom(
                              splashFactory: NoSplash.splashFactory,
                              overlayColor: Colors.transparent),
                          child: Text(
                            'Resume',
                            style: GoogleFonts.rockSalt(
                              textStyle: const TextStyle(
                                fontSize: 24.0,
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextButton(
                          onPressed: _quitGame,
                          style: TextButton.styleFrom(
                              splashFactory: NoSplash.splashFactory,
                              overlayColor: Colors.transparent),
                          child: Text(
                            'Home',
                            style: GoogleFonts.rockSalt(
                              textStyle: const TextStyle(
                                fontSize: 24.0,
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (_isResultOverlayVisible)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.8),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _isResultSuccess ? 'Clear!' : 'Oops!',
                          style: GoogleFonts.rockSalt(
                            textStyle: const TextStyle(
                              fontSize: 48.0,
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 120),
                        // 失敗時のみリトライボタンを表示
                        if (!_isResultSuccess)
                          Column(
                            children: [
                              TextButton(
                                onPressed: _retryGame,
                                style: TextButton.styleFrom(
                                    splashFactory: NoSplash.splashFactory,
                                    overlayColor: Colors.transparent),
                                child: Text(
                                  'Retry?',
                                  style: GoogleFonts.rockSalt(
                                    textStyle: const TextStyle(
                                      fontSize: 24.0,
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                                style: TextButton.styleFrom(
                                    splashFactory: NoSplash.splashFactory,
                                    overlayColor: Colors.transparent),
                                child: Text(
                                  'Stage Selection',
                                  style: GoogleFonts.rockSalt(
                                    textStyle: const TextStyle(
                                      fontSize: 24.0,
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        // クリア時は次のステージへ進むボタンを表示
                        if (_isResultSuccess)
                          TextButton(
                            onPressed: _handleResultOk,
                            style: TextButton.styleFrom(
                                splashFactory: NoSplash.splashFactory,
                                overlayColor: Colors.transparent),
                            child: Text(
                              'Go To Next Stage',
                              style: GoogleFonts.rockSalt(
                                textStyle: const TextStyle(
                                  fontSize: 24.0,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
