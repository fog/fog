module Fog
  module AWS
    class Storage < Fog::Service

      requires :aws_access_key_id, :aws_secret_access_key

      model_path 'fog/aws/models/storage'
      collection  :directories
      model       :directory
      collection  :files
      model       :file

      request_path 'fog/aws/requests/storage'
      request :copy_object
      request :delete_bucket
      request :delete_object
      request :get_bucket
      request :get_bucket_acl
      request :get_bucket_location
      request :get_bucket_logging
      request :get_bucket_object_versions
      request :get_bucket_versioning
      request :get_object
      request :get_object_acl
      request :get_object_torrent
      request :get_object_url
      request :get_request_payment
      request :get_service
      request :head_object
      request :put_bucket
      request :put_bucket_acl
      request :put_bucket_logging
      request :put_bucket_versioning
      request :put_object
      request :put_object_url
      request :put_request_payment

      module Utils

        def parse_data(data)
          metadata = {
            :body => nil,
            :headers => {}
          }

          if data.is_a?(String)
            metadata[:body] = data
            metadata[:headers]['Content-Length'] = metadata[:body].size.to_s
          else
            filename = ::File.basename(data.path)
            unless (mime_types = MIME::Types.of(filename)).empty?
              metadata[:headers]['Content-Type'] = mime_types.first.content_type
            end
            metadata[:body] = data
            metadata[:headers]['Content-Length'] = ::File.size(data.path).to_s
          end
          # metadata[:headers]['Content-MD5'] = Base64.encode64(Digest::MD5.digest(metadata[:body])).strip
          metadata
        end

        def url(params, expires)
          params[:headers]['Date'] = expires.to_i
          query = [params[:query]].compact
          query << "AWSAccessKeyId=#{@aws_access_key_id}"
          query << "Signature=#{CGI.escape(signature(params))}"
          query << "Expires=#{params[:headers]['Date']}"
          bucket = params[:host].split('.').first
          "https://#{@host}/#{params[:path]}?#{query.join('&')}"
        end

      end

      class Mock
        include Utils

        def self.data
          @data ||= Hash.new do |hash, region|
            hash[region] = Hash.new do |hash, key|
              hash[key] = {
                :buckets => {}
              }
            end
          end
        end

        def self.reset_data(keys=data.keys)
          for key in [*keys]
            data.delete(key)
          end
        end

        def initialize(options={})
          @aws_access_key_id = options[:aws_access_key_id]
          options[:region] ||= 'us-east-1'
          @host = options[:host] || case options[:region]
          when 'eu-west-1'
            's3-eu-west-1.amazonaws.com'
          when 'us-east-1'
            's3.amazonaws.com'
          when 'ap-southeast-1'
            's3-ap-southeast-1.amazonaws.com'
          when 'us-west-1'
            's3-us-west-1.amazonaws.com'
          else
            raise ArgumentError, "Unknown region: #{options[:region].inspect}"
          end
          @data = self.class.data[options[:region]][@aws_access_key_id]
        end

        def signature(params)
          "foo"
        end
      end

      class Real
        include Utils
        extend Fog::Deprecation
        deprecate(:reset, :reload)

        # Initialize connection to S3
        #
        # ==== Notes
        # options parameter must include values for :aws_access_key_id and 
        # :aws_secret_access_key in order to create a connection
        #
        # ==== Examples
        #   s3 = S3.new(
        #     :aws_access_key_id => your_aws_access_key_id,
        #     :aws_secret_access_key => your_aws_secret_access_key
        #   )
        #
        # ==== Parameters
        # * options<~Hash> - config arguments for connection.  Defaults to {}.
        #
        # ==== Returns
        # * S3 object with connection to aws.
        def initialize(options={})
          @aws_access_key_id = options[:aws_access_key_id]
          @aws_secret_access_key = options[:aws_secret_access_key]
          @hmac = Fog::HMAC.new('sha1', @aws_secret_access_key)
          options[:region] ||= 'us-east-1'
          @host = options[:host] || case options[:region]
            when 'eu-west-1'
              's3-eu-west-1.amazonaws.com'
            when 'us-east-1'
              's3.amazonaws.com'
            when 'ap-southeast-1'
              's3-ap-southeast-1.amazonaws.com'
            when 'us-west-1'
              's3-us-west-1.amazonaws.com'
            else
              raise ArgumentError, "Unknown region: #{options[:region].inspect}"
            end
          @port   = options[:port]      || 443
          @scheme = options[:scheme]    || 'https'
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", options[:persistent] || true)
        end

        def reload
          @connection.reset
        end

        private

        def request(params, &block)
          params[:headers]['Date'] = Time.now.utc.strftime("%a, %d %b %Y %H:%M:%S +0000")
          params[:headers]['Authorization'] = "AWS #{@aws_access_key_id}:#{signature(params)}"
          org_params = params.dup
          params[:expects] = [params[:expects] || [], 307].flatten

          response = @connection.request(params, &block)
          
          if response.status == 307 && endpoint = response.body.match(/<Endpoint>([^<]+)<\/Endpoint>/)[1]
            params = org_params
            params[:host] = endpoint
            # params[:expects] will now be reset to what it was before
            # Redo the request, but to the specified endpoint            
            response = Fog::Connection.new("https://#{endpoint}:443", false).request(params, &block)
          end

          response
        end

        def signature(params)
          string_to_sign =
<<-DATA
#{params[:method]}
#{params[:headers]['Content-MD5']}
#{params[:headers]['Content-Type']}
#{params[:headers]['Date']}
DATA

          amz_headers, canonical_amz_headers = {}, ''
          for key, value in params[:headers]
            if key[0..5] == 'x-amz-'
              amz_headers[key] = value
            end
          end
          amz_headers = amz_headers.sort {|x, y| x[0] <=> y[0]}
          for key, value in amz_headers
            canonical_amz_headers << "#{key}:#{value}\n"
          end
          string_to_sign << "#{canonical_amz_headers}"

          subdomain = params[:host].split(".#{@host}").first
          unless subdomain =~ /^(?:[a-z]|\d(?!\d{0,2}(?:\.\d{1,3}){3}$))(?:[a-z0-9]|\.(?![\.\-])|\-(?![\.])){1,61}[a-z0-9]$/
            Formatador.display_line("[yellow][WARN] fog: the specified s3 bucket name(#{subdomain}) is not a valid dns name, which will negatively impact performance.  For details see: http://docs.amazonwebservices.com/AmazonS3/latest/dev/BucketRestrictions.html[/]")
            params[:host] = params[:host].split("#{subdomain}.")[-1]
            if params[:path]
              params[:path] = "#{subdomain}/#{params[:path]}"
            else
              params[:path] = "#{subdomain}"
            end
            subdomain = nil
          end

          canonical_resource  = "/"
          unless subdomain.nil? || subdomain == @host
            canonical_resource << "#{CGI.escape(subdomain).downcase}/"
          end
          canonical_resource << "#{params[:path]}"
          canonical_resource << '?'
          for key in (params[:query] || {}).keys
            if ['acl', 'location', 'logging', 'requestPayment', 'torrent', 'versions', 'versioning'].include?(key)
              canonical_resource << "#{key}&"
            end
          end
          canonical_resource.chop!
          string_to_sign << "#{canonical_resource}"

          signed_string = @hmac.sign(string_to_sign)
          signature = Base64.encode64(signed_string).chomp!
        end
      end
    end
  end
end
