platform :ios, '7.0'
inhibit_all_warnings!
source 'https://github.com/CocoaPods/Specs.git'

target ‘pairearch_WLY’ do

pod 'AFNetworking'
pod 'SDWebImage'
pod 'MJRefresh'
pod 'IQKeyboardManager'
pod 'TZImagePickerController'
pod 'UMengAnalytics-NO-IDFA'
pod 'FDFullscreenPopGesture'     #全屏手势返回库
pod 'UIImage+ImageCompress'

pod 'DYLocationConverter', '~> 0.0.4'
pod 'MBProgressHUD+BWMExtension', '~> 1.0.1'
pod 'MBProgressHUD', '~> 0.9.2'
pod 'Masonry', '~> 1.0.2'
pod 'SAMKeychain', '~> 1.5.2'
pod 'JPush', '~> 3.0.2'
#pod 'KMNavigationBarTransition'  #自定义pop、push动画库
#pod 'XFDialogBuilder', '~> 1.2.9'  #自定义弹出框
#pod 'XHVersion', '~> 1.0.1'
#pod 'BaiduMobStat', '~> 4.3.0'

end

post_install do |installer|
    copy_pods_resources_path = "Pods/Target Support Files/Pods-pairearch_WLY/Pods-pairearch_WLY-resources.sh"
    string_to_replace = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"'
    assets_compile_with_app_icon_arguments = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}" --app-icon "${ASSETCATALOG_COMPILER_APPICON_NAME}" --output-partial-info-plist "${BUILD_DIR}/assetcatalog_generated_info.plist"'
    text = File.read(copy_pods_resources_path)
    new_contents = text.gsub(string_to_replace, assets_compile_with_app_icon_arguments)
    File.open(copy_pods_resources_path, "w") {|file| file.puts new_contents }
end
