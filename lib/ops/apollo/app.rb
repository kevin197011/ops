require 'net/http'
require 'uri'
require 'json'

module Ops
  module Apollo
    class << self
      def apps
        url = URI("#{base_url}/apps")
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
          url = URI("#{base_url}/apps")
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

      def app_auth(username, env, app_name, namespace_name)
        actions = %w[ModifyNamespace ReleaseNamespace]
        actions.each do |action|
          url = URI("#{base_url}/apps/#{app_name}/envs/#{env}/namespaces/#{namespace_name}/roles/#{action}")
          http = Net::HTTP.new(url.host, url.port)
          data = username.to_s
          header = {
            'content-type': 'application/json',
            'Cookie': "NG_TRANSLATE_LANG_KEY=en; #{conn}"
          }
          http.post(url, data, header).code
          puts "#{app_name} action #{action} update finished!"
        end
      end

      def app_delete!(app_name)
        url = URI("#{base_url}/apps/#{app_name}")
        http = Net::HTTP.new(url.host, url.port)
        header = {
          'content-type': 'application/json',
          'Cookie': "NG_TRANSLATE_LANG_KEY=en; #{conn}"
        }
        http.delete(url, header).code
      end

      def auth_user?(_username, _env, _app_name, _namespace_name)
        'http://apollo:8070/apps/t4/namespaces/application/role_users'
      end
    end
  end
end
