Pod::Spec.new do |s|
  s.name         = "WXNetwork"                #名称
  s.version      = "0.0.1"                  #版本号
  s.summary      = "ios网络库"               #简短介绍
  s.description  = <<-DESC 
                      ios网络和缓存管理
                   DESC
  s.homepage     = "https://github.com/xiexingyu"
  s.license      = "MIT"                    #开源协议
  s.author             = { "xiexingyu" => "281266447@qq.com" }
  s.source       = { :git => "https://github.com/xiexingyu/WXNetwork.git", :tag => s.version }
  s.platform     = :ios, "8.0"              #支持的平台及版本
  s.requires_arc = true                     #是否使用ARC
  s.frameworks   = 'UIKit', 'Foundation'    #所需的framework,多个用逗号隔开
  s.dependency 'AFNetworking', '~> 3.0.4'
  s.dependency 'YYKit'
  s.dependency 'WXBaseKit'
  # s.dependency 'Realm', '~> 3.13.1'
end