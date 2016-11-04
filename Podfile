
platform :ios, '9.0'
use_frameworks!
target 'AlmatAirLog' do
    use_frameworks!
    
#platform :ios, '7.0'
pod 'iOS-GPX-Framework', "~> 0.0.2"
pod 'Alamofire', '~> 3.3'
pod 'SWXMLHash', '~> 2.4'
pod 'Firebase'
pod 'Firebase/Database'
pod 'Firebase/Auth'
pod 'Firebase/Core'
pod 'Firebase/Messaging'
pod 'Bolts'
pod 'NoOptionalInterpolation'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '2.3'
        end
    end
end
