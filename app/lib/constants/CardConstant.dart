import 'package:flutter/material.dart';

// 0: paper
// 1: rock
// 2: scissor
// scoring method: me - opponent = score
// score = 0 => draw
// score = [2, -1] => me win
// score = else => opponent win

final colors = [Colors.amberAccent, Colors.pinkAccent, Colors.lightBlueAccent];
final images = [
  "https://static.thenounproject.com/png/477912-200.png",
  "https://static.thenounproject.com/png/88661-200.png",
  "https://static.thenounproject.com/png/88666-200.png",
];

String scoring(int score) {
  String statement = "";
  if (score == 0) {
    statement = "Draw!";
  } else if ([2, -1].contains(score)) {
    statement = "I win!";
  } else {
    statement = "I lose!";
  }
  return statement;
}
