# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Jain-Contacts' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'Material'
  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'AccountKit'
  pod 'SVProgressHUD'
  pod 'TPKeyboardAvoiding'
  pod “SDWebImage”, ‘~>3.7’
  pod 'InteractiveSideMenu'
end
swift4pods = ['Material']
 
 post_install do |installer|
   installer.pods_project.targets.each do |target|
     if swift4pods.include? target.name
       target.build_configurations.each do |config|
         config.build_settings['SWIFT_VERSION'] = '4.0'
       end
     end
   end
 end



