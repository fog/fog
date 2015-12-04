require 'fog/core'
require 'fog/json'

module Fog
  module OpenStack
    extend Fog::Provider

    module Errors
      class ServiceError < Fog::Errors::Error
        attr_reader :response_data

        def self.slurp(error)
          if error.response.body.empty?
            data = nil
            message = nil
          else
            data = Fog::JSON.decode(error.response.body)
            message = data['message']
            if message.nil? and !data.values.first.nil?
              message = data.values.first['message']
            end
          end

          new_error = super(error, message)
          new_error.instance_variable_set(:@response_data, data)
          new_error
        end
      end

      class ServiceUnavailable < ServiceError; end

      class BadRequest < ServiceError
        attr_reader :validation_errors

        def self.slurp(error)
          new_error = super(error)
          unless new_error.response_data.nil? or new_error.response_data['badRequest'].nil?
            new_error.instance_variable_set(:@validation_errors, new_error.response_data['badRequest']['validationErrors'])
          end
          new_error
        end
      end

      class InterfaceNotImplemented < Fog::Errors::Error; end
    end

    service(:compute ,      'Compute')
    service(:image,         'Image')
    service(:identity,      'Identity')
    service(:network,       'Network')
    service(:storage,       'Storage')
    service(:volume,        'Volume')
    service(:metering,      'Metering')
    service(:orchestration, 'Orchestration')
    service(:baremetal,     'Baremetal')
    service(:planning,      'Planning')

    module Core
      attr_accessor :auth_token
      attr_reader :auth_token_expiration
      attr_reader :current_user
      attr_reader :current_user_id
      attr_reader :current_tenant
      attr_reader :openstack_domain_name
      attr_reader :openstack_user_domain
      attr_reader :openstack_project_domain
      attr_reader :openstack_domain_id
      attr_reader :openstack_user_domain_id
      attr_reader :openstack_project_domain_id
      attr_reader :openstack_identity_prefix

      def initialize_identity options
        # Create @openstack_* instance variables from all :openstack_* options
        options.select{|x|x.to_s.start_with? 'openstack'}.each do |openstack_param, value|
          instance_variable_set "@#{openstack_param}".to_sym, value
        end

        @auth_token        ||= options[:openstack_auth_token]
        @openstack_identity_public_endpoint = options[:openstack_identity_endpoint]

        @openstack_auth_uri    = URI.parse(options[:openstack_auth_url])
        @openstack_must_reauthenticate  = false
        @openstack_endpoint_type = options[:openstack_endpoint_type] || 'publicURL'

        unless @auth_token
          missing_credentials = Array.new

          missing_credentials << :openstack_api_key unless @openstack_api_key
          unless @openstack_username || @openstack_userid
            missing_credentials << 'openstack_username or openstack_userid'
          end
          raise ArgumentError, "Missing required arguments: #{missing_credentials.join(', ')}" unless missing_credentials.empty?
        end

        @current_user = options[:current_user]
        @current_user_id = options[:current_user_id]
        @current_tenant = options[:current_tenant]

      end

      def credentials
        options =  {
          :provider                    => 'openstack',
          :openstack_auth_url          => @openstack_auth_uri.to_s,
          :openstack_auth_token        => @auth_token,
          :openstack_identity_endpoint => @openstack_identity_public_endpoint,
          :current_user                => @current_user,
          :current_user_id             => @current_user_id,
          :current_tenant              => @current_tenant,
          :unscoped_token              => @unscoped_token}
        openstack_options.merge options
      end

      def reload
        @connection.reset
      end

      private

      def openstack_options
        options={}
        # Create a hash of (:openstack_*, value) of all the @openstack_* instance variables
        self.instance_variables.select{|x|x.to_s.start_with? '@openstack'}.each do |openstack_param|
          option_name = openstack_param.to_s[1..-1]
          options[option_name.to_sym] = instance_variable_get openstack_param
        end
        options
      end

      def authenticate
        if !@openstack_management_url || @openstack_must_reauthenticate

          options = openstack_options

          options[:openstack_auth_token] = @openstack_must_reauthenticate ? nil : @openstack_auth_token

          credentials = Fog::OpenStack.authenticate(options, @connection_options)

          @current_user = credentials[:user]
          @current_user_id = credentials[:current_user_id]
          @current_tenant = credentials[:tenant]

          @openstack_must_reauthenticate = false
          @auth_token = credentials[:token]
          @openstack_management_url = credentials[:server_management_url]
          @unscoped_token = credentials[:unscoped_token]
        else
          @auth_token = @openstack_auth_token
        end
        @openstack_management_uri = URI.parse(@openstack_management_url)

        @host   = @openstack_management_uri.host
        @path   = @openstack_management_uri.path
        @path.sub!(/\/$/, '')
        @port   = @openstack_management_uri.port
        @scheme = @openstack_management_uri.scheme

        # Not all implementations have identity service in the catalog
        if @openstack_identity_public_endpoint || @openstack_management_url
          @identity_connection = Fog::Core::Connection.new(
              @openstack_identity_public_endpoint || @openstack_management_url,
              false, @connection_options)
        end

        true
      end
    end

    @@token_cache = {}

    def self.clear_token_cache
      @@token_cache.clear
    end

    def self.authenticate(options, connection_options = {})
      case options[:openstack_auth_uri].path
      when /v1(\.\d+)?/
        authenticate_v1(options, connection_options)
      when /v2(\.\d+)?/
        authenticate_v2(options, connection_options)
      when /v3(\.\d+)?/
        authenticate_v3(options, connection_options)
      else
        authenticate_v2(options, connection_options)
      end
    end

    # legacy v1.0 style auth
    def self.authenticate_v1(options, connection_options = {})
      uri = options[:openstack_auth_uri]
      connection = Fog::Core::Connection.new(uri.to_s, false, connection_options)
      @openstack_api_key  = options[:openstack_api_key]
      @openstack_username = options[:openstack_username]

      response = connection.request({
        :expects  => [200, 204],
        :headers  => {
          'X-Auth-Key'  => @openstack_api_key,
          'X-Auth-User' => @openstack_username
        },
        :method   => 'GET',
        :path     =>  (uri.path and not uri.path.empty?) ? uri.path : 'v1.0'
      })

      return {
        :token => response.headers['X-Auth-Token'],
        :server_management_url => response.headers['X-Server-Management-Url'] || response.headers['X-Storage-Url'],
        :identity_public_endpoint => response.headers['X-Keystone']
      }
    end

    # Keystone Style Auth
    def self.authenticate_v2(options, connection_options = {})
      uri                   = options[:openstack_auth_uri]
      tenant_name           = options[:openstack_tenant]
      service_type          = options[:openstack_service_type]
      service_name          = options[:openstack_service_name]
      identity_service_type = options[:openstack_identity_service_type]
      endpoint_type         = (options[:openstack_endpoint_type] || 'publicURL').to_s
      openstack_region      = options[:openstack_region]

      body = retrieve_tokens_v2(options, connection_options)
      service = get_service(body, service_type, service_name)

      options[:unscoped_token] = body['access']['token']['id']

      unless service
        unless tenant_name
          response = Fog::Core::Connection.new(
            "#{uri.scheme}://#{uri.host}:#{uri.port}/v2.0/tenants", false, connection_options).request({
            :expects => [200, 204],
            :headers => {'Content-Type' => 'application/json',
                         'Accept' => 'application/json',
                         'X-Auth-Token' => body['access']['token']['id']},
            :method  => 'GET'
          })

          body = Fog::JSON.decode(response.body)
          if body['tenants'].empty?
            raise Fog::Errors::NotFound.new('No Tenant Found')
          else
            options[:openstack_tenant] = body['tenants'].first['name']
          end
        end

        body = retrieve_tokens_v2(options, connection_options)
        service = get_service(body, service_type, service_name)

      end

      service['endpoints'] = service['endpoints'].select do |endpoint|
        endpoint['region'] == openstack_region
      end if openstack_region

      if service['endpoints'].empty?
        raise Fog::Errors::NotFound.new("No endpoints available for region '#{openstack_region}'")
      end if openstack_region

      unless service
        available = body['access']['serviceCatalog'].map { |endpoint|
          endpoint['type']
        }.sort.join ', '

        missing = service_type.join ', '

        message = "Could not find service #{missing}.  Have #{available}"

        raise Fog::Errors::NotFound, message
      end

      regions = service["endpoints"].map{ |e| e['region'] }.uniq
      if regions.count > 1
        raise Fog::Errors::NotFound.new("Multiple regions available choose one of these '#{regions.join(',')}'")
      end

      identity_service = get_service(body, identity_service_type) if identity_service_type
      tenant = body['access']['token']['tenant']
      user = body['access']['user']

      management_url = service['endpoints'].find{|s| s[endpoint_type]}[endpoint_type]
      identity_url   = identity_service['endpoints'].find{|s| s['publicURL']}['publicURL'] if identity_service

      {
        :user                     => user,
        :tenant                   => tenant,
        :identity_public_endpoint => identity_url,
        :server_management_url    => management_url,
        :token                    => body['access']['token']['id'],
        :expires                  => body['access']['token']['expires'],
        :current_user_id          => body['access']['user']['id'],
        :unscoped_token           => options[:unscoped_token]
      }
    end

    # Keystone Style Auth
    def self.authenticate_v3(options, connection_options = {})
      uri = options[:openstack_auth_uri]
      project_name          = options[:openstack_project_name]
      service_type          = options[:openstack_service_type]
      service_name          = options[:openstack_service_name]
      identity_service_type = options[:openstack_identity_service_type]
      endpoint_type         = map_endpoint_type(options[:openstack_endpoint_type] || 'publicURL')
      openstack_region      = options[:openstack_region]

      token, body = retrieve_tokens_v3 options, connection_options

      service = get_service_v3(body, service_type, service_name, openstack_region, options)

      options[:unscoped_token] = token

      unless service
        unless project_name
          request_body = {
              :expects => [200],
              :headers => {'Content-Type' => 'application/json',
                           'Accept' => 'application/json',
                           'X-Auth-Token' => token},
              :method => 'GET'
          }
          user_id = body['token']['user']['id']
          response = Fog::Core::Connection.new(
              "#{uri.scheme}://#{uri.host}:#{uri.port}/v3/users/#{user_id}/projects", false, connection_options).request(request_body)

          projects_body = Fog::JSON.decode(response.body)
          if projects_body['projects'].empty?
            options[:openstack_domain_id] = body['token']['user']['domain']['id']
          else
            options[:openstack_project_name] = projects_body['projects'].first['name']
            options[:openstack_domain_id] = projects_body['projects'].first['domain_id']
          end
        end

        token, body = retrieve_tokens_v3(options, connection_options)
        service = get_service_v3(body, service_type, service_name, openstack_region)
      end

      unless service
        available_services = body['token']['catalog'].map { |service|
          service['type']
        }.sort.join ', '

        available_regions = body['token']['catalog'].map { |service|
          service['endpoints'].map { |endpoint|
            endpoint['region']
          }.uniq
        }.uniq.sort.join ', '

        missing = service_type.join ', '

        message = "Could not find service #{missing}#{(' in region '+openstack_region) if openstack_region}."+
            " Have #{available_services}#{(' in regions '+available_regions) if openstack_region}"

        raise Fog::Errors::NotFound, message
      end

      service['endpoints'] = service['endpoints'].select do |endpoint|
        endpoint['region'] == openstack_region && endpoint['interface'] == endpoint_type
      end if openstack_region

      if service['endpoints'].empty?
        raise Fog::Errors::NotFound.new("No endpoints available for region '#{openstack_region}'")
      end if openstack_region

      regions = service["endpoints"].map { |e| e['region'] }.uniq
      if regions.count > 1
        raise Fog::Errors::NotFound.new("Multiple regions available choose one of these '#{regions.join(',')}'")
      end

      identity_service = get_service_v3(body, identity_service_type, nil, nil, :openstack_endpoint_path_matches => /\/v3/) if identity_service_type

      management_url = service['endpoints'].find { |e| e['interface']==endpoint_type }['url']
      identity_url = identity_service['endpoints'].find { |e| e['interface']=='public' }['url'] if identity_service

      if body['token']['project']
        tenant = body['token']['project']['name']
      else
        tenant = body['token']['user']['project']['name'] if body['token']['user']['project']
      end

      return {
          :user                     => body['token']['user']['name'],
          :tenant                   => tenant,
          :identity_public_endpoint => identity_url,
          :server_management_url    => management_url,
          :token                    => token,
          :expires                  => body['token']['expires_at'],
          :current_user_id          => body['token']['user']['id'],
          :unscoped_token           => options[:unscoped_token]
      }
    end

    def self.get_service(body, service_type=[], service_name=nil)
      if not body['access'].nil?
        body['access']['serviceCatalog'].find do |s|
          if service_name.nil? or service_name.empty?
            service_type.include?(s['type'])
          else
            service_type.include?(s['type']) and s['name'] == service_name
          end
        end
      elsif not body['token']['catalog'].nil?
        body['token']['catalog'].find do |s|
          if service_name.nil? or service_name.empty?
            service_type.include?(s['type'])
          else
            service_type.include?(s['type']) and s['name'] == service_name
          end
        end

      end
    end

    def self.retrieve_tokens_v2(options, connection_options = {})
      api_key     = options[:openstack_api_key].to_s
      username    = options[:openstack_username].to_s
      tenant_name = options[:openstack_tenant].to_s
      auth_token  = options[:openstack_auth_token] || options[:unscoped_token]
      uri         = options[:openstack_auth_uri]

      identity_v2_connection = Fog::Core::Connection.new(uri.to_s, false, connection_options)
      request_body = {:auth => Hash.new}

      if auth_token
        request_body[:auth][:token] = {
          :id => auth_token
        }
      else
        request_body[:auth][:passwordCredentials] = {
          :username => username,
          :password => api_key
        }
      end
      request_body[:auth][:tenantName] = tenant_name if tenant_name

      response = identity_v2_connection.request({
        :expects  => [200, 204],
        :headers  => {'Content-Type' => 'application/json'},
        :body     => Fog::JSON.encode(request_body),
        :method   => 'POST',
        :path     => (uri.path and not uri.path.empty?) ? uri.path : 'v2.0'
      })

      Fog::JSON.decode(response.body)
    end

    def self.retrieve_tokens_v3(options, connection_options = {})

      api_key      = options[:openstack_api_key].to_s
      username     = options[:openstack_username].to_s
      userid       = options[:openstack_userid]
      domain_id    = options[:openstack_domain_id]
      domain_name  = options[:openstack_domain_name]
      project_domain = options[:openstack_project_domain]
      project_domain_id = options[:openstack_project_domain_id]
      user_domain  = options[:openstack_user_domain]
      user_domain_id  = options[:openstack_user_domain_id]
      project_name = options[:openstack_project_name]
      project_id   = options[:openstack_project_id]
      auth_token   = options[:openstack_auth_token] || options[:unscoped_token]
      uri          = options[:openstack_auth_uri]

      connection = Fog::Core::Connection.new(uri.to_s, false, connection_options)
      request_body = {:auth => {}}

      scope = {}

      if project_name || project_id
        scope[:project] = if project_id.nil? then
                            if project_domain || project_domain_id
                              {:name => project_name, :domain => project_domain_id.nil? ? {:name => project_domain} : {:id => project_domain_id}}
                            else
                              {:name => project_name, :domain => domain_id.nil? ? {:name => domain_name} : {:id => domain_id}}
                            end
                          else
                            {:id => project_id}
                          end
      elsif domain_name || domain_id
        scope[:domain] = domain_id.nil? ? {:name => domain_name} : {:id => domain_id}
      else
        # unscoped token
      end

      if auth_token
        request_body[:auth][:identity] = {
            :methods => %w{token},
            :token => {
                :id => auth_token
            }
        }
      else
        request_body[:auth][:identity] = {
            :methods => %w{password},
            :password => {
                :user => {
                    :password => api_key
                }
            }
        }

        if userid
          request_body[:auth][:identity][:password][:user][:id] = userid
        else
          if user_domain || user_domain_id
            request_body[:auth][:identity][:password][:user].merge! :domain => user_domain_id.nil? ? {:name => user_domain} : {:id => user_domain_id}
          elsif domain_name || domain_id
            request_body[:auth][:identity][:password][:user].merge! :domain => domain_id.nil? ? {:name => domain_name} : {:id => domain_id}
          end
          request_body[:auth][:identity][:password][:user][:name] = username
        end

      end
      request_body[:auth][:scope] = scope unless scope.empty?

      path     = (uri.path and not uri.path.empty?) ? uri.path : 'v3'

      response, expires = @@token_cache[{body: request_body, path: path}]

      unless response && expires > Time.now
        response = connection.request({   :expects => [201],
                                          :headers => {'Content-Type' => 'application/json'},
                                          :body    => Fog::JSON.encode(request_body),
                                          :method  => 'POST',
                                          :path    => path
                                      })
        @@token_cache[{body: request_body, path: path}] = response, Time.now + 30 # 30-second TTL, enough for most requests
      end

      [response.headers["X-Subject-Token"], Fog::JSON.decode(response.body)]
    end

    def self.get_service_v3(hash, service_type=[], service_name=nil, region=nil, options={})

      # Find all services matching any of the types in service_type, filtered by service_name if it's non-nil
      services = hash['token']['catalog'].find_all do |s|
        if service_name.nil? or service_name.empty?
          service_type.include?(s['type'])
        else
          service_type.include?(s['type']) and s['name'] == service_name
        end
      end if hash['token']['catalog']

      # Filter the found services by region (if specified) and whether the endpoint path matches the given regex (e.g. /\/v3/)
      services.find do |s|
        s['endpoints'].any? { |ep| endpoint_region?(ep, region) && endpoint_path_match?(ep, options[:openstack_endpoint_path_matches])}
      end if services

    end

    def self.endpoint_region?(endpoint, region)
      region.nil? || endpoint['region'] == region
    end

    def self.endpoint_path_match?(endpoint, match_regex)
      match_regex.nil? || URI(endpoint['url']).path =~ match_regex
    end

    def self.get_supported_version(supported_versions, uri, auth_token, connection_options = {})
      connection = Fog::Core::Connection.new("#{uri.scheme}://#{uri.host}:#{uri.port}", false, connection_options)
      response = connection.request({
                                        :expects => [200, 204, 300],
                                        :headers => {'Content-Type' => 'application/json',
                                                     'Accept' => 'application/json',
                                                     'X-Auth-Token' => auth_token},
                                        :method => 'GET'
                                    })

      body = Fog::JSON.decode(response.body)
      version = nil
      unless body['versions'].empty?
        supported_version = body['versions'].find do |x|
          x["id"].match(supported_versions) &&
              (x["status"] == "CURRENT" || x["status"] == "SUPPORTED")
        end
        version = supported_version["id"] if supported_version
      end
      if version.nil?
        raise Fog::OpenStack::Errors::ServiceUnavailable.new(
                  "OpenStack service only supports API versions #{supported_versions.inspect}")
      end

      version
    end

    def self.get_supported_version_path(supported_versions, uri, auth_token, connection_options = {})
      # Find a version in the path (e.g. the v1 in /xyz/v1/tenantid/abc) and get the path up until that version (e.g. /xyz))
      path_components = uri.path.split '/'
      version_component_index = path_components.index{|comp| comp.match(/v[0-9].?[0-9]?/) }
      versionless_path = (path_components.take(version_component_index).join '/' if version_component_index) || ''
      connection = Fog::Core::Connection.new("#{uri.scheme}://#{uri.host}:#{uri.port}#{versionless_path}", false, connection_options)
      response = connection.request({
                                        :expects => [200, 204, 300],
                                        :headers => {'Content-Type' => 'application/json',
                                                     'Accept' => 'application/json',
                                                     'X-Auth-Token' => auth_token},
                                        :method => 'GET'
                                    })

      body = Fog::JSON.decode(response.body)
      path = nil
      unless body['versions'].empty?
        supported_version = body['versions'].find do |x|
          x["id"].match(supported_versions) &&
              (x["status"] == "CURRENT" || x["status"] == "SUPPORTED")
        end
        path = URI.parse(supported_version['links'].first['href']).path if supported_version
      end
      if path.nil?
        raise Fog::OpenStack::Errors::ServiceUnavailable.new(
                  "OpenStack service only supports API versions #{supported_versions.inspect}")
      end

      path.chomp '/'
    end

    # CGI.escape, but without special treatment on spaces
    def self.escape(str, extra_exclude_chars = '')
      str.gsub(/([^a-zA-Z0-9_.-#{extra_exclude_chars}]+)/) do
        '%' + $1.unpack('H2' * $1.bytesize).join('%').upcase
      end
    end

    def self.map_endpoint_type type
      case type
        when "publicURL"
          "public"
        when "internalURL"
          "internal"
        when "adminURL"
          "admin"
      end

    end
  end
end
