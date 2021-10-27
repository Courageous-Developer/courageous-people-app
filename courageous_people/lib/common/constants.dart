import 'package:flutter/material.dart';

// theme
const THEME_COLOR = Color.fromRGBO(153, 205, 50, 1);

// naver api
const NAVER_API_CLINET_ID = 'urZ9JPDMKhTzoEHs95Kf';
const NAVER_API_CLINET_SECRET = 'PotBDueQ_J';

const X_NCP_APIGW_API_KEY_ID = 'b6dk9ntigx';
const X_NCP_APIGW_API_KEY = 'b0rXqu99a0l3GKcamz51t4PzkB6HQ8F6ppzm5JSG';

// user hive
const USER_HIVE_STORE = '_user';
const USER_HIVE_ID_FIELD = "_id";
const USER_HIVE_NICKNAME_FIELD = "_nickname";
const USER_HIVE_BIRTH_DATE_FIELD = '_birthDate';
const USER_HIVE_EMAIL_FIELD = "_email";
const USER_HIVE_FAVORITE_FIELD = "_favorite";
const USER_HIVE_MANAGER_FLAG_FIELD = "_managerFlag";

// DB server url
const REQUEST_URL =
    'http://ec2-13-209-14-10.ap-northeast-2.compute.amazonaws.com:8000';

// naver api request url
const PLACE_SEARCH_REQUEST_URL =
    'https://openapi.naver.com/v1/search/local.json';
const REVERSE_GEOCODE_REQUEST_URL =
    'https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc';
const GEOCODE_REQUEST_URL =
    'https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode';