## 0.1.7 (2018-07-04)

- apns 메시지에 apns_env 값 추가. 푸시키 방식에서는 입력 해야함
- apns, gcm 값이 false인 경우 해당 필드의 키가 제외되는 버그 수정

## 0.1.6 (2018-03-20)

- faraday 최소 버전을 0.9로 변경

## 0.1.5 (2018-03-20)

Bugfixes:

  - 오류 수정
  - faraday 최신버전을 사용할수 있게 gemspec 변경
  - faraday 최소 버전을 0.14로 변경
  - faraday_middleware 최소 버전을 0.12 으로 변경

## 0.1.4 (2018-03-20)

Add:

  - 타임아웃 에러 발생시 재시도 옵션 추가

## 0.1.3 (2017-01-12)

Add:

  - GCM 옵션에 time_to_live, dry_run, priority 추가

## 0.1.2 (2016-01-12)

Bugfixes:

  - API 호출시 timeout 값을 5초로 설정. 이 값이 설정되어 있지 않으면 무제한 대기하게됨. 스레드 기반의 sidekiq, puma 등에서 문제가 발생할 여지가 있음
