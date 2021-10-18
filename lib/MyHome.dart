import 'package:flutter/material.dart';
import 'package:tic/game_logic.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String activePlayer = 'X';
  bool gameOver = false;
  int turn = 0;
  String result = '';
  Game game = Game();

  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: MediaQuery.of(context).orientation == Orientation.portrait?
         Column(
          children: [
            ...firstBlock(),
            _expanded(context),
            ...lastBlock(),
          ],
        ):Row(
          children: [
            Column(
            children: [
            ...firstBlock(),
            _expanded(context),
            ...lastBlock(),
            ],
            ),
            _expanded(context),
          ],
        )
      ),
    );
  }

  List<Widget> firstBlock() {
    return [
      SwitchListTile.adaptive(
        title: const Text(
          "Turn on/off two players mode",
          style: TextStyle(color: Colors.white, fontSize: 23),
          textAlign: TextAlign.center,
        ),
        value: isSwitched,
        onChanged: (newVal) {
          setState(() {
            isSwitched = newVal;
          });
        },
      ),
      const SizedBox(height: 10,),
      Text(
        "IT'S $activePlayer TURN",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 44,
        ),
        textAlign: TextAlign.center,
      ),
    ];
  }

  List<Widget> lastBlock() {
    return [
      Text(
        result,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 38,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 10,),
      ElevatedButton.icon(
        onPressed: () {
          setState(() {
            Player.playerX = [];
            Player.playerO = [];
            activePlayer = 'X';
            gameOver = false;
            turn = 0;
            result = '';
          });
        },
        icon: const Icon(Icons.replay),
        label: const Text("Replay the game"),
      ),
    ];
  }

  Expanded _expanded(BuildContext context) {
    return Expanded(
      child: GridView.count(
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1,
          crossAxisCount: 3,
          children: List.generate(
            9,
            (index) => InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: gameOver ? null : () => _onTap(index),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).shadowColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                      Player.playerX.contains(index)
                          ? 'X'
                          : Player.playerO.contains(index)
                              ? 'O'
                              : '',
                      style: TextStyle(
                        color: Player.playerX.contains(index)
                            ? Colors.blue
                            : Colors.pink,
                        fontSize: 70,
                      )),
                ),
              ),
            ),
          )),
    );
  }

  _onTap(int index) async {
    if ((Player.playerX.isEmpty || !Player.playerX.contains(index)) &&
        (Player.playerO.isEmpty || !Player.playerO.contains(index))) {
      game.playGame(index, activePlayer);
      updateState();
    }
    if (!isSwitched && !gameOver && turn != 9) {
      await game.autoPlay(activePlayer);
      updateState();
    }
  }

  void updateState() {
    return setState(() {
      activePlayer = activePlayer == 'X' ? 'O' : 'X';
      turn++;

      String winnerPlayer = game.checkWinner();
      if (winnerPlayer != '') {
        gameOver = true;
        result = '$winnerPlayer is the Winner.';
      } else if (!gameOver && turn == 9) {
        result = 'It\'s a tie!';
      }
    });
  }
}