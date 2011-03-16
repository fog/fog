require 'openssl'
require 'json'
require 'base64'

module Fog
  module Cloudkick
    class Monitoring < Fog::Service

      API_URL = "https://api.cloudkick.com".freeze
      API_VERSION = "2.0".freeze

      requires :cloudkick_key, :cloudkick_secret
      recognizes :cloudkick_api_url

      model_path 'fog/cloudkick/models/monitoring'
      request_path 'fog/cloudkick/requests/monitoring'

      request :list_monitors
      request :list_nodes
      request :disable_monitor
      request :disable_node
      request :enable_monitor
      request :add_tag_to_node
      request :remove_tag_from_node
      request :update_node
      request :create_node
      request :create_monitor
      request :get_status
      request :get_node

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

        # Use the oauth_reserved_character regex to escape the value
        def oauth_escape(value)
          URI::escape(value.to_s, oauth_reserved_characters)
        end

        private

        # Converts a hash to a URI query string suitable for use by oauth
        # i.e. it's sorted properly
        def queryize(opts={})
          opts.sort { |a,b| a[0].to_s <=> b[0].to_s }.map do |opt|
            case opt[1]
            when Array
              opt[1].sort.map { |sub_opt| "#{opt[0]}=#{sub_opt}" }.join("&")
            else
              opt.join("=")
            end
          end.join("&")
        end

        def oauth_secret
          "#{@secret}&"
        end

        def oauth_header(request_method, request_url)
          #puts oauth_header(:get, 'https://api.cloudkick.com/2.0/nodes')
          #Save off the query
          query = request_url.query

          # We need the url w/o the query. I didn't see a URI::HTTP(S) method that can return this w/o also including the port,
          # which AFAICT can't be included either.
          request_url = if query
                          request_url.to_s.sub("?#{query}","")
                        else
                          request_url.to_s
                        end

          # Build the base options hash
          # These are the base items for both the signature and the header
          oauth_options = { 'oauth_consumer_key' => @key,
                            'oauth_nonce' => oauth_nonce,
                            'oauth_signature_method' => oauth_signature_method,
                            'oauth_timestamp' => oauth_timestamp,
                            'oauth_version' => oauth_version
                          }

          # Figure out the signature, which requires the query params to figure out.
          oauth_options['oauth_signature'] = oauth_signature(request_method, request_url, oauth_signature_options(query,oauth_options))

          # This is the header ... no query params here.
          "OAuth #{oauth_options.sort.map { |opt| "#{opt[0]}=\"#{opt[1]}\""}.join(", ")}"
        end

        # If there is a query then return a hash that includes the parsed version of the query
        # Otherwise, just return the oauth_options
        def oauth_signature_options(query, oauth_options)
          query = "" if query.nil?
          oauth_options.merge(
            query.split("&").inject({}) do |acc,item|
              key,value = item.split("=")
              if acc.has_key?(key)
                acc[key] = ([acc[key]] << value).compact
              else
                acc[key] = value
              end
              acc
            end
          )
        end

        def oauth_nonce(size=32)
          #"4GQ0NfgyntBq7AL7tbIu31WCLgGUFgqVdNQ4KSY"
          Base64.encode64(OpenSSL::Random.random_bytes(size)).gsub(/\W/, '')
        end

        # Returned the base64 encoded, signed signature built from the the request_method, request_url and the oauth_options
        def oauth_signature(request_method, request_url, oauth_options)
         # #X4Wpis%2BvvToVgpKlppHTCIsli9k%3D
          oauth_escape(Base64.encode64(
            @hmac.sign(raw_oauth_signature(request_method, request_url, oauth_options))
          ).chomp.gsub(/\n/,''))
          #Digest::HMAC.digest(raw_oauth_signature(request_method, request_uri, nonce, timestamp), "#{@secret}&", Digest::SHA1)
        end

        # The raw, unsigned oauth_signature
        # The contents of oauth_options are sorted, escaped, they key/values joined on "=" and then the results are joined on "&" and escaped again.
        def raw_oauth_signature(request_method, request_url, oauth_options)
          [ request_method.to_s.upcase,
            oauth_escape(request_url),
            oauth_escape(queryize(oauth_options.sort))
          ].join("&")
        end

        # OAuth Reserved character regex
        def oauth_reserved_characters
          /[^a-zA-Z0-9\-\.\_\~]/
        end

        #The OAuth version we're supporting
        def oauth_version
          "1.0"
        end

        # The Oauth signature method we're supporting
        def oauth_signature_method
          "HMAC-SHA1"
        end

        # The OAuth timestamp
        def oauth_timestamp
          #"1291422678"
          Time.now.to_i.to_s
        end

      end

    end
  end
end
