class Stage {
  final String id;
  final String name;
  final String subName;

  Stage({
    required this.id,
    required this.name,
    required this.subName,
  });
}

class MainStage extends Stage {
  // サブステージのリスト
  final List<GameStage> gameStages;

  MainStage({
    required super.id,
    required super.name,
    required super.subName,
    required this.gameStages,
  });
}

class GameStage extends Stage {
  final String backgroundGameScreenImage;
  // 一行のマス数
  // final int rowGridCount;
  // マスの総数
  // final int totalGridCount;

  // グリッドの列数
  final int columnCount;
  // グリッドの総アイテム数は gridItems.length で代用
  final List<GridItem> gridItems;

  GameStage(
      {required super.id,
      required super.name,
      required super.subName,
      required this.backgroundGameScreenImage,
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
