
platform :ios, '9.0'
use_frameworks!


target 'CigarettesAndMoneyCounter' do
   # pod 'ENSwiftSideMenu'
   # pod 'Charts'
    use_frameworks!
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'Firebase/Core'
    pod 'Firebase/AdMob'
end



post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
