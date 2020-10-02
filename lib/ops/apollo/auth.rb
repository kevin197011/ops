require 'net/http'
require 'uri'

module Ops
  module Apollo
    class << self
      attr_accessor :conn

      def login(username, password)
        url = URI("#{base_url}/signin")
        http = Net::HTTP.new(url.host, url.port)
        data = URI.encode_www_form({
                                     'login-submit' => 'Login',
                                     'password' => password.to_s,
                                     'username' => username.to_s
                                   })
        header = { 'content-type': 'application/x-www-form-urlencoded' }
        self.conn = http.post(url, data, header).response['set-cookie'].split(';')[0]
      end

      def logout
        url = URI("#{base_url}/user/logout")
        http = Net::HTTP.new(url.host, url.port)
        header = { 'Cookie': "NG_TRANSLATE_LANG_KEY=en; #{conn}" }
        http.get(url, header).code
      end
    end
  end
end
