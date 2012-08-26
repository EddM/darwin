require 'rubygems'
require 'bundler/setup'
require 'releasy'

Releasy::Project.new do
  name "Darwin's Odyssey"
  version "1.0"
  verbose

  executable "run.rb"
  files ["run.rb", "lib/**/*.rb", "res/**/*.*"]
  add_link "http://github.com/EddM/darwin", "Darwin's Odyssey on GitHub"
  exclude_encoding

  add_build :osx_app do
    url "com.eddm.darwin"
    wrapper "etc/wrappers/gosu-mac-wrapper-0.7.44.tar.gz"
    icon "res/icon.icns"
  end
  
  add_build :windows_standalone do
    
  end
end