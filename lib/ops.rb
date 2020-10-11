# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

# require 'ops/version'
# require 'ops/apollo/base'
# require 'ops/apollo/auth'
# require 'ops/apollo/app'
# require 'ops/apollo/namespace'

Dir.glob('lib/ops/**/*.rb') do |r|
  require r.delete_prefix('lib/')
end

module Ops
  class Error < StandardError; end
  # Your code goes here...
end
