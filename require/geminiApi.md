기본 요건
이 빠른 시작에서는 개발자가 Dart를 사용해 애플리케이션을 빌드하는 데 익숙하다고 가정합니다.

이 빠른 시작을 완료하려면 개발 환경이 다음 요구사항을 충족하는지 확인하세요.

Dart 3.2.0 이상
Gemini API SDK 설치
자체 애플리케이션에서 Gemini API를 사용하려면 google_generative_ai 패키지를 Dart 또는 Flutter 앱에 add해야 합니다.

Dart
Flutter

dart pub add google_generative_ai
인증 설정
Gemini API에 인증하는 가장 쉬운 방법은 이 섹션에 설명된 대로 API 키를 구성하는 것입니다. 더 엄격한 액세스 제어가 필요한 경우 대신 OAuth를 사용할 수 있습니다.

아직 API 키가 없는 경우 Google AI Studio에서 API 키를 만듭니다.

Google AI Studio에서 API 키 가져오기

그런 다음 키를 구성합니다.

버전 제어 시스템에 API 키를 체크인하지 말고 대신 프로세스 환경 변수로 할당하는 것이 좋습니다. Flutter 앱을 개발하는 경우 String.fromEnvironment를 사용하고 --dart-define=API_KEY=$API_KEY를 flutter build 또는 flutter run에 전달하여 API 키로 컴파일할 수 있습니다. 앱을 실행할 때 프로세스 환경이 다르기 때문입니다.

라이브러리 가져오기
Google 생성형 AI 라이브러리를 가져오고 구성합니다.


import 'package:google_generative_ai/google_generative_ai.dart';

// Access your API key as an environment variable (see "Set up your API key" above)
final apiKey = Platform.environment['API_KEY'];
if (apiKey == null) {
  print('No \$API_KEY environment variable');
  exit(1);
}
첫 번째 요청하기
generateContent 메서드를 사용하여 텍스트를 생성합니다.


// Make sure to include this import:
// import 'package:google_generative_ai/google_generative_ai.dart';
final model = GenerativeModel(
  model: 'gemini-1.5-flash',
  apiKey: apiKey,
);
final prompt = 'Write a story about a magic backpack.';

final response = await model.generateContent([Content.text(prompt)]);
print(response.text);

다음 단계
이제 Gemini API에 요청할 준비가 되었으므로 Gemini API의 모든 기능을 사용하여 앱과 워크플로를 빌드할 수 있습니다. Gemini API 기능을 시작하려면 다음 가이드를 참고하세요.

텍스트 생성
Vision
오디오
긴 컨텍스트
Gemini API 메서드 및 요청 매개변수에 관한 자세한 문서는 API 참조의 가이드를 참고하세요.


대화형 채팅 빌드
Gemini API를 사용하여 사용자를 위한 양방향 채팅 환경을 빌드할 수 있습니다. API의 채팅 기능을 사용하면 여러 번의 질문과 응답을 수집할 수 있으므로 사용자가 점진적으로 답변을 찾거나 여러 부분으로 구성된 문제와 관련하여 도움을 받을 수 있습니다. 이 기능은 챗봇, 양방향 교사, 고객 지원 어시스턴트와 같이 지속적인 커뮤니케이션이 필요한 애플리케이션에 적합합니다.

다음 코드 예는 기본 채팅 구현을 보여줍니다.


// Make sure to include these imports:
// import { GoogleGenerativeAI } from "@google/generative-ai";
const genAI = new GoogleGenerativeAI(process.env.API_KEY);
const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });
const chat = model.startChat({
  history: [
    {
      role: "user",
      parts: [{ text: "Hello" }],
    },
    {
      role: "model",
      parts: [{ text: "Great to meet you. What would you like to know?" }],
    },
  ],
});
let result = await chat.sendMessage("I have 2 dogs in my house.");
console.log(result.response.text());
result = await chat.sendMessage("How many paws are in my house?");
console.log(result.response.text());