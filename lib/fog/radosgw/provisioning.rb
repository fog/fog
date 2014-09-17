require 'fog/radosgw/core'

module Fog
  module Radosgw
    class Provisioning < Fog::Service

      class UserAlreadyExists  < Fog::Radosgw::Provisioning::Error; end
      class NoSuchUser  < Fog::Radosgw::Provisioning::Error; end
      class ServiceUnavailable < Fog::Radosgw::Provisioning::Error; end

      requires :radosgw_access_key_id, :radosgw_secret_access_key
      recognizes :host, :path, :port, :scheme, :persistent, :path_style

      request_path 'fog/radosgw/requests/provisioning'
      request :create_user
      request :delete_user
      request :update_user
      request :disable_user
      request :enable_user
      request :list_users
      request :get_user

      class Mock
        include Utils

        def self.data
          @data ||= Hash.new({})
        end

        def self.reset
          @data = nil
        end

        def initialize(options = {})
          configure_uri_options(options)
        end

        def data
          self.class.data[radosgw_uri]
        end

        def reset_data
          self.class.data.delete(radosgw_uri)
        end
      end

      class Real
        include Utils

        def initialize(options = {})
          configure_uri_options(options)
          @radosgw_access_key_id     = options[:radosgw_access_key_id]
          @radosgw_secret_access_key = options[:radosgw_secret_access_key]
          @connection_options       = options[:connection_options] || {}
          @persistent               = options[:persistent]         || false
          @path_style               = options[:path_style]         || false

          @raw_connection = Fog::XML::Connection.new(radosgw_uri, @persistent, @connection_options)

          @s3_connection  = Fog::Storage.new(
            :provider              => 'AWS',
            :aws_access_key_id     => @radosgw_access_key_id,
            :aws_secret_access_key => @radosgw_secret_access_key,
            :host                  => @host,
            :port                  => @port,
            :scheme                => @scheme,
            :path_style            => @path_style,
            :connection_options    => @connection_options
          )
        end

        def request(params, parse_response = true, &block)
          begin
            response = @raw_connection.request(params.merge({
              :host     => @host,
              :path     => "#{@path}/#{params[:path]}",
            }), &block)
          rescue Excon::Errors::HTTPStatusError => error
            if match = error.message.match(/<Code>(.*?)<\/Code>(?:.*<Message>(.*?)<\/Message>)?/m)
              case match[1]
              when 'UserAlreadyExists'
                raise Fog::Radosgw::Provisioning.const_get(match[1]).new
              when 'ServiceUnavailable'
                raise Fog::Radosgw::Provisioning.const_get(match[1]).new
              else
                raise error
              end
            else
              raise error
            end
          end
          if !response.body.empty? && parse_response
            response.body = Fog::JSON.decode(response.body)
          end
          response
        end
      end

    end
  end
end
