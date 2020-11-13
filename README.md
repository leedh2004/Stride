# Stride

- Play Store: https://play.google.com/store/apps/details?id=kr.co.stride.app
- App Store: https://apps.apple.com/kr/app/id1531507804

## Team

- SW Maestro 11기 도담신담 팀 Mobile Application
- 개발기간: `20.07.18 ~ 

## Flutter App (IOS & Android)

IOS / Android 를 두 가지 시장의 빠른 출시와 피드백 반영을 위해 ``Cross Platform Application``으로 프로젝트를 진행하기로 결정하였습니다. 

React Native보다 ``Flutter``가 애니메이션과 관련된 기능이 우수하다고 판단하여 Flutter로, ``Provider Architecture``를 기반으로 개발을 진행하게 되었습니다.

``Provider`` 패턴은 2019 Google IO에 공식적으로 추천되면서 큰 주목을 받은 패턴으로, 클라이언트 화면에서 변화가 있는 부분만 렌더링함으로써 효율적인 모바일 어플리케이션 환경을 구축합니다. 

Stride 모바일 어플리케이션은 Google에서 공식적으로 권장한 Flutter ``Provider Design Pattern``을 학습하여 코드를 설계하였고, ``MVVM Pattern``을 이용해 유지보수가 쉽도록 개발을 진행하였습니다.

다음은 앱의 구조를 간단하게 도식화한 그림입니다.

<img src="/uploads/0f9a81baf43768e84c582f888119be0a/Untitled_Diagram.png"/>

## Flask

Stride는 게시판 형태의 복잡한 구조를 가지는 것이 아닌 로그인, REST API서버의 기능과 같은 최소한의 기능이 필요했습니다. 그래서 빠르고 자유롭게 개발 할 수 있는 Flask를 선택하여 진행하였습니다.

## Search & Recommendation Engine

ServiceDB에서 추출, 파싱한 데이터를 ``AWS ElasticSearch Service``에 인덱스하여 아이템 검색 및 추천 엔진을 구축하였습니다. 

### 1) 검색 엔진

상품 데이터, 유저 평가 데이터가 비대해질 경우를 대비하여 대량의 데이터를 빠르게 검색하기 위해 ``ElasticSearch``를 이용한 검색 엔진을 구현하였습니다.

다음은 ElasticSearch에 인덱스된 상품 정보 document 예시입니다.


![es_document](/uploads/5a29b84e92fe7ced0011da30fb68a7cb/es_document.png)

상품의 카테고리(아우터, 팬츠, 스커트 등), 색상, 사이즈, 가격, 쇼핑몰 컨셉 등 다양한 조건을 넣어서 상품을 검색할 수 있도록 인덱스를 구성하였습니다.

### 2) 추천 엔진

Cold Start를 방지하기 위한 2-step 추천 알고리즘

- Cold-start Algorithm: 컨텐츠 기반 추천 알고리즘으로, 사용자가 선호하는 쇼핑몰 컨셉을 기반으로 상품을 추천합니다.
- Collaborative Filtering: 비슷한 성향을 가진 사용자들이 좋아한 아이템을 추천합니다.



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
- `20.08.27 Swipe Model MVVM 패턴으로 변경
- `20.08.30 파이어베이스 잘못된 설정 다시 연동, Crashyltics & analytics 붙임
- `20.08.31 파이어베이스 로그 심음, 프로토타입 UI 완성
- `20.09.2 드레스룸 폴더 기능 완성, 애플로그인 기능 완성
- `20.09.3 FCM 기능 완성
- `20.09.5 전체적인 로그인 기능 완성
- `20.09.6 스와이프 민감도 조정
- `20.09.7 드레스룸 폴더 버그 수정, 팝업 디자인 수정
- `20.09.8 디자인 수정
- `20.09.09 튜토리얼 UI완성
- `20.09.10 앱 아이콘 적용
- `20.09.11 프로토타입 1.0 완성, 앱스토어, 구글 스토어 심사요청
- `20.09.12 0.2.0 앱스토어, 플레이스토어 배포 완료
- `20.09.14 로딩 위젯 변경
- `20.09.16 1.0.2 카카오 로그인 이슈 해결
- `20.09.23 ~ 10/16 클로즈베타 이후, 피드백 반영하여 전반적인 수정 작업 진행
- `20.10.5 스와이프 클래스 삭제 전
- `20.10.8 ~ 11 맥북 고장으로 인한 개발 중단
- `20.10.12 배포한 앱 버그 픽스
- `20.10.13 폴더쪽 비동기로 가능한 부분은, 비동기로 변경
- `20.10.14 1.1.1
- `20.10.15 1.1.2 배포, 안드로이드 멈춤 현상 수정
- `20.10.16 1.1.3 배포, 광고를 위한 앱 퍼블리싱 페이지 제작완료
- `20.10.17 1.1.4 앱사이즈 최적화 (70MB -> 25MB)
- `20.10.19 1.1.5 배포 예전 튜토리얼 멈춤 버그, 튜토리얼 이미지가 안보이는 버그 픽스
- `20.10.22 1.2.0 디자인 받은 메인페이지 수정하여 재배포
- `20.10.23 스와이프 코드 리팩토링
- `20.10.24 1.2.1 배포, 안드로이드에 앱이 실행되지 않았던 버그 픽스
- `20.10.26 파이어베이스 데이터 분석 후 비회원 로그인 기능 추가
- `20.10.27 1.3.0 배포, 추천페이지 디자인 수정, 룩북 구매하기 버튼 추가, UI개선 작업 
- `20.10.28 1.3.2
- `20.11.01 1.4.0 UI개선 작업, 튜토리얼 방식 개선
- `20.11.03 1.5.0 대화형 튜토리얼 방식으로 변경
- `20.11.04 1.5.2 튜토리얼 멈춤현상 해결
- `20.11.05 1.5.3 에뮬레이터는 파이어베이스 로그에 안남도록 이벤트 추가
- `20.11.09 스플래시 스크린 적용
- `20.11.07 1.5.6 튜토리얼 중 안드로이드 백 버튼 시, 튜토리얼 종료
- `20.11.09 1.5.7 뒤로가기 화살표 색상 칠함, 룩북쪽 수정
- `20.11.10 1.6.0 모든 기능 구현, 룩북쪽 꾸미기 완성, 이미지 프리캐쉬쪽 코드 개선, 이미지 로딩시 로딩이미지 표시, 앱 평가 기능 추가
- `20.11.12 1.7.0 로딩 위젯 변경, 에러페이지, 잠금 페이지, 로그인페이지 변경, 로그인쪽 코드 병렬화, 로그인쪽 코드 파이어베이스 삭제, 폴더 삭제 멘트 변경, 튜토리얼 스킵 넣음, 튜토리얼 이미지 넣음

### BE

- `20.06.26: Flask세팅 및 MockAPI 구현
- `20.07.24: RDS(Postgresql)
- `20.08.02: OAuth JWT토큰 발급 및, https, domain 연결
- `20.08.08: 명세의 모든 API 구현
- `20.08.12: gitlab CI/CD 세팅 및 API 구조 개선 및 기능 추가
- `20.08.15: EC2 로드밸런싱, AutoScaling 설정

### Search & Recommendation

- `20.08.10: 쇼핑몰 기반 추천 알고리즘 구현
- `20.08.15: Collaborative Filtering 알고리즘 구현
- `20.08.29: 쇼핑몰 컨셉 가중치 수정
- `20.08.31: 인덱스에 쇼핑몰 카테고리 추가
- `20.09.01: ES 인덱스 함수 리팩토링
- `20.09.02: 카테고리 별로 추천 아이템 계산하도록 알고리즘 수정,
- `20.09.07: 사이즈 필터링 구현, 쿼리 튜닝
- `20.09.09: 추천 로직 개선, 추천 리스트에 유저 선호 컨셉 이외의 아이템 추가
- `20.09.10: 추천 아이템 리스트 중복 제거 로직 개선
- `20.09.11: 유저 비선호 컨셉 아이템에서 중복이 일어나는 에러 수정
- `20.09.14: 전체 아이템 리스트 중복 제거, CF 알고리즘 버그 수정
- `20.09.17: ES 인덱스 Bulk api 추가
- `20.09.18: 유효하지 않은 상품(쇼핑몰에서 삭제된 상품) ES에서 제거
- `20.10.02: 추천 모델 버그 수정, ES 인덱스 수정, 쇼핑몰 컨셉 계산 로직 수정
- `20.10.04: 상품 필터 검색 기능 추가
- `20.10.05: 추천 리스트 길이 문제 해결, 클라이언트-서버-ES 중복 아이템 제거 파이프라인 구현
- `20.10.09: 서버-ES Sync 
- `20.10.17: ES 커넥션 연결 로직 수정
- `20.10.26: ES에서 시즌 오프 상품 제거, 아이템 추천 로직 변경
- `20.10.30: 검색 결과가 나오지 않는 이슈 해결
- `20.11.02: 검색 쿼리 개선
- `20.11.06: 쇼핑몰 컨셉 가중치 변경, 실사용자 데이터 반영


## 앱 스크린샷

어플리케이션을 ```iphone 12 Pro Emulator``` 에서 구동한 화면입니다. (`20.08.20 기준)

#### Swipe View

<img src="/uploads/c922278166ecf87caf3e4f56d5789bd6/main1.png" width=300/>
<img src="/uploads/7b291b21202c17115ccd79b3a1b3ab2d/main_2.png" width=300/>
<img src="/uploads/0a3d31c4589db89abf2c2254ac7206bf/main_3.png" width=300 />
<img src="/uploads/7c9a269abdd013b9857102860be98556/main_4.png" width=300 />
<img src="/uploads/4693d8ab52f114491916599cfa0bcf3d/main_5.png" width=300 />

#### Recommend View

<img src="/uploads/3ec9185f5f5b39726a6da144e8f9a4f0/recommend_1.png" width=300 />
<img src="/uploads/4ba270dc91b307d9f7e03b4eb76cff68/recommend_2.png" width=300 />
<img src="/uploads/dc658ae56b58b8cb471cb57212542bc1/recommend_3.png" width=300 />
<img src="/uploads/451325c796b2264056415b9569f5ea6b/recent.png" width=300 />

#### Look Book View

<img src="/uploads/13a96aa1be66d24b21b96297100abe8a/lookbook.png" width=300 />
<img src="/uploads/a3abc21dc626c52a9990b217d1f8d4c1/lookbook_2.png" width=300 />
<img src="/uploads/22047e577d2424cc10b5611af5f0a5c7/lookbook_3.png" width=300 />
<img src="/uploads/7c6e1544e1ac9ea940ec3f9392cef9e4/lookbook_4.png" width=300 />
<img src="/uploads/43883c9d7fb4dc6e440fc44b114ad235/look_book_make.png" width= 300 />

#### Dress Room View

<img src="/uploads/929a6796a14a313bd5cbf3631e3b2ec1/dressroom.png" width=300/>
<img src="/uploads/29df8f3d4b2ec8376f3ce900cd54fe8d/dressroom_2.png" width=300/>
<img src="/uploads/10fb9fda4951d2d3fd9f7a10cfd88328/item_remove.png" width=300/>
<img src="/uploads/9edbacd8519246f3bc07434ad7629041/select_menu.png" width=300/>
<img src="/uploads/6dae92e076152ef71c2890ee1c0002fd/folder_move.png" width=300/>

#### Login & Tutorial View

<img src="/uploads/50fa6c6f051aa6852258d7a49fdaa7e5/tutorial_1.png" width=300 />
<img src="/uploads/f472432037e9f87dd58ee19e4820b3db/tutorial_2.png" width=300 />
<img src="/uploads/4ce777a2c9de7a7faf3068e1a64f8a54/tutorial.png" width=300 />
<img src="/uploads/c898c028e41f43981555365949355299/login.png" width=300 />

#### Mypage View

<img src="/uploads/69459c55a433db6e398169f5d8140417/mypage_1.png" width=300/>
<img src="/uploads/7d34dac726ac4714a6a446189eb07af7/mypage_2.png" width=300/>
<img src="/uploads/15e8fc60a314da7b305591b8527b969a/mypage_3.png" width=300/>
<img src="/uploads/4fd7ccdca214d88740277ac4e64b1f70/mypage_4.png" width=300/>

#### etc View

<img src="/uploads/d7754063641bbeb70add3ef4b5996416/etc1.png" width=300 />
<img src="/uploads/e4300deeda8acc97875785ae401afc9b/etc2.png" width=300 />
<img src="/uploads/57bb1f39655dc6733d1c775449d6b520/etc3.png" width=300 />

## 사용 라이브러리

### FE

- ##### Firebase

  - firebase_core: ^0.5.2
  - firebase_remote_config: ^0.4.2
  - firebase_auth: ^0.18.3
  - firebase_analytics: ^6.2.0
  - firebase_crashlytics: ^0.2.3
  - firebase_messaging: ^7.0.3

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

  - webview_flutter: 1.0.0
  - modal_bottom_sheet: ^0.2.0+1
  - awesome_dialog: ^1.1.3
  - in_app_review: ^1.0.2

- ##### OAuth Login

  - apple_sign_in: ^0.1.0
  - uuid: ^2.2.2
  - kakao_flutter_sdk: ^0.5.0

- ##### UI & UX

  - font_awesome_flutter: ^8.8.1
  - carousel_slider: ^2.2.1
  - fancy_shimmer_image: ^1.2.0
  - flushbar: ^1.0.4
  - custom_pop_up_menu: ^1.1.0
  - flutter_sliding_tutorial: ^0.1.0
  - font_awesome_flutter: ^8.8.1
  - flutter_svg: ^0.18.1
  - animated_widgets: ^1.0.6
  - custom_switch: ^0.0.1
  - pull_to_refresh; ^1.6.1

- ##### App Icon & Splash

  - flutter_native_splash: ^0.1.9
  - flutter_launcher_icons: ^0.7.5


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

- **Search & Recommendation Engine**

  - ElasticSearch: 7.8.0


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



##### 알려진 버그 (Known Issues)

- 없음

##### 저작권 및 사용권 정보 (CopyRight / End User License)

- 미정

##### 업데이트 정보 (Change Log)

- `20.08.19: 중간발표 README 작성
- `20.11.13: 최종발표 README 작성


## 향후 계획

#### 프로젝트 관련

- ##### 어플리케이션 홍보 진행 예정

#### 폴더 구조

<img src="/uploads/1ac8bf96b2003ab6596187f5bd9399c9/folder.png" width=300/>

- lib/core/constant: 코어 부분(뷰와 관련되지 않음)에서 공통적으로 사용할 상수값들을 저장한다.

- lib/core/service: service class들이 존재하고, 이는 MVVM 패턴에서 Model과 대응된다.

- lib/core/viewmodels: view model class가 존재하고, 이는 MVVM 패턴에서 View Model과 대응된다.

- lib/core/models: 서비스를 위해 필요한 데이터를 처리하기 위한 구조를 지정한다.

- lib/ui/shared: view에서 공통적으로 공유하는 widget들을 모아 두었다.

- lib/ui/views: view class가 존재하고, 전체적인 view를 의미한다. 다시 말해, 이는 MVVM 패턴에서 View와 대응된다.

- lib/ui/widgets: view를 구성하는 위젯들을 재사용하기 위해 따로 만들었다.