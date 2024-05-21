import 'package:flutter/material.dart';

void main() {
  runApp(const TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TicTacToeHome(),
    );
  }
}

class TicTacToeHome extends StatefulWidget {
  const TicTacToeHome({super.key});

  @override
  _TicTacToeHomeState createState() => _TicTacToeHomeState();
}

class _TicTacToeHomeState extends State<TicTacToeHome> {
  late List<String> _board;
  late String _currentPlayer;
  late bool _gameOver;
  late String _resultMessage;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    setState(() {
      _board = List.generate(9, (index) => '');
      _currentPlayer = 'X';
      _gameOver = false;
      _resultMessage = '';
    });
  }

  void _handleTap(int index) {
    if (_board[index] == '' && !_gameOver) {
      setState(() {
        _board[index] = _currentPlayer;
        _gameOver = _checkWinner();
        if (_gameOver) {
          _resultMessage = 'Player $_currentPlayer wins!';
        } else if (!_board.contains('')) {
          _gameOver = true;
          _resultMessage = 'It\'s a draw!';
        } else {
          _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
        }
      });
    }
  }

  bool _checkWinner() {
    List<List<int>> winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var combination in winningCombinations) {
      if (_board[combination[0]] == _currentPlayer &&
          _board[combination[1]] == _currentPlayer &&
          _board[combination[2]] == _currentPlayer) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetGame,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black87, Colors.black54],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildBoard(),
            if (_gameOver)
              Column(
                children: [
                  Text(
                    _resultMessage,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _resetGame,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.teal,
                    ),
                    child: const Text('Play Again'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBoard() {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _handleTap(index),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  _board[index],
                  key: ValueKey(_board[index]),
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: _board[index] == 'X' ? Colors.red : Colors.green,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
