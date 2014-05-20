require 'rack'
require 'vcr'
require 'pathname'

module CassetteDeck

  class Play

    def initialize(app, cassette, options={})
      @app = app
      @lib, @cassette = extract_path(cassette)
      @options = default_options.merge(options)
    end

    def call(env)
      VCR.configure do |c|
        c.cassette_library_dir = @lib
      end

      VCR.use_cassette(
        @cassette,
        @options
      ) do

        request = Rack::Request.new(env)
        vcr_request = VCR::Request.new.tap do |r|
          r.method = request.request_method
          r.uri = request.url
        end

        recordings = VCR.current_cassette.http_interactions

        if recordings.has_interaction_matching?(vcr_request)
          response = recordings.response_for(vcr_request)

          [response.status.code, {}, [response.body]]
        else
          @app.call(env)
        end
      end

    end

    protected

    def default_options
      {
        match_requests_on: [:path, :query],
        allow_playback_repeats: true
      }
    end

    def extract_path(cassette)
      path = Pathname.new(cassette)
      return path.dirname, path.basename.to_s
    end

  end

end
