require 'kakao_push'

KAKAO_ADMIN_KEY = "카카오 Admin Key"
client = KakaoPush::Client.new(rest_api_key: KAKAO_ADMIN_KEY)


######## iOS

IOS_PUSH_TYPE = "apns"
IOS_DEVICE_ID = "푸쉬 토큰"
IOS_PUSH_TOKEN = "푸쉬 토큰"
IOS_UUID = 1

# 등록
p client.register(
  uuid: IOS_UUID, 
  push_type: IOS_PUSH_TYPE,
  device_id: IOS_DEVICE_ID,
  push_token: IOS_PUSH_TOKEN
)

# 조희
p client.tokens(uuid: IOS_UUID)

# 전송
apns = KakaoPush::Apns.new(badge: 1, sound: 'default', push_alert: true, message: "kakao_push gem message", custom_field: nil, push_token: IOS_PUSH_TOKEN)
gcm = KakaoPush::Gcm.new(collapse: nil, delay_while_idle: nil, return_url: nil, custom_field: 'data', push_token: IOS_PUSH_TOKEN)
p client.send(uuids: [IOS_UUID], apns: apns, gcm: gcm, bypass: false)

# 삭제
p client.deregister(uuid: IOS_UUID, push_type: IOS_PUSH_TYPE, device_id: IOS_DEVICE_ID)

# 조회
p client.tokens(uuid: IOS_UUID)


######## Android

AND_PUSH_TYPE = "gcm"
AND_DEVICE_ID = "안드로이드 디바이스 ID"
AND_PUSH_TOKEN = "푸쉬 토큰"
AND_UUID = 2

# 등록
p client.register(
  uuid: AND_UUID, 
  push_type: AND_PUSH_TYPE,
  device_id: AND_DEVICE_ID,
  push_token: AND_PUSH_TOKEN
)

# 조희
p client.tokens(uuid: AND_UUID)

# 전송
custom_field = {}
apns = KakaoPush::Apns.new(badge: 2, sound: 'default', push_alert: true, message: "kakao_push gem message", custom_field: custom_field, push_token: AND_PUSH_TOKEN)
gcm = KakaoPush::Gcm.new(collapse: nil, delay_while_idle: false, return_url: nil, custom_field: custom_field, push_token: AND_PUSH_TOKEN)
p client.send(uuids: [AND_UUID], apns: apns, gcm: gcm, bypass: false)

# 삭제
p client.deregister(uuid: AND_UUID, push_type: PUSH_TYPE, device_id: DEVICE_ID)

# 조회
p client.tokens(uuid: AND_UUID)

