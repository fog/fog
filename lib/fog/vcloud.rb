require 'builder'
require 'fog/vcloud/model'
require 'fog/vcloud/collection'
require 'fog/vcloud/generators'
require 'fog/vcloud/extension'
require 'fog/vcloud/terremark/vcloud'
require 'fog/vcloud/terremark/ecloud'

module URI
  class Generic
    def host_url
      @host_url ||= "#{self.scheme}://#{self.host}#{self.port ? ":#{self.port}" : ''}"
    end
  end
end

module Fog
  module Vcloud
    extend Fog::Service

    requires :username, :password, :versions_uri

    model_path 'fog/vcloud/models'
    model 'vdc'
    model 'vdcs'

    request_path 'fog/vcloud/requests'
    request :login
    request :get_versions
    request :get_vdc
    request :get_organization
    request :get_network

    def self.after_new(instance, options={})
      if mod = options[:module]
        instance.extend eval("#{mod}")
      end 
      instance
    end

    class UnsupportedVersion < Exception ; end

    class Real
      extend Fog::Vcloud::Generators

      attr_accessor :login_uri
      attr_reader :supported_versions, :versions_uri

      def initialize(options = {})
        @connections = {}
        @versions_uri = URI.parse(options[:versions_uri])
        @module = options[:module]
        @version = options[:version]
        @username = options[:username]
        @password = options[:password]
        @login_uri = get_login_uri
        @persistent = options[:persistent]
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

      def reload
        @connections.each_value { |k,v| v.reset if v }
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

      def ensure_unparsed(uri)
        if uri.is_a?(String)
          uri
        else
          uri.to_s
        end
      end

      def supported_version_numbers
        case @supported_versions
        when Array
          @supported_versions.map { |version| version[:Version] }
        when Hash
          @supported_versions[:Version]
        end
      end

      def get_login_uri
        check_versions
        URI.parse case @supported_versions
        when Array
          @supported_versions.detect {|version| version[:Version] == @version }[:LoginUrl]
        when Hash
          @supported_versions[:LoginUrl]
        end
      end

      # Load up @all_versions and @supported_versions from the provided :versions_uri
      # If there are no supported versions raise an error
      # And choose a default version is none is specified
      def check_versions
        @supported_versions = get_versions(@versions_uri).body[:VersionInfo]

        if @supported_versions.empty?
          raise UnsupportedVersion.new("No supported versions found @ #{@version_uri}")
        end

        unless @version
          @version = supported_version_numbers.first
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

      # Actually do the request
      def do_request(params)
        # Convert the uri to a URI if it's a string.
        if params[:uri].is_a?(String)
          params[:uri] = URI.parse(params[:uri])
        end

        # Hash connections on the host_url ... There's nothing to say we won't get URI's that go to
        # different hosts.
        @connections[params[:uri].host_url] ||= Fog::Connection.new(params[:uri].host_url, @persistent)

        # Set headers to an empty hash if none are set.
        headers = params[:headers] || {}

        # Add our auth cookie to the headers
        if @cookie
          headers.merge!('Cookie' => @cookie)
        end

        # Make the request
        response = @connections[params[:uri].host_url].request({
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

    class Mock < Real
      def self.base_url
        "https://fakey.com/api/v0.8"
      end

      def self.data_reset
        @mock_data = nil
      end

      def self.data( base_url = self.base_url )
        @mock_data ||=
        {
          :versions => [
            { :version => "v0.8", :login_url => "#{base_url}/login", :supported => true }
          ],
          :vdc_resources => [
            {
              :type => "application/vnd.vmware.vcloud.vApp+xml",
              :href => "#{base_url}/vapp/61",
              :name => "Foo App 1"
            },
            {
              :type => "application/vnd.vmware.vcloud.vApp+xml",
              :href => "#{base_url}/vapp/62",
              :name => "Bar App 1"
            },
            {
              :type => "application/vnd.vmware.vcloud.vApp+xml",
              :href => "#{base_url}/vapp/63",
              :name => "Bar App 2"
            }
          ],
          :organizations =>
          [
            {
              :info => {
                :href => "#{base_url}/org/1",
                :name => "Boom Inc.",
              },
              :vdcs => [

                { :href => "#{base_url}/vdc/21",
                  :id => "21",
                  :name => "Boomstick",
                  :storage => { :used => "105", :allocated => "200" },
                  :cpu => { :allocated => "10000" },
                  :memory => { :allocated => "20480" },
                  :networks => [
                    { :id => "31",
                      :href => "#{base_url}/network/31",
                      :name => "1.2.3.0/24",
                      :subnet => "1.2.3.0/24",
                      :gateway => "1.2.3.1",
                      :netmask => "255.255.255.0",
                      :dns => "8.8.8.8",
                      :features => [
                        { :type => :FenceMode, :value => "isolated" }
                      ],
                      :ips => { "1.2.3.3" => "Broom 1", "1.2.3.4" => "Broom 2", "1.2.3.10" => "Email" }
                    },
                    { :id => "32",
                      :href => "#{base_url}/network/32",
                      :name => "4.5.6.0/24",
                      :subnet => "4.5.6.0/24",
                      :gateway => "4.5.6.1",
                      :netmask => "255.255.255.0",
                      :dns => "8.8.8.8",
                      :features => [
                        { :type => :FenceMode, :value => "isolated" }
                      ],
                      :ips => { }
                    },
                  ],
                  :vms => [
                    { :href => "#{base_url}/vap/41",
                      :name => "Broom 1"
                    },
                    { :href => "#{base_url}/vap/42",
                      :name => "Broom 2"
                    },
                    { :href => "#{base_url}/vap/43",
                      :name => "Email!"
                    }
                  ]
                },
                { :href => "#{base_url}/vdc/22",
                  :id => "22",
                  :storage => { :used => "40", :allocated => "150" },
                  :cpu => { :allocated => "1000" },
                  :memory => { :allocated => "2048" },
                  :name => "Rock-n-Roll",
                  :networks => [
                    { :id => "33",
                      :href => "#{base_url}/network/33",
                      :name => "7.8.9.0/24",
                      :subnet => "7.8.9.0/24",
                      :gateway => "7.8.9.1",
                      :dns => "8.8.8.8",
                      :netmask => "255.255.255.0",
                      :features => [
                        { :type => :FenceMode, :value => "isolated" }
                      ],
                      :ips => { "7.8.9.10" => "Master Blaster" }
                    }
                  ],
                  :vms => [
                    { :href => "#{base_url}/vap/44",
                      :name => "Master Blaster"
                    }
                  ]
                }
              ]
            }
          ]
        }
      end

      def vdc_from_uri(uri)
        match = Regexp.new(%r:.*/vdc/(\d+):).match(uri.to_s)
        if match
          mock_data[:organizations].map { |org| org[:vdcs] }.flatten.detect { |vdc| vdc[:id] == match[1] }
        end
      end

      def ip_from_uri(uri)
        match = Regexp.new(%r:.*/publicIp/(\d+):).match(uri.to_s)
        if match
          mock_data[:organizations].map { |org| org[:vdcs] }.flatten.map { |vdc| vdc[:public_ips] }.flatten.compact.detect { |public_ip| public_ip[:id] == match[1] }
        end
      end

      def initialize(credentials = {})
        @versions_uri = URI.parse('https://vcloud.fakey.com/api/versions')
        @login_uri = get_login_uri
      end

      def xmlns
        { "xmlns" => "http://www.vmware.com/vcloud/v0.8",
          "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
          "xmlns:xsd" => "http://www.w3.org/2001/XMLSchema" }
      end

      def mock_it(status, mock_data, mock_headers = {})
        response = Excon::Response.new

        #Parse the response body into a hash
        document = Fog::ToHashDocument.new
        parser = Nokogiri::XML::SAX::PushParser.new(document)
        parser << mock_data
        parser.finish
        response.body = document.body

        response.status = status
        response.headers = mock_headers
        response
      end

      def mock_error(expected, status, body='', headers={})
        raise Excon::Errors::Unauthorized.new("Expected(#{expected}) <=> Actual(#{status})")
      end

      def mock_data
        Fog::Vcloud::Mock.data
      end

    end
  end
end
