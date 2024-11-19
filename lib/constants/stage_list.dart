import 'package:memorie/models/stage.dart';

final List<MainStage> stages = [
  MainStage(
    id: "1",
    name: 'Life',
    subName: 'stage1',
    gameStages: [
      GameStage(
        id: "1-1",
        name: 'Breakfast',
        subName: 'stage1-1',
        backgroundGameScreenImage: 'lib/assets/backgrounds/abst1.png',
        rowGridCount: 2,
        totalGridCount: 4,
      ),
      GameStage(
        id: "1-2",
        name: 'Lunch',
        subName: 'stage1-2',
        backgroundGameScreenImage: 'lib/assets/backgrounds/dark.png',
        rowGridCount: 2,
        totalGridCount: 3,
      ),
      GameStage(
        id: "1-3",
        name: 'Dinner',
        subName: 'stage1-3',
        backgroundGameScreenImage: '',
        rowGridCount: 3,
        totalGridCount: 6,
      ),
    ],
  ),
  MainStage(
    id: "2",
    name: 'Work',
    subName: 'stage2',
    gameStages: [
      GameStage(
        id: "2-1",
        name: 'Meeting',
        subName: 'stage2-1',
        backgroundGameScreenImage: '',
        rowGridCount: 2,
        totalGridCount: 8,
      ),
      GameStage(
        id: "2-2",
        name: 'Report',
        subName: 'stage2-2',
        backgroundGameScreenImage: '',
        rowGridCount: 1,
        totalGridCount: 1,
      ),
      GameStage(
        id: "2-3",
        name: 'Mail',
        subName: 'stage2-3',
        backgroundGameScreenImage: '',
        rowGridCount: 1,
        totalGridCount: 1,
      ),
    ],
  ),
];
