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
      "storeId": 3,
      "userId": 1,
      "comment": "너무 맛있네요",
      "star": 4.5,
      "createAt": "2021-08-01",
    },
    {
      "store": 2,
      "userId": 4,
      "comment": "진짜 대박",
      "star": 5.0,
      "createAt": "2021-06-13",
    },
    {
      "store": 1,
      "userId": 2,
      "comment": "별로에요",
      "star": 3.0,
      "createAt": "2021-08-29",
    },
    {
      "store": 1,
      "userId": 1,
      "comment": "극혐",
      "star": 1.0,
      "createAt": "2021-08-30",
    },
    {
      "store": 2,
      "userId": 1,
      "comment": "추천합니다",
      "star": 4.0,
      "createAt": "2021-07-30",
    },
    {
      "store": 1,
      "userId": 3,
      "comment": "평범",
      "star": 3.5,
      "createAt": "2021-08-25",
    },
  ];
}