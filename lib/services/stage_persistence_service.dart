import 'package:memorie/constants/stage_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:memorie/models/stage.dart';

// 全てのステージ（MainStageとGameStage）を保持しているリスト
final List<MainStage> stageList = stages;

/// 起動時やステージ選択画面を表示する前などに呼び出して、
/// unlocked_stages情報を読み込みGameStageに反映する。
Future<void> loadUnlockedStates() async {
  final prefs = await SharedPreferences.getInstance();
  // デフォルトで '1-1' はアンロック済みにしておくなど
  final unlockedIds = prefs.getStringList('unlocked_stages') ?? ['1-1'];
  final clearedIds = prefs.getStringList('cleared_stages') ?? [];

  for (final mainStage in stages) {
    for (final gameStage in mainStage.gameStages) {
      gameStage.isUnlocked = unlockedIds.contains(gameStage.id);
      gameStage.isCleared = clearedIds.contains(gameStage.id);
    }
  }
}

/// ステージクリア後やアンロック状態を更新したタイミングで呼び出し、
/// 現在のアンロック状況を保存する。
Future<void> saveUnlockedStates() async {
  final prefs = await SharedPreferences.getInstance();
  final unlockedIds = <String>[];

  for (final mainStage in stages) {
    for (final gs in mainStage.gameStages) {
      if (gs.isUnlocked) unlockedIds.add(gs.id);
    }
  }

  await prefs.setStringList('unlocked_stages', unlockedIds);
}

/// ステージクリア時に次のステージをアンロックする処理の例
void unlockNextStage(String currentStageId) {
  final parts = currentStageId.split('-'); // '1-1' -> ['1','1']
  final mainId = parts[0]; // '1'
  final currentStageNum = int.parse(parts[1]); // 1
  final nextStageId = "$mainId-${currentStageNum + 1}";

  // メインステージの最後のステージだった場合、次のメインステージの最初のステージをアンロック
  if (currentStageNum == stages.first.gameStages.length) {
    final nextMainStageIndex =
        stages.indexWhere((mainStage) => mainStage.id == mainId) + 1;
    if (nextMainStageIndex < stages.length) {
      final nextMainStage = stages[nextMainStageIndex];
      nextMainStage.gameStages.first.isUnlocked = true;
      saveUnlockedStates(); // 保存
      return;
    }
  }

  for (final mainStage in stages) {
    for (final gameStage in mainStage.gameStages) {
      if (gameStage.id == nextStageId && !gameStage.isUnlocked) {
        gameStage.isUnlocked = true;
        saveUnlockedStates(); // 保存
        return;
      }
    }
  }
}

// saveStageStates()
// ステージのクリア状態を保存する
Future<void> saveStageStates() async {
  final prefs = await SharedPreferences.getInstance();
  final clearedIds = <String>[];

  for (final mainStage in stages) {
    for (final gs in mainStage.gameStages) {
      if (gs.isCleared) clearedIds.add(gs.id);
    }
  }

  await prefs.setStringList('cleared_stages', clearedIds);
}

// ==========================================
// 以下はテスト用の関数
// ==========================================

// 1-1~1-4までのステージをアンロックする
void unlockStageOneToFourStages() {
  // ロック状態をクリア
  for (final mainStage in stages) {
    for (final gameStage in mainStage.gameStages) {
      gameStage.isUnlocked = false;
    }
  }
  for (final mainStage in stages) {
    for (final gameStage in mainStage.gameStages) {
      if (gameStage.id == '1-1' ||
          gameStage.id == '1-2' ||
          gameStage.id == '1-3' ||
          gameStage.id == '1-4') {
        gameStage.isUnlocked = true;
      }
    }
  }
  saveUnlockedStates();
}
