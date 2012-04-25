module Fog
  module Compute
    class Ecloudv2 < Fog::Service

      API_URL = "https://services.enterprisecloud.terremark.com"
      attr_reader :authentication_method, :version

      #### Credentials
      #requires
      recognizes :ecloudv2_password, :ecloudv2_username, :ecloudv2_version, :ecloudv2_api_key, :ecloudv2_versions_uri, :ecloudv2_host, :ecloudv2_versions_uri, :ecloudv2_access_key, :ecloudv2_private_key

      #### Models
      model_path 'fog/ecloudv2/models/compute'
#      model :catalog_item
#      model :catalog
#      model :firewall_acl
#      collection :firewall_acls
#      model :internet_service
#      collection :internet_services
#      model :backup_internet_service
#      collection :backup_internet_services
#      model :ip
#      collection :ips
#      model :network
#      collection :networks
#      model :node
#      collection :nodes
#      model :public_ip
#      collection :public_ips
#      model :server
#      collection :servers
#      model :task
#      collection :tasks
      model :environment
      collection :environments
      model :organization
      collection :organizations
#      model :compute_pool
#      collection :compute_pools

      #### Requests
      request_path 'fog/ecloudv2/requests/compute'
#      request :add_internet_service
#      request :add_backup_internet_service
#      request :add_node
#      request :clone_vapp
#      request :configure_internet_service
#      request :configure_network
#      request :configure_network_ip
#      request :configure_node
#      request :configure_vapp
#      request :delete_internet_service
#      request :delete_node
#      request :delete_vapp
#      request :get_catalog
#      request :get_catalog_item
#      request :get_customization_options
#      request :get_firewall_acls
#      request :get_firewall_acl
#      request :get_internet_services
#      request :get_network
#      request :get_network_ip
#      request :get_network_ips
#      request :get_network_extensions
      request :get_organizations
      request :get_organization
#      request :get_node
#      request :get_nodes
#      request :get_public_ip
#      request :get_public_ips
#      request :get_task
#      request :get_task_list
#      request :get_vapp
#      request :get_vapp_template
      request :get_environment
#      request :get_versions
#      request :instantiate_vapp_template
#      request :get_organization
#      request :power_off
#      request :power_on
#      request :power_reset
#      request :power_shutdown
#      request :get_compute_pool
#      request :get_compute_pools

      module Shared

        attr_reader :versions_uri

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

        # login handles the auth, but we just need the Set-Cookie
        # header from that call.
        def do_login
          @login_results = get_organizations
        end

        def ecloud_xmlns
          {
            "xmlns"     => "urn:tmrk:eCloudExtensions-2.8",
            "xmlns:i"   => "http://www.w3.org/2001/XMLSchema-instance"
          }
        end

        def ensure_unparsed(uri)
          if uri.is_a?(String)
            uri
          else
            uri.to_s
          end
        end

        def supported_versions
          @supported_versions ||= get_versions(@versions_uri).body[:VersionInfo]
        end

        def xmlns
          { "xmlns" => "http://www.vmware.com/vcloud/v0.8",
            "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
            "xmlns:xsd" => "http://www.w3.org/2001/XMLSchema" }
        end
      end

      class Mock
        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {}
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          @ecloudv2_api_key = options[:ecloudv2]
        end

        def data
          self.class.data[@ecloudv2_api_key]
        end

        def reset_data
          self.class.data.delete(@ecloudv2_api_key)
        end
      end


      class Real
        include Shared

        class << self
          def basic_request(*args)
            self.class_eval <<-EOS, __FILE__,__LINE__
              def #{args[0]}(uri)
                request({
                :expects => #{args[1] || 200},
                :method => '#{args[2] || 'GET'}',
                :headers => #{args[3] ? args[3].inspect : '{}'},
                :body => '#{args[4] ? args[4] : ''}',
                :parse => true,
                :uri => uri })
              end
            EOS
          end

          def unauthenticated_basic_request(*args)
            self.class_eval <<-EOS, __FILE__,__LINE__
              def #{args[0]}(uri)
                unauthenticated_request({
                :expects => #{args[1] || 200},
                :method => '#{args[2] || 'GET'}',
                :headers => #{args[3] ? args[3].inspect : '{}'},
                :parse => true,
                :uri => uri })
              end
            EOS
          end
        end


        def initialize(options = {})
          require 'builder'
          require 'fog/core/parser'
          @connections             = {}
          @connection_options      = options[:connection_options] || {}
          @host                    = options[:ecloudv2_host] || API_URL
          @api_url                 = @host + "/cloudapi/ecloud"
          @persistent              = options[:persistent] || false
          @version                 = options[:ecloudv2_version] || "2012-03-01"
          @authentication_method   = options[:authentication_method] || :cloud_api_auth
          @access_key              = options[:ecloudv2_access_key]
          @private_key             = options[:ecloudv2_private_key]
          if @private_key.nil?
            @authentication_method = :basic_auth
            @username              = options[:ecloudv2_username]
            @password              = options[:ecloudv2_password]
            if @username.nil? || @password.nil?
              raise RuntimeError, "No credentials (cloud auth, or basic auth) passed!"
            end
          else
            @hmac                  = Fog::HMAC.new("sha256", @private_key)
          end
        end

        def default_organization_uri
          @api_url + "/organizations/"
        end

        def request(params)
          begin
            do_request(params)
          rescue Excon::Errors::Unauthorized => e
            raise RuntimeError, "Invalid authentication data"
          end
        end

        def do_request(params)
          # Convert the uri to a URI if it's a string.
          if params[:uri].is_a?(String)
            params[:uri] = URI.parse(params[:uri])
          end
          host_url = "#{params[:uri].scheme}://#{params[:uri].host}#{params[:uri].port ? ":#{params[:uri].port}" : ''}"

          # Hash connections on the host_url ... There's nothing to say we won't get URI's that go to
          # different hosts.
          @connections[host_url] ||= Fog::Connection.new(host_url, @persistent, @connection_options)
          puts @connections.inspect

          # Set headers to an empty hash if none are set.
          headers = set_extra_headers_for(params[:headers]) || set_extra_headers_for({})

          # Make the request
          response = @connections[host_url].request({
            :body     => params[:body] || '',
            :expects  => params[:expects] || 200,
            :headers  => headers,
            :method   => params[:method] || 'GET',
            :path     => params[:uri].path
          })
          puts response.inspect

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

        private

        # if Authorization and x-tmrk-authorization are used, the x-tmrk-authorization takes precendence.
        def set_extra_headers_for(params)
         maor_headers = {
           'Accept' => 'application/xml',
           'x-tmrk-version' => @version,
           'Date' => Time.now.utc.strftime("%a, %d %b %Y %H:%M:%S GMT"),
           'x-tmrk-date' => Time.now.utc.strftime("%a, %d %b %Y %H:%M:%S GMT")
         }
         params[:headers].merge!(maor_headers)
         if params[:method]=="POST" || params[:method]=="PUT"
           params[:headers].merge!({"Content-Type" => 'application/xml'})
         end
         if params[:body]
            params[:headers].merge!({"x-tmrk-contenthash" => "Sha256 #{Base64.encode64(Digest::SHA2.digest(params[:body].to_s))}"})
         end
         if @authentication_method == :basic_auth
           params[:headers].merge!({'Authorization' => "Basic #{Base64.encode64(@username+":"+@password).delete("\r\n")}"})
         elsif @authentication_method == :cloud_api_auth
           params[:headers].merge!({
             "Authorization" => %{CloudApi AccessKey="#{@access_key}" SignatureType="HmacSha256" Signature="#{cloud_api_signature(params).chomp}"}
           })
         end
         params
        end

        def cloud_api_signature(params)
          verb = params[:method].upcase
          headers = params[:headers]
          path = params[:path]
          canonicalized_headers = canonicalize_headers(headers)
          canonicalized_resource = canonicalize_resource(path)
          string = String.new
          string << verb << "\n"
          string << headers['Content-Length'].to_s << "\n"
          string << headers['Content-Type'].to_s << "\n"
          string << headers['Date'].to_s << "\n"
          string << canonicalized_headers << "\n"
          string << canonicalized_resource << "\n"
          Base64.encode64(@hmac.sign(string))
        end


        # section 5.6.3.2 in the ~1000 page pdf spec
        def canonicalize_headers(headers)
          tmp = headers.inject({}) {|ret, h| ret[h.first.downcase] = h.last if h.first.match(/^x-tmrk/i) ; ret }
          tmp.reject! {|k,v| k == "x-tmrk-authorization" }
          tmp = tmp.sort.map{|e| "#{e.first}:#{e.last}" }.join("\n")
          tmp
        end

        # section 5.6.3.3 in the ~1000 page pdf spec
        def canonicalize_resource(path)
          uri, query_string = path.split("?")
          return uri if query_string.nil?
          query_string_pairs = query_string.split("&").sort.map{|e| e.split("=") }
          tm_query_string = query_string_pairs.map{|x| "#{x.first.downcase}:#{x.last}" }.join("\n")
          "#{uri.downcase}\n#{tm_query_string}\n"
        end
      end
    end
  end
end
