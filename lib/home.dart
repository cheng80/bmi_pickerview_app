import 'package:bmi_pickerview_app/calc_bmi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //Property
  CalcBmi calc_bmi = CalcBmi();
  final int _minHeightNum = 100;
  final int _maxHeightNum = 200;
  final int _minWeightNum = 30;
  final int _maxWeightNum = 200;

  //late 는 초기화를 나중으로 미룸
  late String _bmiResult;
  late List<double> arrowAlpha_List;
  
  late List<int> _heightNumList; //키 범위 리스트
  late List<int> _weightNumList; //몸무게 범위 리스트
  late int _selectedHeightItem;    //선택된 키 아이템 인덱스
  late int _selectedWeightItem;    //선택된 몸무게 아이템 인덱스

  @override
  void initState() { //페이지가 새로 생성 될때 무조건 1번 사용 됨
    super.initState();
    _heightNumList = List.generate(_maxHeightNum - _minHeightNum + 1, (index) => index + _minHeightNum); //100~200cm
    _weightNumList = List.generate(_maxWeightNum - _minWeightNum + 1, (index) => index + _minWeightNum);  //30~200kg
    _selectedHeightItem = _heightNumList.indexOf(160); //초기값 160cm
    _selectedWeightItem = _weightNumList.indexOf(60); //초기값 60kg

    _bmiResult = "신장과 체중을 선택해 주세요."; //초기 bmi 결과 문자열 공백으로 초기화
    arrowAlpha_List = List.generate(5, (index) => 0);//   bmiArrow 알파값 0으로 생성
    bmiArrowDisable();
  }

   @override
  void dispose() {
    // Dispose all TextEditingControllers to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //TextField 항목은 키보드 자동으로 내리기 위해 이걸 해주는게 좋다.
        FocusScope.of(context).unfocus(); //버튼이나 키보드, 인풋 박스 이외에 터치 하면 언포커스
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("BMI 계산기", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Row(
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //-----신장 피커-------
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('신장 (cm)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                      SizedBox(
                        width: 150,
                        height: 250,
                        child: CupertinoPicker(
                          itemExtent: 30, //각 아이템 높이 
                          looping: true, //무한 루프
                          backgroundColor: Colors.white,
                          selectionOverlay: Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 40,
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(158, 119, 119, 119).withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          onSelectedItemChanged: (int index){
                            _selectedHeightItem = index;
                            _bmiCalculate();
                            setState(() {});
                          },
                          scrollController: FixedExtentScrollController(initialItem: _selectedHeightItem),
                          children: 
                            List<Widget>.generate(_heightNumList.length, (index){
                              return Center(
                                child: Text(
                                  '${_heightNumList[index]}',
                                  style: TextStyle(fontSize: 20, color: Colors.black),
                                ),
                              );
                            }
                        )
                      ),
                      ),
                    ],
                  ),
                  //-----체중 피커-------
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('체중 (kg)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                      SizedBox(
                        width: 150,
                        height: 250,
                        child: CupertinoPicker(
                          itemExtent: 30, //각 아이템 높이 
                          looping: true, //무한 루프
                          backgroundColor: Colors.white,
                          selectionOverlay: Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 40,
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(158, 119, 119, 119).withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          onSelectedItemChanged: (int index){
                            _selectedWeightItem = index;
                            _bmiCalculate();
                            setState(() {});
                          },
                          scrollController: FixedExtentScrollController(initialItem: _selectedWeightItem),
                          children: 
                            List<Widget>.generate(_weightNumList.length, (index){
                              return Center(
                                child: Text(
                                  '${_weightNumList[index]}',
                                  style: TextStyle(fontSize: 20, color: Colors.black),
                                ),
                              );
                            }
                        )
                      ),
                      ),
                    ],
                  ),
                ],
              ),
              //----bmi 결과 텍스트-----
              Text(_bmiResult, 
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              
              //----bmi 화살표 이미지 -----
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                child: Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < 5; i++)
                    Image.asset('images/down_arrow.png', 
                      width: 50, 
                      opacity: AlwaysStoppedAnimation(arrowAlpha_List[i]),//투명도
                      fit: BoxFit.contain
                    ),
                  ],
                ),
              ), 
              //----bmi 이미지 -----
              Image.asset('images/BMI.png', 
                width: 380, 
                fit: BoxFit.contain
              ), 
               
            ],
          ),
        ),
      ),
    );
  }


  //--------Functions ------------
 
  bmiArrowDisable()
  {
    for (int i = 0; i < arrowAlpha_List.length; i++)
    {
      arrowAlpha_List[i] = 0.0;
    }
    setState(() {});
  }

  bmiArrowAlphaChange(int index)
  {
    for (int i = 0; i < arrowAlpha_List.length; i++)
    {
      if (i == index)
      {
        arrowAlpha_List[i] = 1.0;
      }
      else
      {
        arrowAlpha_List[i] = 0.0;
      }
    }
    setState(() {});
  }

  _bmiCalculate()
  {
    bmiArrowDisable();
    _bmiResult = "";

    // print('_selectedHeightItem: ${_heightNumList [_selectedHeightItem]}, _selectedWeightItem: ${_weightNumList[_selectedWeightItem]}');

    double bmi = calc_bmi.calculateBmi(_heightNumList[_selectedHeightItem].toDouble(), _weightNumList[_selectedWeightItem].toDouble());
    _bmiResult = calc_bmi.getBmiCategory(bmi);
    bmiArrowAlphaChange(CalcBmi.bmiMSGList.indexOf(_bmiResult));

    _bmiResult = "귀하의 bmi지수는 ${_formatNumber(bmi)} 이고 $_bmiResult 입니다.";
    
  }

  // 입력 필드를 파싱하여 double 리스트를 반환.
  String _formatNumber(double n) { 

    return n % 1 == 0
      ? n.toInt().toString()  // 정수로 변환
      : n.toStringAsFixed(1)                    // 소수점 첫째자리까지 반올림
        .replaceAll(RegExp(r'0+$'), '')       // 끝의 0 제거
        .replaceAll(RegExp(r'\.$'), '');      // 마지막이 .이면 제거
  }
  //------------------------------
}