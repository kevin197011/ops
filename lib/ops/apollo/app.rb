module Ops
  module Apollo
    class << self
      def apps
        uri = URI("#{base_uri}/apps")
        http = Net::HTTP.new(uri.host, uri.port)
        header = { 'Cookie': "NG_TRANSLATE_LANG_KEY=en; #{conn}" }
        JSON.parse(http.get(uri, header).read_body).to_a.map { |item| item['appId'] }
      end

      def app?(app_name)
        apps.include?(app_name)
      end

      def app!(app_name)
        if app?(app_name)
          "#{app_name} already exist!"
        else
          uri = URI("#{base_uri}/apps")
          http = Net::HTTP.new(uri.host, uri.port)
          params = JSON.dump({
                               appId: app_name,
                               name: app_name,
                               orgId: 'TEST1',
                               orgName: '样例部门1',
                               ownerName: 'apollo',
                               admins: []
                             })
          header = {
            'content-type': 'application/json',
            'Cookie': "NG_TRANSLATE_LANG_KEY=en; #{conn}"
          }
          http.post(uri, params, header).read_body
        end
      end

      def app_grant(username, env_name, app_name, namespace_name)
        actions = %w[ModifyNamespace ReleaseNamespace]
        actions.each do |action|
          uri = URI("#{base_uri}/apps/#{app_name}/envs/#{env_name}/namespaces/#{namespace_name}/roles/#{action}")
          http = Net::HTTP.new(uri.host, uri.port)
          params = username.to_s
          header = {
            'content-type': 'application/json',
            'Cookie': "NG_TRANSLATE_LANG_KEY=en; #{conn}"
          }
          http.post(uri, params, header)
          puts "#{app_name} action #{action} update finished!"
        end
      end

      def app_revoke!(app_name, namespace_name, env_name, username)
        if app_namespace_env_users?(app_name, namespace_name, env_name, username)
          actions = %w[ModifyNamespace ReleaseNamespace]
          actions.each do |action|
            uri = URI("#{base_uri}/apps/#{app_name}/envs/#{env_name}/namespaces/#{namespace_name}/roles/#{action}?user=#{username}")
            http = Net::HTTP.new(uri.host, uri.port)
            header = {
              'content-type': 'application/json',
              'Cookie': "NG_TRANSLATE_LANG_KEY=en; #{conn}"
            }
            http.delete(uri, header)
            puts "app_revoke user: #{username} in app: #{app_name}  namesapce: #{namespace_name} env: #{env_name}"
          end
        else
          "can't find user: #{username} in app: #{app_name}  namesapce: #{namespace_name} env: #{env_name}"
        end
      end

      def app_delete!(app_name)
        uri = URI("#{base_uri}/apps/#{app_name}")
        http = Net::HTTP.new(uri.host, uri.port)
        header = {
          'content-type': 'application/json',
          'Cookie': "NG_TRANSLATE_LANG_KEY=en; #{conn}"
        }
        http.delete(uri, header)
      end

      def app_user?(app_name, namespace_name, env_name, username)
        if app_master_user?(app_name, username)
          puts "#{username} in #{app_name} is master!"
          true
        elsif app_namespace_all_env_user?(app_name, namespace_name, username)
          puts "#{username} in #{app_name} all env is manager!"
          true
        elsif app_namespace_env_user?(app_name, namespace_name, env_name, username)
          puts "#{username} in #{app_name} #{env_name} env is ok!"
          true
        else
          false
        end
      end

      def app_master_user?(app_name, username)
        uri = URI("#{base_uri}/apps/#{app_name}/role_users")
        http = Net::HTTP.new(uri.host, uri.port)
        header = { 'Cookie': "NG_TRANSLATE_LANG_KEY=en; #{conn}" }
        masters = JSON.parse(http.get(uri, header).read_body).to_hash['masterUsers'].map { |item| item['userId'] }
        if masters.include?(username)
          true
        else
          false
        end
      end

      def app_namespace_all_env_user?(app_name, namespace_name, username)
        uri = URI("#{base_uri}/apps/#{app_name}/namespaces/#{namespace_name}/role_users")
        http = Net::HTTP.new(uri.host, uri.port)
        header = { 'Cookie': "NG_TRANSLATE_LANG_KEY=en; #{conn}" }
        users = JSON.parse(http.get(uri, header).read_body).to_hash
        user_modify_status = (users['modifyRoleUsers'].map { |user| user['userId'] }).include?(username)
        user_release_status = (users['releaseRoleUsers'].map { |user| user['userId'] }).include?(username)
        if user_modify_status && user_release_status
          true
        else
          puts "user #{username} in all env modify status: [#{user_modify_status}], release status: [#{user_release_status}]!"
          false
        end
      end

      def app_namespace_env_user?(app_name, namespace_name, env_name, username)
        uri = URI("#{base_uri}/apps/#{app_name}/envs/#{env_name}/namespaces/#{namespace_name}/role_users")
        http = Net::HTTP.new(uri.host, uri.port)
        header = { 'Cookie': "NG_TRANSLATE_LANG_KEY=en; #{conn}" }
        users = JSON.parse(http.get(uri, header).read_body).to_hash
        user_modify_status = (users['modifyRoleUsers'].map { |user| user['userId'] }).include?(username)
        user_release_status = (users['releaseRoleUsers'].map { |user| user['userId'] }).include?(username)
        if user_modify_status && user_release_status
          true
        else
          puts "user #{username} in #{env_name} env modify status: [#{user_modify_status}], release status: [#{user_release_status}]!"
          false
        end
      end
    end
  end
end
