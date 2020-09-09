# Stride
### Flutter App (IOS & Android)

IOS / Android 를 두 가지 시장의 빠른 출시와 피드백 반영을 위해 크로스 플랫폼 앱으로 프로젝트를 진행하기로 결정하였습니다. React Native보다 Flutter가 애니메이션과 관련된 기능이 우수하다고 판단하여 Flutter로 개발을 진행하게 되었습니다.

--- 
- SW Maestro 11기 도담신담 팀 Mobile Application
- 개발기간: `20.07.18 ~ 
- Google에서 공식적으로 권장한 Flutter Provider Design Pattern으로 코드를 설계하였고, MVVM Pattern을 이용해 유지보수가 쉽게 개발을 진행하였습니다.
---

## 개발 현황
- `20.07.18: Navigation 기능 및 구현 완성
- `20.07.18: Google & Facebook OAuth 로그인 구현
- `20.07.20: 로그아웃 기능 구현
- `20.07.21: 드레스룸 UI 및 기능 구현
- `20.07.23: 구매 페이지 UI 및 기능 구현 
- `20.07.24: 룩북 UI 및 기능 구현
- `20.07.26: 스와이프 UI 디자인 구현
- `20.07.28: 로딩 위젯 구현
- `20.07.29: 페이지 전환 애니메이션 구현
- `20.08.02: 코드 리팩토링
- `20.08.03: Naver & KaKao 연동 로그인 기능 완성(OAuth)
- `20.08.04: Firebase Analytics, Crashlytics 연동
- `20.08.10: 스와이프 기능 구현
- `20.08.11: 마이페이지 UI구현
- `20.08.13: 사용자 정보 입력 페이지 구현
- `20.08.15: 모바일 앱 프로토타입 1.0 완성

## 스크린샷

---
## 사용 라이브러리
- ###### Firebase
  - firebase_core: ^0.4.5
  - firebase_crashlytics: ^0.1.4+1
  - firebase_analytics: ^5.0.16
- ###### 상태관리
  - provider: ^4.3.1
  - rxdart: ^0.24.1
- ###### 네트워크
  - dio: ^3.0.10
  - json_annotation: ^3.0.1
  - cached_network_image: ^2.2.0+1
- ###### DB
  - shared_preferences: ^0.5.8
  - flutter_secure_storage: ^3.3.3
- ###### 기능
  - webview_flutter: ^0.3.22+1
  - modal_bottom_sheet: ^0.2.0+1
  - awesome_dialog: ^1.1.3
- ###### UI
  - font_awesome_flutter: ^8.8.1
  - carousel_slider: ^2.2.1
  - fancy_shimmer_image: ^1.2.0
  - tutorial_coach_mark: ^0.5.1

---
## 정보
###### 컴퓨터 구성 / 필수 조건 안내 (Prerequisites)
- Flutter SDK
###### 사용법 (Installation Process)
- flutter doctor
- flutter pub get
- flutter run
###### 저작권 및 사용권 정보 (CopyRight / End User License)
- 미정
###### 배포자 및 개발자 연락처 정보(Contact Information)
- leedh2008@naver.com
###### 알려진 이슈 (Known Issues)
- 로그아웃 시 서비스 모델의 초기화가 필요함, Provider MVVM 패턴 개선 예정
##### 크레딧 (Credit)
- 추가 예정
##### 업데이트 정보 (Change Log)
- `20.08.19: 초기 문서 작성

---
## 향후 계획
#### 출시 관련
- ###### 튜토리얼 페이지 구현
- ###### UI 변경
- ###### 서비스 플레이스토어/앱스토어 출시 20.09.30

#### TO-DO
- ## 오픈베타

[ALMOST] 1. User 사이즈 정보 서버로 주고 받기, 서버로부터 사이즈에 맞는 옷만 가져오기 ⭐⭐⭐⭐⭐
[ALMOST] 2. 애플, 카카오 SDK 붙이기 ⇒ 현재 카카오, 네이버는 WebView로 했으나 수정해야함 ⭐⭐⭐⭐⭐
[ALMOST] 9/6 ~ 9/8 3. 배치고사 만들기 ⭐⭐⭐⭐⭐
[ALMOST] 12. 튜토리얼(설명) 만들기 ⭐⭐
[DONE] 버전처리
[DONE] 마이페이지에서 사이즈 수정하기 ⭐⭐⭐⭐
[DONE] 가로버전 금지해놓기
[ALMOST] 9/4 ~ 9/6 4. Swipe Card UI 코드 다시짜기 (이전거 클릭하면 이전 이미지 보여줘야 함) ⭐⭐⭐⭐
[ALMOST] 9/3 7. 로그아웃하면 서비스 모델 비워주기 ⭐⭐⭐⭐
[ALMOST] 8. 파이어베이스, 애널리틱스 붙이기 ⇒ 어느정도 붙임. ⭐⭐⭐
[ALMOST] 9/8 9. Swipe Card Service 코드에서 지나간 카드들 배열에서 없애주기 ⭐⭐
[ALMOST] 10. DressRoom 폴더 기능 완성  ⭐⭐
[ALMOST] 11. FCM 붙이기 ⭐⭐
[DONE] 13. 드레스룸/룩북에 아무 아이템도 없으면 아이템 추가하라는 배경 ⭐⭐⭐
[DONE] 14. 폴더 이동 구현

dress_room_flag, home_flag
드레스룸, 스와이프, 구매페이지, MAKE BUTTON 버튼 설명
피드백 받고
폴더이름 수정할 때 이름 정해주자
모델 붙이기
설문조사 항목 정하기


[ ] 9/6 ~ 9/8 5. 디자인 입히기 ⭐⭐⭐⭐(드레스룸에서 아이템보면 좀 예쁘게, 스와이프에서 아아템 사이즈 볼 때 조금 예쁘게)
[ ] 9/9 6. 배포할 때 여러 준비물 준비하기(개인정보처리방침, 서비스이용약관) ⭐⭐⭐⭐
[ ] 유저 피드백 받기
[ ] 개발자 아이디 빼기, Audience 그룹 삭제, 이벤트 심기
Login with KaKao 깨짐

//
피드백 받기
설문조사 뭘 물어봐야할지 ( 아이디, 전화번호 받기 )


- ###### LoginPage
- [x] 카카오 로그인 기능
- [x] 서버에 요청 전송
- [x] 애플 로그인 기능

- ###### Mypage
- [x] 들어갈 메뉴 생각하기 // 사이즈 수정, 로그아웃, 고객센터, 앱 리뷰쓰기
- [x] List View로 UI 생성
- [x] 본인 사이즈 입력받기

- ###### Swipe View
- [x] 스와이프 UI 및 애니메이션 구현
- [x] 데이터 부족 시 Request 전송 후, 데이터 채워 넣기
- [x] 스와이프 결과 API Request 전송
- [x] 카테고리 별로 받기
- [x] 선물 버튼 클릭 시 구매 페이지로 이동
- [x] 이미지 클릭 시 다른 이미지 보여주기 (Image.copycrop)
- [ ] 토글버튼 클릭 시, 데이터 갱신
- [x] O, X 버튼 클릭 시 애니메이션 생성
- [x] 줄 자 버튼으로 사이즈 보여주기

- ###### Dress Room
- [x] 드레스룸 UI 구현
- [x] Make Button 기능
- [x] 삭제 기능
- [x] Request 전송
- [x] 드레스룸 나갔다 들어오면 선택된 것 풀어주기

- ###### Look Book
- [x] 룩북 UI 구현
- [x] 룩북 이름 수정 기능
- [x] 룩북 삭제 기능

- ###### 튜토리얼 페이지
- [x] 어떤 식으로 튜토리얼 할 지 생각하기
- [x] 본인 나이 입력받기
- [x] 본인 사이즈 입력받기
- [x] 애니메이션 튜토리얼 만들기
- [x] Watcha 튜토리얼 참고해서 배치고사 페이지 만들기

- ###### 그 외
- [x] 토글과 버튼의 위치 바꾸기
- [x] 구매, 좋아요, 싫어요, 메뉴전환 Analytics 붙이기
- [x] Crashlytics 붙이기
- [x] 쇼핑몰 이름바꾸기
- [x] 구매할때 API 날리기
- [x] 폴더 기능 완성
- [x] 유저 사이즈 입력받는 API
- [x] 이미지 리사이징 테스트
- [x] FCM 연동
- [x] 로그아웃하면 서비스 모델 비워주기
- [x] 디자인 코드 재구성
- [ ] Loading시 gif가 필요함, 우선은 라이브러리 사용 (pub.dev)

<img src="/uploads/d9ecafa8b7a962008a0b8333c83da7e3/사이즈입력1.png" width=300/>
<img src="/uploads/fab8b82511de4ae693731fd32e190982/드레스룸_선택_.png" width=300/>
<img src="/uploads/8c52043d16568cc03ff6adcdd6a7afb8/드레스룸_룩북make.png" width=300/>
<img src="/uploads/578989824c880d01c8d994b3a8b67da2/룩북.png" width=300/>
<img src="/uploads/45ae47aa983e37411f30746505e59af9/마이페이지.png" width=300/>
<img src="(/uploads/1af2ed5e86faca00efbcd0a8c4b4c2bf/스와이프뷰.png" width=300/>

![스크린샷_2020-08-20_오전_1.45.09](<img src="/uploads/bca9f0225f3180b9459889fc11f9ce25/스크린샷_2020-08-20_오전_1.45.09.png" width=300/>)
![스크린샷_2020-08-20_오전_1.32.43](<img src="/uploads/a5555e356fe8efabf6ce5a7b8efc0769/스크린샷_2020-08-20_오전_1.32.43.png" width=300/>)
![스크린샷_2020-08-20_오전_1.31.36](<img src="/uploads/764be74ee519fc0db7ffd5c0e31e7513/스크린샷_2020-08-20_오전_1.31.36.png" width=300/>)

firebase analytics unique id setting
set user id
