class Stage {
  final String id;
  final String name;
  final String subName;
  final String stageCardImage;
  final String stageThumbnailImage;

  Stage({
    required this.id,
    required this.name,
    required this.subName,
    required this.stageCardImage,
    required this.stageThumbnailImage,
  });
}

class MainStage extends Stage {
  // サブステージのリスト
  final List<GameStage> gameStages;

  MainStage({
    required super.id,
    required super.name,
    required super.subName,
    required super.stageCardImage,
    required this.gameStages,
    required super.stageThumbnailImage,
  });

  bool get isUnlocked {
    // 最初のサブステージが存在し、かつアンロックされているか
    if (gameStages.isNotEmpty) {
      return gameStages.first.isUnlocked;
    }
    // サブステージがないなら（特殊ケース）とりあえずtrue
    return true;
  }
}

class GameStage extends Stage {
  // グリッドの列数
  final int columnCount;
  // グリッドの総アイテム数は gridItems.length で代用
  final List<GridItem> gridItems;

  // ステージのロック状態
  bool isUnlocked;

  bool isCleared;

  GameStage({
    required super.id,
    required super.name,
    required super.subName,
    required super.stageCardImage,
    required super.stageThumbnailImage,
    required this.columnCount,
    required this.gridItems,
    this.isUnlocked = false, // デフォルトはfalse
    this.isCleared = false, // デフォルトはfalse
  });
}

class GridItem {
  final bool isViewGrid;

  GridItem({
    required this.isViewGrid,
  });
}
