# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kakao_push/version'

Gem::Specification.new do |spec|
  spec.name          = "kakao_push"
  spec.version       = KakaoPush::VERSION
  spec.licenses      = ['MIT']
  spec.authors       = ["ChangHoon Jung"]
  spec.email         = ["iamseapy@gmail.com"]

  spec.summary       = %q{카카오 플랫폼 API에서 제공하는 푸시알림을 호출하는 젬입니다.}
  spec.description   = %q{카카오 플랫폼 API에서 제공하는 푸시알림을 호출하는 젬입니다. iOS, 안드로이드 사용자에게 푸시를 보낼때 유용한 카카오 푸시알림은 REST API로만 제공되고 있기에 이를 젬으로 만들어 봤습니다.}
  spec.homepage      = "https://github.com/n42corp/kakao_push"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|example)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "multi_json"
  spec.add_dependency "faraday", "~> 0.14"
  spec.add_dependency "faraday_middleware", "~> 0.12"
  
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
end
