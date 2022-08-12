import 'package:app/constants/CardConstant.dart';
import 'package:flutter/material.dart';
import 'package:app/components/CardBack.dart';
import 'package:flip_card/flip_card.dart';
import 'dart:math' as math;

class PlayingCard extends StatefulWidget {
  const PlayingCard({Key? key, required this.index, required this.isOpponent})
      : super(key: key);

  final int index;
  final bool isOpponent;
  @override
  State<PlayingCard> createState() => _PlayingCardState();
}

class _PlayingCardState extends State<PlayingCard> {
  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform:
          widget.isOpponent ? Matrix4.rotationX(math.pi) : Matrix4.rotationX(0),
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FlipCard(
            fill: Fill
                .fillBack, // Fill the back side of the card to make in the same size as the front.
            direction: FlipDirection.HORIZONTAL, // default
            back: Container(
              child: SizedBox(
                  height: 250,
                  width: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 150,
                      width: 100,
                      color: colors[widget.index],
                      child: Image(
                        image: NetworkImage('${images[widget.index]}'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  )),
            ),
            front: Container(
              child: SizedBox(
                height: 250,
                width: 190,
                child: CardBack(image_path: "assets/images/card_back.png"),
              ),
            ),
          )),
    );
  }
}
