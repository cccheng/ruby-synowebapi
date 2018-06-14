
require File.expand_path('../lib/synowebapi/version', __FILE__)

Gem::Specification.new do |s|
  s.name            = 'synowebapi'
  s.version         = SYNOWebAPI::VERSION
  s.date            = Time.now.strftime('%Y-%m-%d')
  s.authors         = ['Chung-Chiang Cheng']
  s.email           = ['shepjeng@gmail.com', 'cccheng@synology.com']
  s.summary         = 'Ruby gem for Synology Web API'
  s.description     = s.summary
  s.homepage        = 'https://github.com/Synology/ruby-synowebapi'
  s.license         = 'MIT'

  s.files           = %x[git ls-files].split($/).sort
  s.require_paths   = ['lib']

  s.add_dependency 'httpclient', '-> 0'
  s.add_dependency 'faraday', '~> 0'
  s.add_dependency 'faraday_middleware', '~> 0'
end
