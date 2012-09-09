require 'fog/atmos'
require 'fog/storage'

module Fog
  module Storage
    class Atmos < Fog::Service
      requires :atmos_storage_endpoint,
               :atmos_storage_secret,
               :atmos_storage_token
      recognizes :persistent

      model_path 'fog/atmos/models/storage'
      model       :directory
      collection  :directories
      model       :file
      collection  :files

      request_path 'fog/atmos/requests/storage'
      # request :delete_container
      request :get_namespace
      request :head_namespace
      request :post_namespace
      request :put_namespace
      request :delete_namespace

      module Utils
        ENDPOINT_REGEX = /(https*):\/\/([a-zA-Z0-9\.\-]+)(:[0-9]+)?(\/.*)?/

        def ssl?
          protocol = @endpoint.match(ENDPOINT_REGEX)[1]
          raise ArgumentError, 'Invalid endpoint URL' if protocol.nil?

          return true if protocol == 'https'
          return false if protocol == 'http'

          raise ArgumentError, "Unknown protocol #{protocol}"
        end

        def port
          port = @endpoint.match(ENDPOINT_REGEX)[3]
          return ssl? ? 443 : 80 if port.nil?
          port.split(':')[1].to_i
        end

        def host
          @endpoint.match(ENDPOINT_REGEX)[2]
        end

        def api_path
          @endpoint.match(ENDPOINT_REGEX)[4]
        end

        def setup_credentials(options)
          @storage_token = options[:atmos_storage_token]
          @storage_secret = options[:atmos_storage_secret]
          @storage_secret_decoded = Base64.decode64(@storage_secret)
          @endpoint = options[:atmos_storage_endpoint]
          @prefix = self.ssl? ? 'https' : 'http'
          @storage_host = self.host
          @storage_port = self.port
          @api_path = self.api_path
        end
      end

      class Mock
        include Utils

        def initialize(options={})
          require 'mime/types'
          setup_credentials(options)
        end

        def request(options)
          raise "Atmos Storage mocks not implemented"
        end

      end

      class Real
        include Utils

        def initialize(options={})
          require 'mime/types'

          setup_credentials(options)
          @connection_options = options[:connection_options] || {}
          @hmac               = Fog::HMAC.new('sha1', @storage_secret_decoded)
          @persistent = options.fetch(:persistent, false)

          @connection = Fog::Connection.new("#{@prefix}://#{@storage_host}:#{@storage_port}",
              @persistent, @connection_options)
        end

        def uid
          @storage_token#.split('/')[-1]
        end

        def sign(string)
          value = @hmac.sign(string)
          Base64.encode64( value ).chomp()
        end

        def reload
          @connection.reset
        end

        def request(params, &block)
          req_path = params[:path]
          # Force set host and port
          params.merge!({
                          :host     => @storage_host,
                          :path     => "#{@api_path}/rest/#{params[:path]}",
                        })
          # Set default method and headers
          params = {:method => 'GET', :headers => {}}.merge params

          params[:headers]["Content-Type"] ||= "application/octet-stream"

          # Add request date
          params[:headers]["date"] = Time.now().httpdate()
          params[:headers]["x-emc-uid"] = @storage_token

          # Build signature string
          signstring = ""
          signstring += params[:method]
          signstring += "\n"
          signstring += params[:headers]["Content-Type"]
          signstring += "\n"
          if( params[:headers]["range"] )
            signstring += params[:headers]["range"]
          end
          signstring += "\n"
          signstring += params[:headers]["date"]
          signstring += "\n"

          signstring += "/rest/" + URI.unescape( req_path ).downcase
          query_str = params[:query].map{|k,v| "#{k}=#{v}"}.join('&')
          signstring += '?' + query_str unless query_str.empty?
          signstring += "\n"

          customheaders = {}
          params[:headers].each { |key,value|
            case key
            when 'x-emc-date', 'x-emc-signature'
              #skip
            when /^x-emc-/
              customheaders[ key.downcase ] = value
            end
          }
          header_arr = customheaders.sort()

          header_arr.each { |key,value|
            # Values are lowercase and whitespace-normalized
            signstring += key + ":" + value.strip.chomp.squeeze( " " ) + "\n"
          }

          digest = @hmac.sign(signstring.chomp())
          signature = Base64.encode64( digest ).chomp()
          params[:headers]["x-emc-signature"] = signature

          begin
            response = @connection.request(params, &block)
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::Storage::Atmos::NotFound.slurp(error)
            else
              error
            end
          end
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
