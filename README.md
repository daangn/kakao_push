# KakaoPush [![Gem Version](https://badge.fury.io/rb/kakao_push.svg)](https://badge.fury.io/rb/kakao_push) [![Build Status](https://travis-ci.org/n42corp/kakao_push.svg)](https://travis-ci.org/n42corp/kakao_push)

카카오 플랫폼 API에서 제공하는 [푸시알림](https://developers.kakao.com/features/platform#푸시-알림)을 호출하는 젬입니다. iOS, 안드로이드 사용자에게 푸시를 보낼때 유용한 카카오 푸시알림은 REST API로만 제공되고 있기에 이를 젬으로 만들어 봤습니다.

[당근마켓](https://www.daangn.com/)([아이폰](https://itunes.apple.com/kr/app/pangyojangteo/id1018769995?l=ko&ls=1&mt=8), [안드로이드](https://play.google.com/store/apps/details?id=com.towneers.www))에서 사용하던 코드를 젬으로 만들었습니다.

주의: 이 젬은 카카오에서 공식적으로 제공하는 젬이 아닙니다. 이점 유의 하시기 바랍니다.

## 설치

Gemfile 파일에 다음과 같이 추가하고:

```ruby
gem 'kakao_push', '~> 0.1.2'
```

아래 명령어를 실행합니다:

    $ bundle

혹은 젬을 직접 설치할 수 있습니다:

    $ gem install kakao_push

## 사용법

### 클라이언트 객체 생성

키를 직접 넘기거나, 기본값으로 env값을 참조할 수 있습니다:

```ruby
client = KakaoPush::Client.new(rest_api_key: 'kakao_admin_key')

# 아니면
# KAKAO_PUSH_CLIENT_ID=kakao_admin_key

client = KakaoPush::Client.new
```

### 토큰 등록

파라미터 및 응답에 관한 자세한 정보는 [카카오 REST API 개발가이드 - 푸시알림](https://developers.kakao.com/docs/restapi#푸시-알림) 참고

```ruby
res = client.register(uuid: 1, push_type: 'apns', device_id: 'device_id', push_token: 'push_token')

res.success? # 등록에 성공한 경우 true
res.fail? # 등록에 실패한 경우 true
res.data # 등록에 성공한 경우 숫자 30 반환. 30일 후에 해당 토큰이 만료됨을 의미
=> 30
```

### 토큰 조회

파라미터 및 응답에 관한 자세한 정보는 [카카오 REST API 개발가이드 - 푸시알림](https://developers.kakao.com/docs/restapi#푸시-알림) 참고

```ruby
res = client.tokens(uuid: 1)

res.success? # 조희에 성공한 경우 true
res.fail? # 조회에 실패한 경우 true
res.data # 조회에 성공한 경우 데이터 반환. 배열로 반환되지만 배열 객체는 1개 뿐이므로 유의
=> [{"user_id":"1","device_id":"a","push_type":"apns","push_token":"aaa","created_at":"2015-12-11T11:34:17Z","updated_at":"2015-12-11T11:34:17Z"}]
```

### 토큰 삭제

파라미터 및 응답에 관한 자세한 정보는 [카카오 REST API 개발가이드 - 푸시알림](https://developers.kakao.com/docs/restapi#푸시-알림) 참고

```ruby
res = client.deregister(uuid: 1, push_type: 'apns', device_id: 'device_id')
res.success? # 삭제에 성공한 경우 true
res.fail? # 삭제에 실패한 경우 true
```

### 푸시 전송

파라미터 및 응답에 관한 자세한 정보는 [카카오 REST API 개발가이드 - 푸시알림](https://developers.kakao.com/docs/restapi#푸시-알림) 참고

```ruby
apns = KakaoPush::Apns.new(badge: nil, sound: 'default', push_alert: true, message: nil, custom_field: nil, push_token: nil)
gcm = KakaoPush::Gcm.new(collapse: nil, delay_while_idle: nil, time_to_live: nil, dry_run: nil, priority: nil, return_url: nil, custom_field: 'data', push_token: nil)
res = client.send(uuids: [1], apns: apns, gcm: gcm, bypass: false)

res.success? # 전송에 성공한 경우 true
res.fail? # 전송에 실패한 경우 true
```

success? 결과가 true이더라도 실제 사용자에 디바이스에 전송되었음을 보장하지 않음. 메시지 포맷이 다르거나 맞지 않아도 success? 값이 true로 반환되기도 하므로 실제 전송 유무는 디바이스에서 테스트가 필요합니다.

### 서버에 저장할 값

디바이스로부터 받은 토큰, 푸쉬 타입(apns, gcm)은 서버에 저장하는것이 좋다. 토큰 삭제를 안할거라면 푸쉬 타입은 굳이 저장할 필요 없습니다. 푸쉬 토큰은 30일이 지나면 토큰 조회 API를 통해서도 조회 할 수 없으므로 될수 있으면 저장하는 편이 좋다고 생각합니다.

예를 들어보자면 디바이스로부터 받은 토큰과 카카오 푸쉬 만료 예정일을 서버에 저장하고 푸쉬 만료 예정일이 되기 전에 다시 토큰 등록 API를 호출하는 사례도 있습니다.

## 에러 상황

정상적인 파라미터를 제공 했음에도 아래와 같은 오류가 발생 한다면 Kakao Developers 사이트에서 앱 설정의 '푸시 알림'을 활성화 하고 gcm, apns 설정을 잘 했는지 확인해야 합니다. 설정하지 않은 경우 아래와 같이 파라미터가 잘못됬다고 에러 메시지가 반환됩니다.

```
{"code":-2,"msg":"[appName] Invalid Kpusher Param. ( appName=1111, uid=1234, did=dlskjflsk3ksdjfl, pushType=apns, pushToken=lqO_NIwaoAcI0MssA )"}%
```

## 도움 주신 분들

- [@marocchino](https://github.com/marocchino) : 테스트 코드에서 막혀 있을때 도움 주셨습니다.
- [@shia](https://github.com/riseshia) : 응답 및 푸시 메시지 구조를 잡는데 도움 주셨습니다. 
- [qiita-rb](https://github.com/increments/qiita-rb) : faraday 사용법등 젬을 만드는데 많은 부분 도움 받았습니다.

## Contributing

버그 레포팅과 풀리퀘스트는 GitHub에 남겨주세요. https://github.com/n42corp/kakao_push
