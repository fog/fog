require 'base64'
require 'hmac-sha1'

module Fog
  module Storage
    class Ninefold < Fog::Service
      STORAGE_HOST = "onlinestorage.ninefold.com" #"api.ninefold.com"
      STORAGE_PATH = "" #"/storage/v1.0"
      STORAGE_PORT = "80" # "443"
      STORAGE_SCHEME = "http" # "https"

      requires :ninefold_storage_token, :ninefold_storage_secret

      model_path 'fog/storage/models/ninefold'
      model       :directory
      collection  :directories
      model       :file
      collection  :files

      request_path 'fog/storage/requests/ninefold'
      # request :delete_container
      request :get_namespace
      request :post_namespace
      request :put_namespace
      request :delete_namespace

      module Utils
      end

      class Mock
        include Utils

        def initialize(options={})
          require 'mime/types'
          @ninefold_storage_token = options[:ninefold_storage_token]
          @ninefold_storage_secret = options[:ninefold_storage_secret]
        end

        def request(options)
          raise "Ninefold Storage mocks not implemented"
        end

      end

      class Real
        include Utils

        def initialize(options={})
          require 'mime/types'
          @ninefold_storage_token = options[:ninefold_storage_token]
          @ninefold_storage_secret = options[:ninefold_storage_secret]
          @ninefold_storage_secret_decoded = Base64.decode64( @ninefold_storage_secret )

          Excon.ssl_verify_peer = false if options[:rackspace_servicenet] == true
          @connection = Fog::Connection.new("#{Fog::Storage::Ninefold::STORAGE_SCHEME}://#{Fog::Storage::Ninefold::STORAGE_HOST}:#{Fog::Storage::Ninefold::STORAGE_PORT}", true) # persistent
        end

        def uid
          @ninefold_storage_token#.split('/')[-1]
        end

        def sign(string)
          value = ::HMAC::SHA1.digest( @ninefold_storage_secret_decoded, string )
          Base64.encode64( value ).chomp()
        end

        def reload
          @connection.reset
        end

        def request(params, &block)
          req_path = params[:path]
          # Force set host and port
          params.merge!({
                          :host     => Fog::Storage::Ninefold::STORAGE_HOST,
                          :path     => "#{Fog::Storage::Ninefold::STORAGE_PATH}/rest/#{params[:path]}",
                        })
          # Set default method and headers
          params = {:method => 'GET', :headers => {}}.merge params

          params[:headers]["Content-Type"] ||= "application/octet-stream"

          # Add request date
          params[:headers]["date"] = Time.now().httpdate()
          params[:headers]["x-emc-uid"] = @ninefold_storage_token

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
            if key == "x-emc-date"
              #skip
            elsif key =~ /^x-emc-/
              customheaders[ key.downcase ] = value
            end
          }
          header_arr = customheaders.sort()
          first = true
          header_arr.each { |key,value|
            # Values are lowercase and whitespace-normalized
            signstring += key + ":" + value.strip.chomp.squeeze( " " ) + "\n"
          }

          digest = ::HMAC::SHA1.digest( @ninefold_storage_secret_decoded, signstring.chomp() )
          signature = Base64.encode64( digest ).chomp()
          params[:headers]["x-emc-signature"] = signature

          begin
            response = @connection.request(params, &block)
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::Storage::Ninefold::NotFound.slurp(error)
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
