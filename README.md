# SYNOWebAPI

Ruby gem for [Synology](http://www.synology.com//) Web API

## Installation

```sh
$ gem install synowebapi
```

## Synopsis

```ruby
require 'synowebapi'

client = SYNOWebAPI::Client.new('http://192.168.10.10:5000')
client.connect(username: 'admin', password: 'password')

# Enable telnet service
# Check `cat /usr/syno/synoman/webapi/SYNO.Core.Terminal.lib | jq` for partial API info
client['SYNO.Core.Terminal'].request(method: 'set', enable_telnet: true)
# Yet another way to send the identical request above
client['SYNO.Core.Terminal'].set(enable_ssh: true)

# Show disks information.
# Check `cat /usr/syno/synoman/webapi/SYNO.Storage.CGI.lib | jq` for partial API info
resp = client['SYNO.Storage.CGI.Storage'].load_info
resp['disks'].each do |disk|
        puts "%-8s %-10s %-25s %-20s" % [disk['name'], disk['vendor'], disk['model'], disk['serial']]
end

# Download file from shared folder 'public'
# https://global.download.synology.com/download/Document/DeveloperGuide/Synology_File_Station_API_Guide.pdf
client['SYNO.FileStation.Download'].download('/any/test.jpg', {method: 'download', version: 2, path: '/public/file', mode: 'open'})

client.disconnect
```

## Requirements

* httpclient
* faraday
* faraday-middleware

