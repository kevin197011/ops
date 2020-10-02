#!/usr/bin/env ruby

require 'bundler/setup'
require 'ops'

cli = Ops::Apollo

cli.base_uri = 'http://apollo:8070'
puts cli.base_uri

cli.login('apollo', 'admin')

puts cli.conn
# p cli.apps
# puts cli.app? "test1"
# puts cli.app? "SampleApp"
# puts cli.app_auth("admin", "123456")

# puts cli.app!('t4')
# puts cli.app_grant('apollo', 'DEV', 't4', 'application')
# puts cli.namespace!('t4', 'app1')
# p cli.namespaces('t4')

p cli.app_master_users?('t4', 'apollo')
p cli.app_user?('t4', 'application', 'DEV', 'apollo')
cli.app_revoke!('t4', 'application', 'DEV', 'apollo')

# logout
cli.logout
