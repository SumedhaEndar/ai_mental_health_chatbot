import 'package:flutter/material.dart';

class StyledTitle extends StatelessWidget {
  const StyledTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}

class StyledName extends StatelessWidget {
  const StyledName(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18
        ),
    );
  }
}

class StyledLabel extends StatelessWidget {
  const StyledLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontWeight: FontWeight.bold,
      ),
    );
  }
}



