Pod::Spec.new do |s|
  s.name         = "FWTPopover"
  s.version      = "1.3.0"
  s.summary      = "FWTPopoverView is a pretty flexible custom view for when you need a classic popover with a pointing arrow."
  s.homepage     = "https://github.com/FutureWorkshops/FWTPopover"
  s.license      = { :type => 'Apache License Version 2.0', :file => 'LICENSE' }
  s.author       = { 'Marco Meschini' => 'marco@futureworkshops.com' }
  s.source       = { :git => "https://github.com/FutureWorkshops/FWTPopover.git", :tag => "1.3.0" }
  s.platform     = :ios
  s.source_files = 'FWTPopoverView/FWTPopoverView'
  s.framework    = 'QuartzCore'
end
