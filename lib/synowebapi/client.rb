
require 'faraday'
require 'faraday_middleware'
require 'synowebapi/api'

module SYNOWebAPI
  class Client
    attr_reader :url, :api, :session_id, :session_name

    def initialize(url)
      @url = url
      @session_id = @session_name = ''
      @conn = Faraday.new(:url => @url) do |f|
        f.request(:url_encoded)
        f.response(:json)
        f.adapter(Faraday.default_adapter)
      end
    end

    def connect(params)
      @session_name = params[:session_name] || @session_name
      resp = self['SYNO.API.Auth'].login(
        :account => params[:username],
        :passwd => params[:password],
        :session => @session_name,
        :format => 'sid',
      )
      @session_id = resp['sid']
    end

    def disconnect
      self['SYNO.API.Auth'].logout(:session => @session_id)
    end

    def download(api, output_path, params = {}, options = {})
      require 'httpclient'
      http_client = HTTPClient.new
      if options[:receive_timeout]
        http_client.receive_timeout = options[:receive_timeout]
      end
      open(output_path, 'wb') do |file|
        http_client.get_content(
          URI.parse(URI.encode("#{@url}/webapi/#{api.path}")),
          {
            :api => api.api_name,
            :version => api.max_version,
            :_sid => @session_id,
          }.merge(params)
        ) do |chunk|
          file.write chunk
        end
      end
    end

    def post(api, params = {})
      @conn.post("/webapi/#{api.path}", {
        :api => api.api_name,
        :version => api.max_version,
        :_sid => @session_id,
      }.merge(params)).body

    rescue Faraday::ParsingError
      raise StandardError.new("Failed to parse response")
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
      @api[api_name] || (raise ArgumentError.new("WebAPI '#{api_name}' isn't found"))
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

    rescue Faraday::ParsingError
      raise StandardError.new("Failed to parse query response")
    end

  end
end
