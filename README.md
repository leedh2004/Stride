# Stride

## Team

- SW Maestro 11기 도담신담 팀 Mobile Application
- 개발기간: `20.07.18 ~ 

## Flutter App (IOS & Android)

IOS / Android 를 두 가지 시장의 빠른 출시와 피드백 반영을 위해 ``Cross Platform Application``으로 프로젝트를 진행하기로 결정하였습니다. 

React Native보다 ``Flutter``가 애니메이션과 관련된 기능이 우수하다고 판단하여 Flutter로 개발을 진행하게 되었습니다.

Google에서 공식적으로 권장한 Flutter ``Provider Design Pattern``을 학습하여 코드를 설계하였고, ``MVVM Pattern``을 이용해 유지보수가 쉽게 개발을 진행하였습니다.

## Flask

Stride는 게시판 형태의 복잡한 구조를 가지는 것이 아닌 로그인, REST API서버의 기능과 같은 최소한의 기능이 필요했습니다. 그래서 빠르고 자유롭게 개발 할 수 있는 Flask를 선택하여 진행하였습니다.



## 개발 현황

### FE

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
- `20.08.03: Naver & KaKao OAuth 로그인 구현
- `20.08.04: Firebase Analytics, Crashlytics 연동
- `20.08.10: 스와이프 기능 구현
- `20.08.11: 마이페이지 UI구현
- `20.08.13: 사용자 정보 입력 페이지 구현
- `20.08.15: 모바일 앱 프로토타입 1.0 완성

### BE

- `20.06.26: Flask세팅 및 MockAPI 구현
- `20.07.24: RDS(Postgresql)
- `20.08.02: OAuth JWT토큰 발급 및, https, domain 연결
- `20.08.08: 명세의 모든 API 구현
- `20.08.12: gitlab CI/CD 세팅 및 API 구조 개선 및 기능 추가
- `20.08.15: EC2 로드밸런싱, AutoScaling 설정


## 앱 스크린샷

어플리케이션을 ```iphone 11 Pro Emulator``` 에서 구동한 화면입니다. (`20.08.20 기준)

#### Swipe View

<img src="/uploads/d9ecafa8b7a962008a0b8333c83da7e3/사이즈입력1.png" width=300/>
<img src="/uploads/1af2ed5e86faca00efbcd0a8c4b4c2bf/스와이프뷰.png" width=300/>

#### Dress Room View

<img src="/uploads/fab8b82511de4ae693731fd32e190982/드레스룸_선택_.png" width=300/>
<img src="/uploads/8c52043d16568cc03ff6adcdd6a7afb8/드레스룸_룩북make.png" width=300/>

#### Look Book View

<img src="/uploads/578989824c880d01c8d994b3a8b67da2/룩북.png" width=300/>
<img src="/uploads/764be74ee519fc0db7ffd5c0e31e7513/스크린샷_2020-08-20_오전_1.31.36.png" width=300/>

#### Login View & MyPage View

<img src="/uploads/bca9f0225f3180b9459889fc11f9ce25/스크린샷_2020-08-20_오전_1.45.09.png" width=300/>
<img src="/uploads/45ae47aa983e37411f30746505e59af9/마이페이지.png" width=300/>

## 사용 라이브러리

### FE

- ##### Firebase

  - firebase_core: ^0.4.5
  - firebase_crashlytics: ^0.1.4+1
  - firebase_analytics: ^5.0.16


- ##### 상태관리

  - provider: ^4.3.1
  - rxdart: ^0.24.1


- ##### 네트워크

  - dio: ^3.0.10
  - json_annotation: ^3.0.1
  - cached_network_image: ^2.2.0+1


- ##### DB

  - shared_preferences: ^0.5.8
  - flutter_secure_storage: ^3.3.3


- ##### 기능

  - webview_flutter: ^0.3.22+1
  - modal_bottom_sheet: ^0.2.0+1
  - awesome_dialog: ^1.1.3


- ##### UI

  - font_awesome_flutter: ^8.8.1
  - carousel_slider: ^2.2.1
  - fancy_shimmer_image: ^1.2.0
  - tutorial_coach_mark: ^0.5.1

### BE

- ##### DB

  - pymongo: 3.11.0
  - Psycopg2-binary: 2.8.5

- ##### Server

  - Flask: 1.1.2
  - Flask-Cors: 3.0.8
  - requests: 2.24.0

- ##### login

  - jwt: 1.0.0

    


## 정보

##### 컴퓨터 구성 / 필수 조건 안내 (Prerequisites)

- Flutter SDK
- python3

##### 사용법 (Installation Process)

~~~shell
// FE
flutter doctorf
flutter pub get
flutter run


// BE
pip3 install -r requirements.txt
python3 app.py
~~~



##### 알려진 이슈 (Known Issues)

- 로그아웃 시 서비스 모델의 초기화가 필요함, Provider MVVM 패턴 개선 예정

##### 저작권 및 사용권 정보 (CopyRight / End User License)

- 미정

##### 업데이트 정보 (Change Log)

- `20.08.19: 초기 README 작성


## 향후 계획

#### 프로젝트 관련

- ##### Tutroial View 구현

- ##### 외주 디자인의 UI로 Design Migration

- ##### `20.09.30: 서비스 플레이스토어/앱스토어 출시 

#### TO-DO

- ##### LoginPage View

- [x] 카카오 로그인 기능

- [x] 서버에 요청 전송

- [ ] 애플 로그인 기능

- ##### Swipe View

- [x] 스와이프 UI 및 애니메이션 구현

- [x] 데이터 부족 시 Request 전송 후, 데이터 채워 넣기

- [x] 스와이프 결과 API Request 전송

- [x] 카테고리 별로 받기

- [x] 선물 버튼 클릭 시 구매 페이지로 이동

- [ ] 이미지 클릭 시 다른 이미지 보여주기 (Image.copycrop)

- [ ] 토글버튼 클릭 시, 데이터 갱신

- [ ] O, X 버튼 클릭 시 애니메이션 생성

- [ ] 줄 자 버튼으로 사이즈 보여주기

- ##### Dress Room

- [x] 드레스룸 UI 구현

- [x] Make Button 기능

- [x] 삭제 기능

- [x] Request 전송

- [x] 드레스룸 나갔다 들어오면 선택된 것 풀어주기

- ##### Look Book

- [x] 룩북 UI 구현

- [x] 룩북 이름 수정 기능

- [x] 룩북 삭제 기능

- ##### Mypage View

- [x] 들어갈 메뉴 생각하기 // 사이즈 수정, 로그아웃, 고객센터, 앱 리뷰쓰기

- [x] List View로 UI 생성

- [x] 본인 사이즈 입력받기

- ##### Tutorial View

- [x] 어떤 식으로 튜토리얼 할 지 생각하기

- [x] 본인 나이 입력받기

- [x] 본인 사이즈 입력받기

- [ ] 애니메이션 튜토리얼 만들기

- [ ] Watcha 튜토리얼 참고해서 배치고사 페이지 만들기

- ##### Extra

- [x] 구매할때 API 날리기

- [x] 토글과 버튼의 위치 바꾸기

- [ ] Loading시 gif가 필요함, 우선은 라이브러리 사용 (pub.dev)

- [ ] 구매, 좋아요, 싫어요, 메뉴전환 Analytics 붙이기

- [ ] Crashlytics 붙이기

- [ ] 쇼핑몰 이름 바꾸기

- [ ] FCM 연동

- [ ] 유저 햅틱고려

- [ ] 로그아웃하면 서비스 모델 비워주기

- [ ] 토글 UI 변경