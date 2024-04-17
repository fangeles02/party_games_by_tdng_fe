class GameDetails {
  GameDetails({
    required this.gameTitle,
    required this.gameDescription,
    required this.game,
  });

  final String gameTitle;
  final String gameDescription;
  final Game game;
  String get gameId => game.toString();
}

enum Game { mafia, game2 }

List<GameDetails> gamesList = [
  GameDetails(
    gameTitle: "Mafia",
    gameDescription: "Mafia, also known as Werewolf, is a thrilling social deduction game where players are secretly assigned roles as either mafiosi (the informed minority) or villagers (the uninformed majority). The game involves night-killing abilities, daytime debates, and strategic voting. Victory conditions differ for each group, making it an engaging battle of wits!",
    game: Game.mafia,
  )
];

GameDetails gameSelector(Game game) {
  return gamesList.where((element) => element.game == Game.mafia).first;
}
