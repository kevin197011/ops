module Ops
  module Apollo
    class << self
      attr_accessor :conn

      def login(username, password)
        uri = URI("#{base_uri}/signin")
        http = Net::HTTP.new(uri.host, uri.port)
        params = URI.encode_www_form({
                                       'login-submit' => 'Login',
                                       'password' => password.to_s,
                                       'username' => username.to_s
                                     })
        header = { 'content-type': 'application/x-www-form-urlencoded' }
        self.conn = http.post(uri, params, header).response['set-cookie'].split(';')[0]
      end

      def logout
        uri = URI("#{base_uri}/user/logout")
        http = Net::HTTP.new(uri.host, uri.port)
        header = { 'Cookie': "NG_TRANSLATE_LANG_KEY=en; #{conn}" }
        http.get(uri, header)
        'logout finished!'
      end
    end
  end
end
