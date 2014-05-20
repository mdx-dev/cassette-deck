# Example rack application that uses cassette-deck middleware to play back
# recorded responses...
#
#$:.push(File.dirname(__FILE__) + '/lib')
#require 'cassette-deck'

#use Rack::Reloader, 0
#use CassetteDeck::Play, 'path/to/cassette'
#use CassetteDeck::Play, 'path/to/another/cassette', match_requests_on: [:path]
#run lambda {|env| [200, {'Content-Type' => 'text/plain'}, ["Hello, World!"]]}
