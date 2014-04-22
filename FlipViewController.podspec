Pod::Spec.new do |s|
  s.name         = 'FlipViewController'
  s.version      = '1.0.0'
  s.license	 = 'MIT'
  s.requires_arc = true
  s.platform     = :ios, '6.0'
  s.homepage     = 'https://github.com/elchief84/FlipViewController'
  s.summary      = 'An UIViewController extension with Flip Animation'
  s.authors 	 = {'Vincenzo Romano' => 'enzxx84@gmail.com'}
  s.source 	 = {
    :git => 'https://github.com/elchief84/FlipViewController.git',
    :tag => '1.0.0'
  }
  s.source_files = 'Classes/*.{h,m}'
end
