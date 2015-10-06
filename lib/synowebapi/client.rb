
require 'faraday'
require 'faraday_middleware'
require 'synowebapi/api'

module SYNOWebAPI
  class Client
    attr_reader :url, :api, :session_id

    def initialize(url, params = nil)
      @url = url
      @conn = Faraday.new(:url => @url) do |f|
        f.adapter(Faraday.default_adapter)
        f.use(FaradayMiddleware::ParseJson)
      end
      connect(params) if params
    end

    def connect(params)
      resp = self['SYNO.API.Auth'].request(
        :method => 'login',
        :account => params[:username],
        :passwd => params[:password],
        :session => params[:session_id],
        :format => 'sid',
      )

      @session_id = resp['sid']
    end

    def disconnect
      self['SYNO.API.Auth'].request(:method => 'logout', :session => @session_id)
    end

    def send(api, params = {})
      @conn.get("/webapi/#{api.path}", {
        :api => api.api_name,
        :version => api.max_version,
        :_sid => @session_id,
      }.merge(params)).body

    rescue Faraday::ParsingError
      raise StandardError.new("Failed to parse response")
    end

    def [](api_name)
      @api ||= query_api
      @api[api_name] ? @api[api_name] : (raise ArgumentError.new("#{api_name} isn't found"))
    end

    private
    def query_api
      resp = @conn.get('webapi/query.cgi', {
        :api => 'SYNO.API.Info',
        :version => 1,
        :method => 'Query',
      }).body

      {}.tap do |api|
        resp['data'].each do |api_name, params|
          api[api_name] = API.new(api_name, self, params)
        end
      end
    end

  end
end

