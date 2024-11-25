class Stage {
  final String id;
  final String name;
  final String subName;
  final String stageCardImage;

  Stage({
    required this.id,
    required this.name,
    required this.subName,
    required this.stageCardImage,
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
  });
}

class GameStage extends Stage {
  // グリッドの列数
  final int columnCount;
  // グリッドの総アイテム数は gridItems.length で代用
  final List<GridItem> gridItems;

  GameStage(
      {required super.id,
      required super.name,
      required super.subName,
      required super.stageCardImage,
      // required this.rowGridCount,
      // required this.totalGridCount,
      required this.columnCount,
      required this.gridItems});
}

class GridItem {
  final bool isViewGrid;

  GridItem({
    required this.isViewGrid,
  });
}
