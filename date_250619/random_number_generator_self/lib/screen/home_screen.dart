import 'package:flutter/material.dart';
import 'package:random_number_generator_self/component/number_to_image.dart';
import 'dart:math';

import 'package:random_number_generator_self/constant/color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<int> numbers = [123, 456, 789];
  int maxNumber = 1000;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorConstants.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [
              // _Header(onPressed: onPressed),
              _Body(numbers: numbers),
              // 랜덤 숫자 생성하는 함수 구현해야함
              _Footer(onPressed: onPressed),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  VoidCallback onPressed;
  _Header({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Random Number Generator",
          style: TextStyle(
            color: colorConstants.textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          onPressed: onPressed,
          icon: Icon(Icons.settings, color: colorConstants.textColor),
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  List<int> numbers;
  _Body({super.key, required this.numbers});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: numbers.map((e) => NumberToImage(number: e)).toList(),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  VoidCallback onPressed;
  _Footer({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        "생성하기!",
        style: TextStyle(
          color: colorConstants.buttonColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          backgroundColor: colorConstants.backgroundColor,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: colorConstants.primaryColor,
        padding: EdgeInsets.symmetric(vertical: 16),
        foregroundColor: colorConstants.secondaryColor,
      ),
    );
  }
}
