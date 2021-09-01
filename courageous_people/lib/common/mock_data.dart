import 'classes.dart';

class StoreMockData {
  static final JsonList storeJson = [
    {
      "id": 1,
      "name": "아빠가 만든 스파게티",
      "intro": "아빠가 만든 스파게티입니다",
      "biz_num": "12345-56789",
      "lat": 37.51150487442206,
      "lng": 127.10820281078895,
    },
    {
      "id": 2,
      "name": "VIPS",
      "intro": "VIPS입니다",
      "biz_num": "34567-10239",
      "lat": 37.50608536914156,
      "lng": 127.10864769618433,
    },
    {
      "id": 3,
      "name": "좋은생각",
      "intro": "좋은 생각 돈까스입니다",
      "biz_num": "20202-30303",
      "lat": 37.511468757106826,
      "lng": 127.11274408719322
    },
  ];
}

class UserMockData {
  static final JsonList userJson= [
    {
      "id": 1,
      "nickName": "Cho",
      "email": "abc@naver.com",
      "password": "dngus123!"
    },
    {
      "id": 2,
      "nickName": "Park",
      "email": "pyh@naver.com",
      "password": "dudgns123!"
    },
    {
      "id": 3,
      "nickName": "Kim",
      "email": "kim@naver.com",
      "password": "qhgus123!"
    },
    {
      "id": 4,
      "nickName": "Bae",
      "email": "rolling@naver.com",
      "password": "tjdgh123!"
    },
  ];
}

class ReviewMockData {
  static final JsonList reviewJson = [
    {
      "id": 1,
      "store_id": 3,
      "user_id": 1,
      "comment": "너무 맛있네요",
      "grade": 4.5,
      "createAt": "2021-08-01",
    },
    {
      "id": 2,
      "store_id": 2,
      "user_id": 4,
      "comment": "진짜 대박",
      "grade": 5.0,
      "createAt": "2021-06-13",
    },
    {
      "id": 3,
      "store_id": 1,
      "user_id": 2,
      "comment": "별로에요",
      "grade": 3.0,
      "createAt": "2021-08-29",
    },
    {
      "id": 4,
      "store_id": 1,
      "user_id": 1,
      "comment": "극혐",
      "grade": 1.0,
      "createAt": "2021-08-30",
    },
    {
      "id": 5,
      "store_id": 2,
      "user_id": 1,
      "comment": "추천합니다",
      "grade": 4.0,
      "createAt": "2021-07-30",
    },
    {
      "id": 6,
      "store_id": 1,
      "user_id": 3,
      "comment": "평범",
      "grade": 3.5,
      "createAt": "2021-08-25",
    },
  ];
}