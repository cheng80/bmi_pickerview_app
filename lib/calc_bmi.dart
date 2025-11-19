class CalcBmi {
  
  static const List<double> bmiList  = [18.5, 23.0, 25.0, 30.0]; //bmi 경계값 분류 리스트
  static const List<String> bmiMSGList  = ["저체중", "정상체중", "과체중", "비만", "고도 비만"]; //bmi 결과 메시지 리스트

  late double heightCm;

  double heightM() { //cm를 m로 변환
    return heightCm / 100;
  }
  late double weightKg;
  //constructor
  CalcBmi(){
    heightCm = 0.0;
    weightKg = 0.0;
  }

  double calculateBmi(double heightCm, double weightKg) { //bmi 계산
    this.heightCm = heightCm;
    this.weightKg = weightKg;
    double heightM = this.heightM();
    return weightKg / (heightM * heightM);
  }

  String getBmiCategory(double bmi) {
    if (bmi < 18.5) {
      return bmiMSGList[0];
    } else if (bmi >= bmiList[0] && bmi < bmiList[1]) {
      return bmiMSGList[1];
    } else if (bmi >= bmiList[1] && bmi < bmiList[2]) {
      return bmiMSGList[2];
    } else if (bmi >= bmiList[2] && bmi < bmiList[3]) {
      return bmiMSGList[3];
    } else {
      return bmiMSGList[4];
    }
  }
  
}