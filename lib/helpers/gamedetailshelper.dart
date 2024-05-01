class GameDetails {
  GameDetails(
      {required this.gameTitle,
      required this.gameDescription,
      required this.shortDescription,
      required this.game,
      required this.imageSource});

  final String gameTitle;
  final String gameDescription;
  final String shortDescription;
  final String imageSource;
  final Game game;
  String get gameId => game.toString();
}

enum Game { joingame, mafia, sample }

List<GameDetails> gamesList = [
  GameDetails(
      gameTitle: "Join",
      shortDescription: "Join an existing game",
      gameDescription: "The quick brown fox jumps over the lazy dog",
      game: Game.joingame,
      imageSource: "images/defaultimage.jpeg"),
  GameDetails(
      gameTitle: "Mafia",
      shortDescription: "A Thrilling Social Deduction Game",
      gameDescription:
          "Mafia, also known as Werewolf, is a thrilling social deduction game where players are secretly assigned roles as either mafiosi (the informed minority) or villagers (the uninformed majority). The game involves night-killing abilities, daytime debates, and strategic voting. Victory conditions differ for each group, making it an engaging battle of wits!",
      game: Game.mafia,
      imageSource: "images/mafiaimg.jpg"),
  GameDetails(
      gameTitle: "Sample",
      shortDescription: "This is just a sample",
      gameDescription: "The quick brown fox jumps over the lazy dog",
      game: Game.sample,
      imageSource: "images/defaultimage.jpeg"),
];

GameDetails gameSelector(Game game) {
  return gamesList.where((element) => element.game == game).first;
}
