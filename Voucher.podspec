Pod::Spec.new do |s|

  s.name         = "Voucher"
  s.version      = "0.2.0"
  s.summary      = "A simple library to make authenticating tvOS apps easy via their iOS counterparts using Bonjour."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
                    Voucher lets the user login easily on a tvOS app, provided they already
                    have the iOS app. Their iOS app receives a request from the tvOS app, which
                    they can grant, and the iOS app can send useful authentication data back to
                    the tvOS app.

                    Until Apple "fixes" this issue by creating better login options. This is a nice
                    option to include in your tvOS and iOS apps, because it makes login painless!
                   DESC

  s.homepage     = "https://github.com/rsattar/Voucher"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Rizwan Sattar" => "rsattar@gmail.com" }
  s.social_media_url   = "http://twitter.com/rizzledizzle"

  s.platform     = ['ios', 'tvos']
  s.ios.deployment_target = "7.0"
  s.tvos.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/rsattar/Voucher.git", :tag => s.version.to_s }

  s.source_files  = "Voucher", "Voucher/**/*.{h,m}"

end
