# Uncomment the next line to define a global platform for your project
platform :ios, '14.3'

target 'Mood' do
  use_frameworks!

  pod 'Firebase/Analytics'
  pod 'Firebase/Firestore'
  pod 'FirebaseFirestoreSwift', '7.3.0-beta'
end

target 'MoodWidgetExtension' do
  use_frameworks!

  pod 'Firebase/Analytics'
  pod 'Firebase/Firestore'
  pod 'FirebaseFirestoreSwift', '7.3.0-beta'
end

post_install do |pi|
  pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.3'
      end
  end
end
