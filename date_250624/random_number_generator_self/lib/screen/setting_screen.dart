import 'package:flutter/material.dart';
import 'package:random_number_generator_self/constant/color.dart';
import 'package:random_number_generator_self/component/number_to_image.dart';

// 세팅 화면 설정. 화면이 스크롤등 변하는 위젯을 다르므로 스테이트풀 사용
class SettingScreen extends StatefulWidget {
  // 최대값 설정
  final int maxNumber;
  const SettingScreen({Key? key, required this.maxNumber}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  // 우선 인트로 받고 더블로 변환
  // 사용전에 초기화 할거지만, 지금은 아니고 나중에 초기화 함을 명시
  late double maxNumbers;
  @override
  // 스테이트 초기화
  void initState() {
    // TODO: implement initState
    super.initState();
    // 정수로 받은 값을 더블로 변환
    maxNumbers = widget.maxNumber.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    // 기본 레이아웃 구조 설정
    return Scaffold(
      backgroundColor: ColorConstants.primaryColor,
      // 유아이 제외한 영역 사용
      body: SafeArea(
        // 내부 패딩 사용
        child: Padding(
          // 내부 패딩 사용
          padding: EdgeInsets.symmetric(horizontal: 16),
          // 세로 배치 사용
          child: Column(
            // 세로로 가득 채움
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // 자식들 설정
            children: [
              // 최대 숫자 보일 클래스 호출
              _Number(maxNumberInput: maxNumbers),
              // 최대 숫자 정할 슬라이더 사용
              _Slider(value: maxNumbers, onChanged: onSliderChanged),
              // 저장할 버튼을 저장한 클래스 호출
              _Button(onPressed: onSavePressed),
            ],
          ),
        ),
      ),
    );
  }

  // 저장 버튼 클릭시 동작할 함수
  void onSavePressed() {
    // 가까운 네비게이터를 찾고
    Navigator.of(context)
    // 현재 화면 스택에서 해당 값을 꺼낸다. 정수 타입으로 변환해서
    .pop(maxNumbers.toInt());
  }

  // 슬라이더 값 변경시
  void onSliderChanged(double value) {
    // 빌드 함수 재 실행
    setState(() {
      // 만든 값을 최대값에 저장한다.
      maxNumbers = value;
    });
  }
}

// 숫자가 보여질 클래스 생성
class _Number extends StatelessWidget {
  // 입력 받을 최대 값
  double maxNumberInput;
  _Number({super.key, required this.maxNumberInput});

  @override
  Widget build(BuildContext context) {
    // 화면을 가득 채움
    return Expanded(
      // 숫자가 보여질 컨테이너 선언
      child: Container(
        child:
            // 숫자를 이미지 파일의 이름과 매칭하여 이미지 로딩
            NumberToImage(
              // 최대 숫자를 정수로 변환
              number: maxNumberInput.toInt(),
            ),
      ),
    );
  }
}

// 슬라이더 설정
class _Slider extends StatelessWidget {
  // 값
  final double value;
  // 슬라이더의 onChanged 콜백과 타입이 정확히 맞아야 하기 대문에 해당 타입을 사용한다.
  final ValueChanged<double> onChanged;
  const _Slider({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    // 슬라이더 호출
    return Slider(
      value: value,
      onChanged: onChanged,
      min: 1000,
      max: 100000,
      activeColor: ColorConstants.accentColor,
    );
  }
}

// 저장 버튼을 관리할 클래스 설정
class _Button extends StatelessWidget {
  // 버튼 클릭시 동작할 함수 저장
  VoidCallback onPressed;
  _Button({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    // 버튼 강조
    return ElevatedButton(
      // 클릭시 호출할 함수
      onPressed: onPressed,
      child: Text("저장!", style: TextStyle(color: ColorConstants.infoColor)),
    );
  }
}
