import 'package:flutter/material.dart';

// 상태 변화 없기에 스테이트리스 위젯 사용
class NumberToImage extends StatelessWidget {
  int number;
  NumberToImage({Key? key, required this.number}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print("숫자 이미지 로딩됨 => $number");
    // 가로 배치가 필요하므로 로우 사용
    return Row(
      // 반환이 리스트 이므로 대괄호 사용 안한다.
      children: number
          // 숫자를 문자열로 변환
          .toString()
          // 한글자씩 분리
          .split('')
          // 맵 함수를 이용하여 요소 하나마다 작업, 요소가 숫자이고, 파일명도 숫자이므로, 해당 파일명을 불러오고, 크기를 조정
          .map((e) => Image.asset('asset/img/$e.png', width: 50, height: 70))
          // 리스트로 변환
          .toList(),
    );
  }
}
