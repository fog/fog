require File.expand_path(File.join(File.dirname(__FILE__), '..', 'vcloud'))
require 'fog/compute'

module Fog
  module Vcloud
    class Collection < Fog::Collection

      def load(objects)
        objects = [ objects ] if objects.is_a?(Hash)
        super
      end

      def check_href!(opts = {})
        self.href = connection.default_vdc_href unless href
        unless href
          if opts.is_a?(String)
            t = Hash.new
            t[:parent] = opts
            opts = t
          end
          msg = ":href missing, call with a :href pointing to #{if opts[:message]
                  opts[:message]
                elsif opts[:parent]
                  "the #{opts[:parent]} whos #{self.class.to_s.split('::').last.downcase} you want to enumerate"
                else
                  "the resource"
                end}"
          raise Fog::Errors::Error.new(msg)
        end
      end

    end
  end
end

module Fog
  module Vcloud
    class Model < Fog::Model

      attr_accessor :loaded
      alias_method :loaded?, :loaded

      def reload
        instance = super
        @loaded = true
        instance
      end

      def load_unless_loaded!
        unless @loaded
          reload
        end
      end

    end
  end
end

module Fog
  module Vcloud
    class Compute < Fog::Service

      PATH   = '/api/v1.0'
      PORT   = 443
      SCHEME = 'https'

      requires   :vcloud_username, :vcloud_password, :vcloud_host
      recognizes :vcloud_port, :vcloud_scheme, :vcloud_path, :vcloud_default_vdc
      recognizes :provider # remove post deprecation

      model_path 'fog/vcloud/models/compute'
      model :catalog
      collection :catalogs
      model :catalog_item
      model :catalog_items
      model :ip
      collection :ips
      model :network
      collection :networks
      model :server
      collection :servers
      model :task
      collection :tasks
      model :vdc
      collection :vdcs

      request_path 'fog/vcloud/requests/compute'
      request :clone_vapp
      request :configure_network
      request :configure_network_ip
      request :configure_vapp
      request :configure_vm_memory
      request :configure_vm_name_description
      request :configure_vm_disks
      request :delete_vapp
      request :get_catalog
      request :get_catalog_item
      request :get_customization_options
      request :get_network
      request :get_network_ip
      request :get_network_ips
      request :get_network_extensions
      request :get_organization
      request :get_task
      request :get_task_list
      request :get_vapp
      request :get_vapp_template
      request :get_vm_disks
      request :get_vm_memory
      request :get_vdc
      request :instantiate_vapp_template
      request :login
      request :power_off
      request :power_on
      request :power_reset
      request :power_shutdown
      request :undeploy

      class Mock

        def initialize(options={})
          Fog::Mock.not_implemented
        end

      end

      class Real

        class << self

          def basic_request(*args)
            self.class_eval <<-EOS, __FILE__,__LINE__
              def #{args[0]}(uri)
                request({
                  :expects => #{args[1] || 200},
                  :method  => '#{args[2] || 'GET'}',
                  :headers => #{args[3] ? args[3].inspect : '{}'},
                  :body => '#{args[4] ? args[4] : ''}',
                  :parse => true,
                  :uri     => uri })
              end
            EOS
          end

          def unauthenticated_basic_request(*args)
            self.class_eval <<-EOS, __FILE__,__LINE__
              def #{args[0]}(uri)
                unauthenticated_request({
                  :expects => #{args[1] || 200},
                  :method  => '#{args[2] || 'GET'}',
                  :headers => #{args[3] ? args[3].inspect : '{}'},
                  :parse => true,
                  :uri     => uri })
              end
            EOS
          end

        end

        def initialize(options = {})
          require 'builder'
          require 'fog/core/parser'

          @connections = {}
          @connection_options = options[:connection_options] || {}
          @persistent = options[:persistent]

          @username = options[:vcloud_username]
          @password = options[:vcloud_password]
          @host     = options[:vcloud_host]
          @vdc_href     = options[:vcloud_default_vdc]
          @path     = options[:vcloud_path]   || Fog::Vcloud::Compute::PATH
          @port     = options[:vcloud_port]   || Fog::Vcloud::Compute::PORT
          @scheme   = options[:vcloud_scheme] || Fog::Vcloud::Compute::SCHEME
        end

        def reload
          @connections.each_value { |k,v| v.reset if v }
        end

        def default_organization_uri
          @default_organization_uri ||= begin
            unless @login_results
              do_login
            end
            case @login_results.body[:Org]
            when Array
              @login_results.body[:Org].first[:href]
            when Hash
              @login_results.body[:Org][:href]
            else
              nil
            end
          end
        end

        def default_vdc_href
          @vdc_href
        end

        # login handles the auth, but we just need the Set-Cookie
        # header from that call.
        def do_login
          @login_results = login
          @cookie = @login_results.headers['Set-Cookie']
        end

        def ensure_unparsed(uri)
          if uri.is_a?(String)
            uri
          else
            uri.to_s
          end
        end

        def xmlns
          { "xmlns" => "http://www.vmware.com/vcloud/v1",
            "xmlns:ovf" => "http://schemas.dmtf.org/ovf/envelope/1",
            "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
            "xmlns:xsd" => "http://www.w3.org/2001/XMLSchema" }
        end

        # If the cookie isn't set, do a get_organizations call to set it
        # and try the request.
        # If we get an Unauthorized error, we assume the token expired, re-auth and try again
        def request(params)
          unless @cookie
            do_login
          end
          begin
            do_request(params)
          rescue Excon::Errors::Unauthorized => e
            do_login
            do_request(params)
          end
        end

        private

        def ensure_parsed(uri)
          if uri.is_a?(String)
            URI.parse(uri)
          else
            uri
          end
        end

        # Don't need to  set the cookie for these or retry them if the cookie timed out
        def unauthenticated_request(params)
          do_request(params)
        end

        def base_url
          "#{@scheme}://#{@host}:#{@port}#{@path}"
        end

        # Use this to set the Authorization header for login
        def authorization_header
          "Basic #{Base64.encode64("#{@username}:#{@password}").chomp!}"
        end

        # Actually do the request
        def do_request(params)
          # Convert the uri to a URI if it's a string.
          if params[:uri].is_a?(String)
            params[:uri] = URI.parse(params[:uri])
          end
          host_url = "#{params[:uri].scheme}://#{params[:uri].host}#{params[:uri].port ? ":#{params[:uri].port}" : ''}"

          # Hash connections on the host_url ... There's nothing to say we won't get URI's that go to
          # different hosts.
          @connections[host_url] ||= Fog::Connection.new(host_url, @persistent, @connection_options)

          # Set headers to an empty hash if none are set.
          headers = params[:headers] || {}

          # Add our auth cookie to the headers
          if @cookie
            headers.merge!('Cookie' => @cookie)
          end

          # Make the request
          response = @connections[host_url].request({
            :body     => params[:body] || '',
            :expects  => params[:expects] || 200,
            :headers  => headers,
            :method   => params[:method] || 'GET',
            :path     => params[:uri].path
          })

          # Parse the response body into a hash
          #puts response.body
          unless response.body.empty?
            if params[:parse]
              document = Fog::ToHashDocument.new
              parser = Nokogiri::XML::SAX::PushParser.new(document)
              parser << response.body
              parser.finish

              response.body = document.body
            end
          end

          response
        end

      end

    end
  end
end
