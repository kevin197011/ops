require 'net/http'
require 'uri'
require 'json'

module Ops
  module Apollo
    class << self
      def apps
        url = URI("#{BASE_URL}/apps")
        http = Net::HTTP.new(url.host, url.port)
        header = { 'Cookie': "NG_TRANSLATE_LANG_KEY=en; #{conn}" }
        JSON.parse(http.get(url, header).read_body).to_a.map { |item| item['appId'] }
      end

      def app?(app_name)
        apps.include?(app_name)
      end

      def app!(app_name)
        if app?(app_name)
          "#{app_name} already exist!"
        else
          url = URI("#{BASE_URL}/apps")
          http = Net::HTTP.new(url.host, url.port)
          data = JSON.dump({
                             'appId' => app_name,
                             'name' => app_name,
                             'orgId' => 'TEST1',
                             'orgName' => '样例部门1',
                             'ownerName' => 'apollo',
                             'admins' => []
                           })
          header = {
            'content-type': 'application/json',
            'Cookie': "NG_TRANSLATE_LANG_KEY=en; #{conn}"
          }
          http.post(url, data, header).read_body
        end
      end

      def app_auth(username, env, _app_name, _namespace_name)
        p username, env
      end
    end
  end
end
