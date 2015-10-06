
require 'synowebapi/error'

module SYNOWebAPI
  class API
    include SYNOWebAPI::ErrorHandler
    attr_reader :api_name, :path, :min_version, :max_version, :request_format, :methods

    def initialize(api_name, client, params)
      @api_name = api_name
      @client = client
      @path = params['path']
      @min_version = params['minVersion']
      @max_version = params['maxVersion']
      @request_format = params['requestFormat']
    end

    def request(params)
      resp = @client.send(self, params)

      if resp['success']
        resp['data']
      else
        error_handling(resp['error'])
      end
    end

    def method_missing(method_name, **args, &block)
      request({:method => method_name}.merge(args))
    end
  end
end
