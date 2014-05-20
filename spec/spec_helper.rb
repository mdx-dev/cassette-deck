$:.push(File.dirname(__FILE__) + '/lib')
require 'rspec'
require 'pry'

RSpec.configure do |config|
  config.order = 'random'
  config.color = true
end
