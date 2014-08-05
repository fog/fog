require 'fog/riakcs/core'

module Fog
  module RiakCS
    class Provisioning < Fog::Service
      class UserAlreadyExists  < Fog::RiakCS::Provisioning::Error; end
      class ServiceUnavailable < Fog::RiakCS::Provisioning::Error; end

      requires :riakcs_access_key_id, :riakcs_secret_access_key
      recognizes :host, :path, :port, :scheme, :persistent

      request_path 'fog/riakcs/requests/provisioning'
      request :create_user
      request :update_user
      request :disable_user
      request :enable_user
      request :list_users
      request :get_user
      request :regrant_secret

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
          self.class.data[riakcs_uri]
        end

        def reset_data
          self.class.data.delete(riakcs_uri)
        end
      end

      class Real
        include Utils

        def initialize(options = {})
          configure_uri_options(options)
          @riakcs_access_key_id     = options[:riakcs_access_key_id]
          @riakcs_secret_access_key = options[:riakcs_secret_access_key]
          @connection_options       = options[:connection_options] || {}
          @persistent               = options[:persistent]         || false

          @raw_connection = Fog::XML::Connection.new(riakcs_uri, @persistent, @connection_options)

          @s3_connection  = Fog::Storage.new(
            :provider              => 'AWS',
            :aws_access_key_id     => @riakcs_access_key_id,
            :aws_secret_access_key => @riakcs_secret_access_key,
            :host                  => @host,
            :port                  => @port,
            :scheme                => @scheme,
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
                raise Fog::RiakCS::Provisioning.const_get(match[1]).new
              when 'ServiceUnavailable'
                raise Fog::RiakCS::Provisioning.const_get(match[1]).new
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
