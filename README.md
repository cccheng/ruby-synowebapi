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

client.disconnect
```

## Requirements

* faraday
* faraday-middleware

## License

http://cccheng.mit-license.org/

Copyright © 2015 Chung-Chiang Cheng <shepjeng@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

