# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

Dir.glob('lib/ops/**/*.rb') do |r|
  require r.delete_prefix('lib/')
end

module Ops
  class Error < StandardError; end
  # Your code goes here...
end
