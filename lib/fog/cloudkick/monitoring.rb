require 'openssl'
require 'base64'

module Fog
  module Cloudkick
    class Monitoring < Fog::Service

      API_URL = "https://api.cloudkick.com"

      requires :cloudkick_key, :cloudkick_secret
      recognizes :cloudkick_api_url

      model_path 'fog/cloudkick/models/monitoring'
      request_path 'fog/cloudkick/requests/monitoring'

      request :list_nodes

      class Mock
        def initialize(options)
        end
      end

      class Real
        def initialize(options)
          @key = options[:cloudkick_key] || Fog.credentials[:cloudkick_key]
          @secret = options[:cloudkick_secret] || Fog.credentials[:cloudkick_secret]
          @api_url = options[:cloudkick_api_url] || API_URL
          @hmac = Fog::HMAC.new('sha1', oauth_secret)
          @connection = Fog::Connection.new(@api_url)
        end

        def request(options)
          #Merge in the Authorization Header
          options[:headers] = options.fetch(:headers,{}).merge(
            {
              'Authorization' => oauth_header(options[:method], URI.join(@api_url, options[:path])),
              'Content-Type' => 'application/json'
            }
          )

          #Call the response
          response = @connection.request(options)

          # If there is a body and the Content-Type is JSON, then parse it and return the parsed output
          # Otherwise just return the response
          #
          # I don't know if I like this
          if !response.body.empty? && response.headers['Content-Type'] =~ %r|application/json|
            JSON.parse(response.body)
          else
            response
          end
        end

        private

        def oauth_secret
          "#{@secret}&"
        end

        def oauth_header(request_method, request_uri)
          #puts oauth_header(:get, 'https://api.cloudkick.com/2.0/nodes')
          nonce = oauth_nonce
          timestamp = oauth_timestamp
          "OAuth oauth_consumer_key=\"#{@key}\", oauth_nonce=\"#{nonce}\", oauth_signature=\"#{oauth_signature(request_method,request_uri,nonce,timestamp)}\", oauth_signature_method=\"#{oauth_signature_method}\", oauth_timestamp=\"#{timestamp}\", oauth_version=\"#{oauth_version}\""
        end

        def oauth_nonce(size=32)
          #"4GQ0NfgyntBq7AL7tbIu31WCLgGUFgqVdNQ4KSY"
          Base64.encode64(OpenSSL::Random.random_bytes(size)).gsub(/\W/, '')
        end

        def oauth_signature(request_method, request_uri, nonce, timestamp)
          #X4Wpis%2BvvToVgpKlppHTCIsli9k%3D
          oauth_escape(Base64.encode64(
            @hmac.sign(raw_oauth_signature(request_method, request_uri, nonce, timestamp))
          ).chomp.gsub(/\n/,''))
          #Digest::HMAC.digest(raw_oauth_signature(request_method, request_uri, nonce, timestamp), "#{@secret}&", Digest::SHA1)
        end

        def raw_oauth_signature(request_method, request_uri, nonce, timestamp)
          [ request_method.to_s.upcase,
            oauth_escape(request_uri),
            oauth_escape("oauth_consumer_key=#{@key}")].join("&") + oauth_escape("&") +
          oauth_escape([
            "oauth_nonce=#{nonce}",
            "oauth_signature_method=#{oauth_signature_method}",
            "oauth_timestamp=#{timestamp}",
            "oauth_version=#{oauth_version}"
          ].join("&"))
        end

        def oauth_reserved_characters
          /[^a-zA-Z0-9\-\.\_\~]/
        end

        def oauth_escape(value)
          URI::escape(value.to_s, oauth_reserved_characters)
        end

        def oauth_version
          "1.0"
        end

        def oauth_signature_method
          "HMAC-SHA1"
        end

        def oauth_timestamp
          #"1291422678"
          Time.now.to_i.to_s
        end

      end

    end
  end
end
