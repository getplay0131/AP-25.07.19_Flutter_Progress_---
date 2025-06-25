import 'package:flutter/material.dart';
import 'package:random_number_generator_self/component/number_to_image.dart';
import 'dart:math';

import 'package:random_number_generator_self/constant/color.dart';
import 'package:random_number_generator_self/screen/setting_screen.dart';

// 동적 화면 변화가 필요하므로 스테이트풀 사용
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  // 스테이트 초기화 제일 먼저 실행됨
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 파일명으로 사용할 숫자 리스트 선언
  List<int> numbers = [123, 456, 789];
  // 기본 숫자의 최대 범위
  int maxNumber = 1000;
  // 스테이트 재실행하는 빌드 함수
  @override
  Widget build(BuildContext context) {
    // 기본 레이아웃 구조를 제공하는 스캐폴드 위젯
    return Scaffold(
      // 배경색 지정
      backgroundColor: ColorConstants.backgroundColor,
      // 스캐폴드의 바디 설정. 세이프 에어리어는 시스템 유아이를 제외한 공간을 사용하도록 제한한다.
      body: SafeArea(
        // 패딩으로 내부 여백을 설정한다.
        child: Padding(
          // 내부 여백 설정. 시메트릭은 대칭 여백을 설정한다.
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          // 여백의 안에 사용할 위젯으로 세로 방향으로 배치할 컬럼을 사용한다. 컬럼은 칠드런을 제공하고 컬럼의 주축은 세로고, 교차축은 가로다
          child: Column(
            // 주축의 가운데 정렬
            mainAxisAlignment: MainAxisAlignment.center,
            // 교차축 채움
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // 자식들 설정
            children: [
              // 헤더 클래스 호출, 값으로 세팅 화면으로 넘어갈 함수를 값으로 사용, 온 프레스드는 콜백 함수를 받고, 동작 발생시 차후 호출될 함수를 콜백 함수라고 한다.
              _Header(onPressed: onSettingIconPreesed),
              //바디 클래스 호출
              _Body(numbers: numbers),
              // 푸터 클래스 호출, 콜백 함수로 랜덤 숫자 생성하는 함수를 전달한다.
              _Footer(onPressed: generateRandomNumbers),
            ],
          ),
        ),
      ),
    );
  }

  // 랜덤 숫자 생성하는 함수
  void generateRandomNumbers() {
    // 랜덤 클래스 호출
    var random = Random();
    // 중복 숫자를 제외하기 위해 세트 자료 구조 활용.
    Set<int> uniqueNumbers = {};
    // 숫자 반복 생성 위해 와일 문 사용
    while (uniqueNumbers.length < 3) {
      // 랜덤 숫자를 생성하는 값을 세트에 추가한다.
      uniqueNumbers.add(random.nextInt(maxNumber));
    }
    setState(() {
      // 빌드를 재실행 하며, 중복 없는 자료구조를 리스트로 반환한다. 넘버스가 리스트 자료구조 이기 때문에 변환한다.
      numbers = uniqueNumbers.toList();
    });
  }

  // 이 함수 구현이 어렵네. 아무래도 네비게이터랑 빌더가 낯설어서 그런거 같은데.. 이부분 설명 부탁해
  // 세팅 아이콘 클릭시 동작할 비동기 함수
  void onSettingIconPreesed() async {
    // 네비게이터는 위젯 트리에 있다.
    // 그로 인해 매터리얼 앱이나 네비게이터 위젯이 위젯 트리에 있어야 한다.
    // 컨텍스트로 해당 네비게이터를 찾는다.

    // 네비게이터에게 비동기 요청
    var push =
        await Navigator
            // 현재 위치에서 가장 가까운 네비게이터 찾기
            .of(context)
            // 새 화면을 현재 스택 위에 올리기
            .push(
              // 화면 전환 방식
              MaterialPageRoute(
                // 빌더 : 무언가를 생성하고 만든다 라는 뜻이니까
                // 빌드 컨텍스트 : 컨텍스트를 만들건데 > 플러터가 새 화면을 제공하고
                builder: (BuildContext context) {
                  // 세팅 스크린을 생성하고 그와 동시에 값을 전달한다.
                  return SettingScreen(maxNumber: maxNumber);
                },
              ),
            );
    // 만약 전달 받은 값이 널이 아니라면 > 정상 동작 > 사용자가 저장버튼으로 값을 반환하면
    if (push != null) {
      // 빌드 함수를 재실행 한다.
      setState(() {
        // 가져온 값을 맥스 넘버에 저장한다.
        maxNumber = push;
      });
    }
  }
}

// 헤더 클래스 정의, 상태 변화 없으므로 스테이트리스 위젯 사용
class _Header extends StatelessWidget {
  // 나중에 실행할 함수 저장
  VoidCallback onPressed;
  _Header({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    // 가로 배치
    return Row(
      // 주축 정렬
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // 자식들 설정
      children: [
        // 제목 설정 및 스타일 설정
        Text(
          "Random Number Generator",
          style: TextStyle(
            color: ColorConstants.textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        // 버튼 클릭시 동작을 위해 콜백함수를 인자로 받음
        IconButton(
          // 눌럿을때 실행할 함수 지정
          onPressed: onPressed,
          // 아이콘 설정
          icon: Icon(Icons.settings, color: ColorConstants.textColor),
        ),
      ],
    );
  }
}

// 바디 클래스 설정 - 숫자들이 보일 곳
class _Body extends StatelessWidget {
  // 예상치 못한 오류 방지 위해 상수로 선언
  final List<int> numbers;
  _Body({super.key, required this.numbers});

  @override
  Widget build(BuildContext context) {
    // 화면을 가득 채우기 위해
    return Expanded(
      // 세로 배치
      child: Column(
        // 주축 정렬 - 세로
        mainAxisAlignment: MainAxisAlignment.center,
        // 넘벌를 받아서 이미지로 변환하는 클래스에 값으로 전달하고 리스트로 받는다.
        children: numbers.map((e) => NumberToImage(number: e)).toList(),
      ),
    );
  }
}

// 푸터 클래스 선언 - 랜덤 숫자 생성할 기능 담을 곳
class _Footer extends StatelessWidget {
  // 실행할 함수 저장하기 위해 보이드 콜백 타입 사용
  VoidCallback onPressed;
  _Footer({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    // 버튼 강조를 위해 해당 위젯 사용
    return ElevatedButton(
      // 클릭시 함수 실행
      onPressed: onPressed,
      // 버튼의 텍스트 설정
      child: Text(
        "생성하기!",
        style: TextStyle(
          color: ColorConstants.buttonColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          // backgroundColor: ColorConstants.backgroundColor,
        ),
      ),
      // 버튼 스타일 설정. 스타일 설정 방법이 일반 설정 방법과 다르므로 주의하며 사용 필요
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorConstants.primaryColor,
        padding: EdgeInsets.symmetric(vertical: 16),
        //
        foregroundColor: ColorConstants.buttonColor,
      ),
    );
  }
}
