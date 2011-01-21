require 'builder'

module Fog
  module TerremarkEcloud
    class Compute < Fog::Service

      requires :terremark_ecloud_username, :terremark_ecloud_password
      recognizes :versions_endpoint

      request_path 'fog/compute/requests/terremark_ecloud'
      request :get_catalog
      request :get_catalog_item
      request :get_ip_addresses
      request :get_network
      request :get_organization
      request :get_vdc

      class Mock

        def initialize(options={})
        end

        def organization_href
          Mock.not_implemented
        end

      end

      class Real

        def initialize(options = {})
          require 'fog/compute/parsers/terremark_ecloud/get_versions'
          require 'fog/compute/parsers/terremark_ecloud/login'

          @username = options[:terremark_ecloud_username]
          @password = options[:terremark_ecloud_password]
          @version  = '0.8b-ext2.6'
          @versions_endpoint = options[:versions_endpoint] || 'https://services.enterprisecloud.terremark.com/api/versions'
        end

        def organization_href
          unless @organization_href
            get_token_and_organization
          end
          @organization_href
        end

        def request(params)
          raise ArgumentError.new('Need :href in params') unless params[:href]

          # set auth token
          if @token.nil?
            get_token_and_organization
          end

          begin
            Fog::Connection.new(params[:href]).request({
              :parser  => params[:parser],
              :expects => params[:expects] || 200,
              :method  => params[:method]  || 'GET',
              :body    => params[:body],
              :headers => {
                'Cookie' => @token
              }.merge(params[:headers] || {})
            })
          rescue Excon::Errors::Unauthorized # expired token
            get_token_and_organization
            retry
          end
        end

        private

        def get_token_and_organization
          # lookup LoginUrl for specified version
          connection = Fog::Connection.new(@versions_endpoint)
          response = connection.request({
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::Parsers::TerremarkEcloud::Compute::GetVersions.new
          });
          version_info = response.body['SupportedVersions'].detect {|version_info| version_info['Version'] == @version}
          unless login_url = version_info && version_info['LoginUrl']
            # no LoginUrl matches specified version
            raise "TerremarkEcloud does not support version #{@version}"
          end

          connection = Fog::Connection.new(login_url)
          response   = connection.request({
            :expects => 200,
            :method  => 'POST',
            :headers => {
              'Authorization' => ('Basic ' << Base64.encode64("#{@username}:#{@password}").chomp!),
              'Content-Type'  => 'application/vnd.vmware.vcloud.orgList+xml'
            },
            :parser   => Fog::Parsers::TerremarkEcloud::Compute::Login.new
          })

          @token = response.headers['Set-Cookie']

          if organization = response.body['OrgList'].first
            @organization_href = organization['href']
          end
        end

      end
    end
  end
end
