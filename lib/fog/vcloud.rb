module URI
  class Generic
    def host_url
      @host_url ||= "#{self.scheme}://#{self.host}#{self.port ? ":#{self.port}" : ''}"
    end
  end
end

module Fog
  module Vcloud

    class UnsupportedVersion < Exception ; end

    module Options
      REQUIRED = [:versions_uri, :username, :password]
      OPTIONAL = [:module, :version]
      ALL = REQUIRED + OPTIONAL
    end

    class Real

      attr_accessor :login_uri
      attr_reader :supported_versions

      def initialize(options = {})
        @connections = {}
        @versions_uri = URI.parse(options[:versions_uri])
        @module = options[:module]
        @version = options[:version]
        @username = options[:username]
        @password = options[:password]
        @login_uri = get_login_uri
      end

      def default_organization_uri
        @default_organization_uri ||= begin
          unless @login_results
            do_login
          end
          org_list = @login_results.body.organizations
          if organization = @login_results.body.organizations.first
            organization[:href]
          else
            nil
          end
        end
      end

      private

      def supported_version_ids
        @supported_versions.map { |version| version.version }
      end

      def get_login_uri
        check_versions
        URI.parse(@supported_versions.detect {|version| version.version == @version }.login_url)
      end

      # Load up @all_versions and @supported_versions from the provided :versions_uri
      # If there are no supported versions raise an error
      # And choose a default version is none is specified
      def check_versions
        @all_versions = get_versions.body
        @supported_versions = @all_versions.select { |version| version.supported == true }

        if @supported_versions.empty?
          raise UnsupportedVersion.new("No supported versions found @ #{@version_uri}")
        end

        unless @version
          @version = supported_version_ids.sort.first
        end
      end

      # Don't need to  set the cookie for these or retry them if the cookie timed out
      def unauthenticated_request(params)
        do_request(params)
      end

      # Use this to set the Authorization header for login
      def authorization_header
        "Basic #{Base64.encode64("#{@username}:#{@password}").chomp!}"
      end

      # login handles the auth, but we just need the Set-Cookie
      # header from that call.
      def do_login
        @login_results = login
        @cookie = @login_results.headers['Set-Cookie']
      end

      # If the cookie isn't set, do a get_organizations call to set it
      # and try the request.
      # If we get an Unauthoried error, we assume the token expired, re-auth and try again
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

      # Actually do the request
      def do_request(params)
        if params[:uri].is_a?(String)
          params[:uri] = URI.parse(params[:uri])
        end
        @connections[params[:uri].host_url] ||= Fog::Connection.new(params[:uri].host_url)
        headers = params[:headers] || {}
        if @cookie
          headers.merge!('Cookie' => @cookie)
        end
        @connections[params[:uri].host_url].request({
          :body     => params[:body],
          :expects  => params[:expects],
          :headers  => headers,
          :method   => params[:method],
          :parser   => params[:parser],
          :path     => params[:uri].path
        })
      end
    end

    class Mock < Real
      DATA =
      {
        :versions => [
          { :version => "v0.8", :login_url => "https://fakey.com/api/v0.8/login", :supported => true }
        ],
        :vdc_resources => [
          {
            :type => "application/vnd.vmware.vcloud.vApp+xml",
            :href => "https://fakey.com/api/v0.8/vapp/61",
            :name => "Foo App 1"
          },
          {
            :type => "application/vnd.vmware.vcloud.vApp+xml",
            :href => "https://fakey.com/api/v0.8/vapp/62",
            :name => "Bar App 1"
          },
          {
            :type => "application/vnd.vmware.vcloud.vApp+xml",
            :href => "https://fakey.com/api/v0.8/vapp/63",
            :name => "Bar App 2"
          }
        ],
        :organizations =>
        [
          {
            :info => {
              :href => "https://fakey.com/api/v0.8/org/1",
              :name => "Boom Inc.",
            },
            :vdcs => [
              { :href => "https://fakey.com/api/v0.8/vdc/21",
                :name => "Boomstick",
                :storage => { :used => 105, :allocated => 200 },
                :cpu => { :allocated => 10000 },
                :memory => { :allocated => 20480 },
                :networks => [
                  { :href => "https://fakey.com/api/v0.8/network/31",
                    :name => "1.2.3.0/24",
                    :subnet => "1.2.3.0/24",
                    :gateway => "1.2.3.1",
                    :netmask => "255.255.255.0",
                    :fencemode => "isolated"
                  },
                  { :href => "https://fakey.com/api/v0.8/network/32",
                    :name => "4.5.6.0/24",
                    :subnet => "4.5.6.0/24",
                    :gateway => "4.5.6.1",
                    :netmask => "255.255.255.0",
                    :fencemode => "isolated"
                  },
                ],
                :vms => [
                  { :href => "https://fakey.com/api/v0.8/vap/41",
                    :name => "Broom 1"
                  },
                  { :href => "https://fakey.com/api/v0.8/vap/42",
                    :name => "Broom 2"
                  },
                  { :href => "https://fakey.com/api/v0.8/vap/43",
                    :name => "Email!"
                  }
                ],
                :public_ips => [
                  { :id => 51,
                    :name => "99.1.2.3"
                  },
                  { :id => 52,
                    :name => "99.1.2.4"
                  },
                  { :id => 53,
                    :name => "99.1.9.7"
                  }
                ]
              },
              { :href => "https://fakey.com/api/v0.8/vdc/22",
                :storage => { :used => 40, :allocated => 150 },
                :cpu => { :allocated => 1000 },
                :memory => { :allocated => 2048 },
                :name => "Rock-n-Roll",
                :networks => [
                  { :href => "https://fakey.com/api/v0.8/network/33",
                    :name => "7.8.9.0/24",
                    :subnet => "7.8.9.0/24",
                    :gateway => "7.8.9.1",
                    :netmask => "255.255.255.0",
                    :fencemode => "isolated"
                  }
                ],
                :vms => [
                  { :href => "https://fakey.com/api/v0.8/vap/44",
                    :name => "Master Blaster"
                  }
                ],
                :public_ips => [
                  { :id => 54,
                    :name => "99.99.99.99"
                  }
                ]
              }
            ]
          }
        ]
      }

      def initialize(credentials = {})
        require 'builder'
        @versions_uri = URI.parse('https://vcloud.fakey.com/api/versions')
        @login_uri = get_login_uri
      end

      def xmlns
        { "xmlns" => "http://www.vmware.com/vcloud/v0.8",
          "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
          "xmlns:xsd" => "http://www.w3.org/2001/XMLSchema" }
      end

      def mock_it(parser, status, mock_data, mock_headers = {})
        body = Nokogiri::XML::SAX::PushParser.new(parser)
        body << mock_data
        body.finish
        response = Excon::Response.new
        response.status = status
        response.body = parser.response
        response.headers = mock_headers
        response
      end

      def mock_error(expected, status, body='', headers={})
        raise Excon::Errors::Unauthorized.new("Expected(#{expected}) <=> Actual(#{status})")
      end

      def mock_data
        DATA
      end

    end

    class <<self
      def new(credentials = {})
        unless @required
          require 'fog/vcloud/model'
          require 'fog/vcloud/collection'
          require 'fog/vcloud/parser'
          require 'fog/vcloud/models/vdc'
          require 'fog/vcloud/models/vdcs'
          require 'fog/vcloud/terremark/vcloud'
          require 'fog/vcloud/terremark/ecloud'
          require 'fog/vcloud/requests/get_organization'
          require 'fog/vcloud/requests/get_vdc'
          require 'fog/vcloud/requests/get_versions'
          require 'fog/vcloud/requests/login'
          require 'fog/vcloud/parsers/get_organization'
          require 'fog/vcloud/parsers/get_vdc'
          require 'fog/vcloud/parsers/get_versions'
          require 'fog/vcloud/parsers/login'

          Struct.new("VcloudLink", :rel, :href, :type, :name)
          Struct.new("VcloudVdc", :links, :resource_entities, :networks, :cpu_capacity, :storage_capacity, :memory_capacity, :href, :type, :name, :xmlns,
                                  :allocation_model, :network_quota, :nic_quota, :vm_quota, :enabled, :description)
          Struct.new("VcloudOrganization", :links, :name, :href, :type, :xmlns, :description)
          Struct.new("VcloudVersion", :version, :login_url, :supported)
          Struct.new("VcloudOrgList", :organizations, :xmlns)
          Struct.new("VcloudXCapacity", :units, :allocated, :used, :limit)
          @required = true
        end

        instance = if Fog.mocking?
          Fog::Vcloud::Mock.new(credentials)
        else
          Fog::Vcloud::Real.new(credentials)
        end

        if mod = credentials[:module]
          instance.extend eval("#{mod}")
        end

        instance
      end
    end
  end
end
