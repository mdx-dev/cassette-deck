require 'spec_helper'
require 'cassette-deck'
require 'json'
require 'rack/mock'

describe CassetteDeck::Play do

  let(:stack) {
    Rack::Builder.new do
      use CassetteDeck::Play, 'spec/cassettes/cassette_1'

      run ->(env) { [200, {}, ['Default Response']] }
    end
  }
  let(:request) { Rack::MockRequest.new(stack) }

  subject { request.get(path) }

  describe 'single cassette' do

    context 'when the path + query string matches a cassette recording' do

      let(:path) { '/test.json?n=1' }

      it 'should play the recorded cassette' do
        expect(JSON.parse(subject.body)).to have_key('success')
      end

      it 'should have a status code' do
        expect(subject.status).to eq(200)
      end

      it 'should have response headers' do
        expect(subject.headers).to include('Content-Length')
      end

    end

    context 'when the path + query string matches a cassette recording' do

      let(:path) { '/test.json?n=1&version=2' }

      it 'should play the recorded cassette' do
        expect(subject.status).to eq(200)
        expect(JSON.parse(subject.body)['version']).to eq(2)
      end

    end

    context 'when the path matches a cassette recording but query string does not' do

      let(:path) { '/test.json?n=3' }

      it 'should play the recorded cassette' do
        expect(subject.status).to eq(200)
        expect(subject.body).to eq('Default Response')
      end

    end

    context 'when the path does not match a cassette recording' do

      let(:path) { '/unknown.json' }

      it 'falls through to the app to handle' do
        expect(subject.status).to eq(200)
        expect(subject.body).to eq('Default Response')
      end

    end

  end

  describe 'multiple cassettes' do

    let(:stack) {
      Rack::Builder.new do
        use CassetteDeck::Play,
          'spec/cassettes/cassette_1'

        use CassetteDeck::Play,
          'spec/cassettes/cassette_2',
          match_requests_on: [:path]

        run ->(env) { [200, {}, ['Default Response']] }
      end
    }

    context 'when the path + query string matches the first (outer) cassette recording' do

      let(:path) { '/test.json?n=1' }

      it 'should play the recorded cassette' do
        expect(subject.status).to eq(200)
        expect(JSON.parse(subject.body)['version']).to eq(1)
      end

    end

    context 'when the path + query string doesnt match the first (outer) cassette recording' do

      let(:path) { '/test.json?x=27' }

      it 'should play the next matching (inner) recorded cassette' do
        expect(subject.status).to eq(200)
        expect(JSON.parse(subject.body)['another']).to eq(true)
      end

    end

    context 'when no cassettes match' do

      let(:path) { '/unknown.json' }

      it 'falls through to the app to handle' do
        expect(subject.status).to eq(200)
        expect(subject.body).to eq('Default Response')
      end

    end
  end

end
