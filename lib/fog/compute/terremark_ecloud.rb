require 'builder'

module Fog
  module TerremarkEcloud
    class Compute < Fog::Service

      requires :terremark_ecloud_username, :terremark_ecloud_password
      recognizes :versions_endpoint

      request_path 'fog/compute/requests/terremark_ecloud'
      request :get_catalog
      request :get_catalog_item
      request :get_ip_address
      request :get_ip_addresses
      request :get_network
      request :get_organization
      request :get_task
      request :get_task_list
      request :get_versions
      request :get_vdc
      request :login

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
          @connection = Fog::Connection.new(@versions_endpoint, options[:persistent])
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
            uri = URI.parse(params.delete(:href))
            @connection.request({
              :body     => params[:body],
              :expects  => params[:expects] || 200,
              :headers  => {
                'Cookie' => @token
              }.merge(params[:headers] || {}),
              :method   => params[:method]  || 'GET',
              :parser   => params[:parser],
              :path     => uri.path
            })
          rescue Excon::Errors::Unauthorized # expired token
            get_token_and_organization
            retry
          end
        end

        private

        def get_token_and_organization
          response = self.login
          # if there is only one organization we will note it as a starting point
          if (response.body['OrgList'].length == 1) && (organization = response.body['OrgList'].first)
            @organization_href = organization['href']
          end
        end

      end
    end
  end
end
