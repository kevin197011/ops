module Ops
  module Apollo
    class << self
      def namespaces(app_name)
        uri = URI("#{base_uri}/apps/#{app_name}/envs/DEV/clusters/default/namespaces")
        http = Net::HTTP.new(uri.host, uri.port)
        header = {
          'content-type': 'application/json',
          'Cookie': "NG_TRANSLATE_LANG_KEY=en; #{conn}"
        }
        JSON.parse(http.get(uri, header).read_body).to_a.map { |namespace| namespace['baseInfo']['namespaceName'] }
      end

      def namespace!(app_name, namespace_name)
        uri = URI("#{base_uri}/apps/#{app_name}/appnamespaces?appendNamespacePrefix=false")
        http = Net::HTTP.new(uri.host, uri.port)
        params = JSON.dump({
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
        http.post(uri, params, header).code
        "#{app_name} namespace #{namespace_name} create finished!"
      end

      def empty_value?(app_name, env_name, namespace_name); end
    end
  end
end
