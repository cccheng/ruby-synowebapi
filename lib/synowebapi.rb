
module SYNOWebAPI
  ROOT = File.expand_path(File.dirname(__FILE__))

  unless $LOAD_PATH.any? { |lp| File.expand_path(lp) == ROOT }
    $LOAD_PATH.unshift(ROOT)
  end

  require 'synowebapi/version'
  require 'synowebapi/client'
  require 'synowebapi/api'

end
