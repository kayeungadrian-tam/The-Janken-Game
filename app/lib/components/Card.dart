import 'package:flutter/material.dart';

import 'package:flip_card/flip_card.dart';

import 'package:app/components/CardBack.dart';
import 'package:app/components/CardTemplate.dart';

class PlayingCard extends StatefulWidget {
  @override
  State<PlayingCard> createState() => _PlayingCardState();
}

class _PlayingCardState extends State<PlayingCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: FlipCard(
          fill: Fill
              .fillBack, // Fill the back side of the card to make in the same size as the front.
          direction: FlipDirection.HORIZONTAL, // default
          front: Container(
            child: SizedBox(
                height: 250,
                width: 200,
                child: MyCard(
                  text: 'Hello',
                )),
          ),
          back: Container(
            child: SizedBox(
              height: 250,
              width: 200,
              child: CardBack(image_path: "assets/images/card_back.png"),
            ),
          ),
        ));
  }
}
