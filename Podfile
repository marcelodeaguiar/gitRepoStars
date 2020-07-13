source 'https://cdn.cocoapods.org/'
platform :ios, '13.0'

target 'gitRepoStars' do
  use_frameworks!
  inherit! :search_paths

  abstract_target 'Tests' do
    target 'gitRepoStarsTests' do
      pod 'Quick'
      pod 'Nimble'
    end

    target 'gitRepoStarsUITests' do
      # Pods for testing
    end
  end
end
