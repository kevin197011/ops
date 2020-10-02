#!/usr/bin/env ruby

require 'bundler/setup'
require 'ops'

cli = Ops::Apollo

cli.base_url = 'http://localhost:8070'
puts cli.base_url

cli.login('apollo', 'admin')

# puts cli.conn
# p cli.apps
# puts cli.app? "test1"
# puts cli.app? "SampleApp"
# puts cli.app_auth("admin", "123456")

puts cli.app!('t4')
puts cli.app_auth('apollo', 'DEV', 't4', 'application')
puts cli.namespace!('t4', 'app1')
p cli.namespaces('t4')

# logout
cli.logout
