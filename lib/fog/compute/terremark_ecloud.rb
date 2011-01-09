require 'builder'

module Fog
  module TerremarkEcloud
    class Compute < Fog::Service

      requires :terremark_ecloud_username, :terremark_ecloud_password
      recognizes :versions_endpoint

      request_path 'fog/compute/requests/terremark_ecloud'
      request :delete_vm
      request :get_catalog
      request :get_catalog_item
      request :get_network
      request :get_network_extensions
      request :get_organization
      request :get_task
      request :get_vdc
      request :get_vm
      request :instantiate_vm_template
      request :power_on_vm
      request :power_off_vm
      request :shutdown_vm

      class Mock

        def initialize(options={})
        end

        def request(params)
          Mock.not_implemented
        end

      end

      class Real

        def initialize(options = {})
          @username = options[:terremark_ecloud_username]
          @password = options[:terremark_ecloud_password]
          @version  = '0.8b-ext2.6'

          if @versions_endpoint = options[:versions_endpoint]
          else
            @versions_endpoint = 'https://services.enterprisecloud.terremark.com/api/versions'
          end
        end

        def request(params)
          begin
            get_token_and_organization if @token.nil?
            response = authenticated_request(params)
          rescue Excon::Errors::Unauthorized
            get_token_and_organization
            response = authenticated_request(params)
          end
        end

        def organization_uri
          unless @organization_uri
            get_token_and_organization
          end
          @organization_uri
        end

        private

        def authenticated_request(params)
          raise ArgumentError.new('Need :uri in params') unless params[:uri]

          Fog::Connection.new(params[:uri]).request({
                                                      :parser  => params[:parser],
                                                      :expects => params[:expects] || 200,
                                                      :method  => params[:method]  || 'GET',
                                                      :body    => params[:body],
                                                      :headers => {
                                                        'Cookie' => @token
                                                      }.merge(params[:headers] || {})
                                                    })
        end

        def get_token_and_organization
          login_uri = login_uri_for(@version)

          username_colon_password   = [@username, @password].join(':')
          base64_encoded            = Base64.encode64(username_colon_password).gsub("\n", '')
          authorization_header_data = "Basic #{base64_encoded}"

          connection = Fog::Connection.new(login_uri)
          response   = connection.request({
                                            :expects => 200,
                                            :method  => 'POST',
                                            :headers => {
                                              'Authorization' => authorization_header_data
                                            }
                                          })

          @token = response.headers['Set-Cookie']

          unless response.body.empty?
            document = Fog::ToHashDocument.new
            parser = Nokogiri::XML::SAX::PushParser.new(document)
            parser << response.body
            parser.finish

            response.body = document.body
          end

          if organization = [response.body[:Org]].first
            @organization_uri = organization[:href]
          end
        end

        def login_uri_for(version)
          connection = Fog::Connection.new(@versions_endpoint)
          response = connection.request({
                               :expects => 200,
                               :method  => 'GET'
                             })

          unless response.body.empty?
            document = Fog::ToHashDocument.new
            parser = Nokogiri::XML::SAX::PushParser.new(document)
            parser << response.body
            parser.finish

            response.body = document.body
          end

          version_info = [response.body[:VersionInfo]].flatten.detect {|v| v[:Version] == version }
          version_info && version_info[:LoginUrl]
        end

      end
    end
  end
end
