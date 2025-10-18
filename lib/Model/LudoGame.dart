import 'dart:math';

enum PlayerColor { red, green, blue, yellow }

enum GameState { waiting, playing, finished }

class Piece {
  int id;
  PlayerColor color;
  int position; // 0-51 for board positions, -1 for home, -2 for finished
  bool isInHome;
  bool isFinished;

  Piece({
    required this.id,
    required this.color,
    this.position = -1,
    this.isInHome = true,
    this.isFinished = false,
  });

  void moveTo(int newPosition) {
    position = newPosition;
    isInHome = false;
    isFinished = newPosition == -2;
  }

  void reset() {
    position = -1;
    isInHome = true;
    isFinished = false;
  }
}

class Player {
  String name;
  PlayerColor color;
  List<Piece> pieces;
  bool isActive;
  int coins;

  Player({
    required this.name,
    required this.color,
    required this.coins,
    this.isActive = false,
  }) : pieces = List.generate(4, (index) => Piece(id: index, color: color));

  void reset() {
    pieces.forEach((piece) => piece.reset());
    isActive = false;
  }
}

class LudoGame {
  List<Player> players;
  int currentPlayerIndex;
  int diceValue;
  GameState gameState;
  int? selectedPieceIndex;
  Random random;

  // Board positions for each color's path
  static const Map<PlayerColor, List<int>> colorPaths = {
    PlayerColor.red: [
      0,
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20,
      21,
      22,
      23,
      24,
      25,
      26,
      27,
      28,
      29,
      30,
      31,
      32,
      33,
      34,
      35,
      36,
      37,
      38,
      39,
      40,
      41,
      42,
      43,
      44,
      45,
      46,
      47,
      48,
      49,
      50,
      51,
    ],
    PlayerColor.green: [
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20,
      21,
      22,
      23,
      24,
      25,
      26,
      27,
      28,
      29,
      30,
      31,
      32,
      33,
      34,
      35,
      36,
      37,
      38,
      39,
      40,
      41,
      42,
      43,
      44,
      45,
      46,
      47,
      48,
      49,
      50,
      51,
      0,
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
    ],
    PlayerColor.blue: [
      26,
      27,
      28,
      29,
      30,
      31,
      32,
      33,
      34,
      35,
      36,
      37,
      38,
      39,
      40,
      41,
      42,
      43,
      44,
      45,
      46,
      47,
      48,
      49,
      50,
      51,
      0,
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20,
      21,
      22,
      23,
      24,
      25,
    ],
    PlayerColor.yellow: [
      39,
      40,
      41,
      42,
      43,
      44,
      45,
      46,
      47,
      48,
      49,
      50,
      51,
      0,
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20,
      21,
      22,
      23,
      24,
      25,
      26,
      27,
      28,
      29,
      30,
      31,
      32,
      33,
      34,
      35,
      36,
      37,
      38,
    ],
  };

  // Safe zones (final 6 positions before home)
  static const Map<PlayerColor, List<int>> safeZones = {
    PlayerColor.red: [46, 47, 48, 49, 50, 51],
    PlayerColor.green: [59, 60, 61, 62, 63, 64],
    PlayerColor.blue: [72, 73, 74, 75, 76, 77],
    PlayerColor.yellow: [85, 86, 87, 88, 89, 90],
  };

  LudoGame({
    required this.players,
    this.currentPlayerIndex = 0,
    this.diceValue = 0,
    this.gameState = GameState.waiting,
    this.selectedPieceIndex,
  }) : random = Random() {
    if (players.isNotEmpty) {
      players[0].isActive = true;
    }
  }

  Player get currentPlayer => players[currentPlayerIndex];

  void rollDice() {
    if (gameState != GameState.playing) return;

    diceValue = random.nextInt(6) + 1;

    // Check if any piece can move
    bool canMove = false;
    for (int i = 0; i < currentPlayer.pieces.length; i++) {
      if (canPieceMove(i)) {
        canMove = true;
        break;
      }
    }

    // If no piece can move, skip turn
    if (!canMove) {
      nextTurn();
    }
  }

  bool canPieceMove(int pieceIndex) {
    if (pieceIndex >= currentPlayer.pieces.length) return false;

    Piece piece = currentPlayer.pieces[pieceIndex];

    // If piece is finished, it can't move
    if (piece.isFinished) return false;

    // If piece is in home, it needs 6 to come out
    if (piece.isInHome) {
      return diceValue == 6;
    }

    // If piece is on board, check if it can move
    int currentPos = piece.position;
    int newPos = currentPos + diceValue;

    // Check if piece would go beyond the board
    if (newPos >= 52) return false;

    return true;
  }

  bool selectPiece(int pieceIndex) {
    if (!canPieceMove(pieceIndex)) return false;

    selectedPieceIndex = pieceIndex;
    return true;
  }

  bool movePiece() {
    if (selectedPieceIndex == null) return false;

    Piece piece = currentPlayer.pieces[selectedPieceIndex!];

    if (piece.isInHome) {
      // Move piece out of home - needs 6 to come out
      if (diceValue == 6) {
        piece.moveTo(0);
      } else {
        selectedPieceIndex = null;
        return false; // Can't move out without 6
      }
    } else {
      // Move piece on board
      int newPosition = piece.position + diceValue;

      // Check if piece reaches home
      if (newPosition >= 52) {
        piece.moveTo(-2); // Finished
      } else {
        piece.moveTo(newPosition);
      }
    }

    selectedPieceIndex = null;

    // Check win condition
    if (currentPlayer.pieces.every((p) => p.isFinished)) {
      gameState = GameState.finished;
      return true;
    }

    // If dice value is 6, player gets another turn
    if (diceValue != 6) {
      nextTurn();
    }

    return true;
  }

  void nextTurn() {
    currentPlayer.isActive = false;
    currentPlayerIndex = (currentPlayerIndex + 1) % players.length;
    currentPlayer.isActive = true;
    diceValue = 0;
    selectedPieceIndex = null;
  }

  void startGame() {
    gameState = GameState.playing;
    currentPlayerIndex = 0;
    players.forEach((player) => player.reset());
    currentPlayer.isActive = true;
  }

  void resetGame() {
    gameState = GameState.waiting;
    currentPlayerIndex = 0;
    diceValue = 0;
    selectedPieceIndex = null;
    players.forEach((player) => player.reset());
  }

  // Get all pieces at a specific board position
  List<Piece> getPiecesAtPosition(int position) {
    List<Piece> piecesAtPosition = [];
    for (Player player in players) {
      for (Piece piece in player.pieces) {
        if (piece.position == position &&
            !piece.isInHome &&
            !piece.isFinished) {
          piecesAtPosition.add(piece);
        }
      }
    }
    return piecesAtPosition;
  }

  // Check if a position is safe (no other pieces can land on it)
  bool isSafePosition(int position) {
    // Starting positions are safe
    if (position == 0 || position == 13 || position == 26 || position == 39) {
      return true;
    }
    return false;
  }
}
