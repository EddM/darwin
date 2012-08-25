require 'rubygems'
require 'gosu'

Dir["**/*.rb"].each { |file| require "./#{file}" }

GameWindow.new.show