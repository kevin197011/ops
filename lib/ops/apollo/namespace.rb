require 'net/http'
require 'uri'
require 'json'

module Ops
  module Apollo
    class << self
      def namespaces(app_name)
        url = URI("#{BASE_URL}/apps/#{app_name}/envs/DEV/clusters/default/namespaces")
        http = Net::HTTP.new(url.host, url.port)
        header = {
          'content-type': 'application/json',
          'Cookie': "NG_TRANSLATE_LANG_KEY=en; #{conn}"
        }
        JSON.parse(http.get(url, header).read_body).to_a.map { |namespace| namespace['baseInfo']['namespaceName'] }
      end

      def namespace!(app_name, namespace_name)
        url = URI("#{BASE_URL}/apps/#{app_name}/appnamespaces?appendNamespacePrefix=false")
        http = Net::HTTP.new(url.host, url.port)
        data = JSON.dump({
                           'appId' => app_name,
                           'name' => namespace_name,
                           'comment' => namespace_name,
                           'isPublic' => false,
                           'format' => 'properties'
                         })
        header = {
          'content-type': 'application/json',
          'Cookie': "NG_TRANSLATE_LANG_KEY=en; #{conn}"
        }
        http.post(url, data, header).code
        "#{app_name} namespace #{namespace_name} create finished!"
      end
    end
  end
end
