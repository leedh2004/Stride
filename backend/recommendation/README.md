## Stride Recommendation Engine

ServiceDB에서 추출, 파싱한 데이터를 ''AWS ElasticSearch Service''에 인덱스하여 추천엔진서버를 구축하였습니다.
별개의 인덱스에 사용자별 추천 아이템을 저장하고, ServiceAPI서버에서 ES EndPoint을 이용하여 추천 리스트를 받아 클라이언트에 전달합니다.


### Team

- SW Maestro 11기 도담신담 팀


## Elastic Search

### 1) 검색 엔진

상품 데이터, 유저 평가 데이터가 비대해질 경우를 대비하여 대량의 데이터를 빠르게 검색하기 위한 검색 엔진을 구현할 예정입니다.

### 2) 추천 엔진

초기에는 사용자가 선호하는 쇼핑몰 컨셉에 부합하는 아이템을 추천하고,
유저 평가 데이터를 확보한 후에 Collaborative Filtering을 통해 아이템 추천을 추천하는 two-step 추천 알고리즘을 구현하였습니다.


## Cold Start 해결

약 200개의 상품에 대해 20대 여성 30명에게 UserTest를 진행,
초기 데이터와 서비스 컨셉에 대한 반응을 확보하였고
이를 바탕으로 추천 알고리즘 로직을 개선하여 Cold Start 문제를 해결했습니다.

<img src="/uploads/a5b32d7975163865dbf3437d7839bd1d/usermaker.png" width=600 />



## 개발 현황

- 20.08.01-20.08.10: AWS ElasticSEarch Service 구축, 사용자 선호 쇼핑몰 컨셉 기반 추천 알고리즘 구현, UserTest 결과를 분석하여 쇼핑몰 컨셉 가중치 수정
- 20.08.10-20.08-15: Collaborative Filtering 구현, 추천 리스트 구성 로직 구현


## 라이브러리
- ElasticSearch: elasticsearch 7.8.0
- DB: psycopg2-binary 2.8.5


## 정보

##### 컴퓨터 구성 / 필수 조건 안내 (Prerequisites)

- Python3.6이상

**사용법 (Installation Process)**

~~~python
pip3 install ElasticSearch
python3 main.py
~~~

##### 알려진 이슈 (Known Issues)

- 데이터 사이즈가 커질 경우 Scroll API를 통해 전체 데이터를 받아오도록 수정

## 향후 계획

- 실제 데이터 확보를 통한 추천엔진 성능 향상
- 암시적인 유저 행동 데이터도 추가하여 추천 모델 정교화
