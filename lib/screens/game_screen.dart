// lib/screens/game_screen.dart

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memorie/widgets/grid_cell.dart';
import 'package:memorie/widgets/setting_button.dart';
import '../models/stage.dart';
import '../constants/colors.dart';

class GameScreen extends StatefulWidget {
  final GameStage gameStage;

  const GameScreen({super.key, required this.gameStage});

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

  // バナーのテキストを制御するためのフィールド
  String _bannerText = '';

  final Random _random = Random();

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

  @override
  void initState() {
    super.initState();
    _startGame();
    _bannerController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  // Memory... バナーを表示してアニメーションを開始
  void _showMemoryBanner() async {
    setState(() {
      _bannerText = 'Memory...';
    });
    await Future.delayed(const Duration(seconds: 1));

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
      _bannerText = 'START!';
    });
    await Future.delayed(const Duration(seconds: 1));

    _bannerController.forward();

    await Future.delayed(const Duration(seconds: 2));

    _bannerController.reset();
    setState(() {
      _bannerText = '';
    });

    setState(() {
      _isUserTurn = true;
    });
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
      // 発光時間
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _currentStep = -1;
      });
      // 非アクティブ時間
      // TODO.ここでSTART!表示を追加する
      await Future.delayed(const Duration(milliseconds: 1));
    }
    _showStartBanner();
  }

  // ユーザーがマスをタップした時の処理
  void _handleUserTap(int index) {
    print("User tapped: $index"); // デバッグ用
    if (!_isUserTurn) return;

    setState(() {
      _userInput.add(index);
    });

    if (_userInput[_userInput.length - 1] != _sequence[_userInput.length - 1]) {
      // 不正解
      setState(() {
        _misTappedIndex = index; // ミスタップしたインデックスを記録
      });
      _showResultDialog(false);
      return;
    }

    if (_userInput.length == _sequence.length) {
      // 正解
      _showResultDialog(true);
    }
  }

  // 結果を表示するダイアログ
  void _showResultDialog(bool isSuccess) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(isSuccess ? 'クリア！' : '失敗'),
        content:
            Text(isSuccess ? 'おめでとうございます！ステージをクリアしました。' : '残念！もう一度挑戦してください。'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (isSuccess) {
                Navigator.pop(context, true); // 成功時に前の画面に戻る際にtrueを返す
              } else {
                _restartGame();
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
                  image: AssetImage(widget.gameStage.backgroundGameScreenImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerRight,
                        child: SettingButtonWidget(
                          iconSize: 24,
                          fontSize: 24,
                          iconColor: AppColors.black,
                        ),
                      ),
                      // ステージタイトル
                      Text(
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
                      const SizedBox(height: 120.0),
                      // ゲームの中心となるマスウィジェットのグリッド
                      Center(
                        child: SizedBox(
                          width: 200, // グリッドの幅を指定
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
                                  isCorrectTapped: _userInput.contains(index),
                                  isMisTapped: _misTappedIndex == index,
                                );
                              } else {
                                // 空のスペースを保持
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.transparent, // 必要に応じて色を設定
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
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
          ],
        ),
      ),
    );
  }
}
