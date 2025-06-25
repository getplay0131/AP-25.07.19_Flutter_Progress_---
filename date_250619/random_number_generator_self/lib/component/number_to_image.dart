import 'package:flutter/material.dart';

class NumberToImage extends StatelessWidget {
  int number;
  NumberToImage({Key? key, required this.number}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print("숫자 이미지 로딩됨 => $number");
    return Row(
      children: number
          .toString()
          .split('')
          .map((e) => Image.asset('asset/img/$e.png', width: 50, height: 70))
          .toList(),
    );
  }
}
