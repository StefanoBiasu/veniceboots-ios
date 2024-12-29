
platform :ios, '12.0'

use_frameworks!

def default
  pod 'SwiftSoup'
  pod 'Alamofire'
  pod 'SQLite.swift', '~> 0.11.5'
  pod 'SideMenu'
  pod 'CocoaLumberjack/Swift'
  pod 'Charts', :tag => 'v3.2.2', :git => 'https://github.com/alekzuz/Charts.git', :branch => 'bar-gradient'
  pod 'TinyConstraints'
  # add the Firebase pod for Google Analytics
  pod 'Firebase/Analytics'
  # add pods for any other desired Firebase products
  # https://firebase.google.com/docs/ios/setup#available-pods
  pod 'Firebase/Crashlytics'
  # Recommended: Add the Firebase pod for Google Analytics
  #pod 'Firebase/Analytics'
end

target 'VeniceBoots' do
  default
end

target 'VeniceBootsDev' do
  default
end

target 'VeniceBootsTest' do
  default
end
