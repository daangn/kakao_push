## 0.1.3 (2017-01-12)

Add:

  - GCM 옵션에 time_to_live, dry_run, priority 추가

## 0.1.2 (2016-01-12)

Bugfixes:

  - API 호출시 timeout 값을 5초로 설정. 이 값이 설정되어 있지 않으면 무제한 대기하게됨. 스레드 기반의 sidekiq, puma 등에서 문제가 발생할 여지가 있음