require 'net/http'
require 'uri'

module Ops
  module Apollo
    class << self
      def apps
        url = URI("#{BASE_URL}/apps")
        http = Net::HTTP.new(url.host, url.port)
        header = { 'Cookie': "NG_TRANSLATE_LANG_KEY=en; #{conn}" }
        http.get(url, header).read_body
      end

      def app_is_exist?(app_name)
      end

    end
  end
end
