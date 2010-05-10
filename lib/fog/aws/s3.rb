module Fog
  module AWS
    module S3

      def self.new(options={})

        unless @required
          require 'fog/aws/models/s3/directories'
          require 'fog/aws/models/s3/directory'
          require 'fog/aws/models/s3/files'
          require 'fog/aws/models/s3/file'
          require 'fog/aws/parsers/s3/access_control_list'
          require 'fog/aws/parsers/s3/copy_object'
          require 'fog/aws/parsers/s3/get_bucket'
          require 'fog/aws/parsers/s3/get_bucket_location'
          require 'fog/aws/parsers/s3/get_request_payment'
          require 'fog/aws/parsers/s3/get_service'
          require 'fog/aws/requests/s3/copy_object'
          require 'fog/aws/requests/s3/delete_bucket'
          require 'fog/aws/requests/s3/delete_object'
          require 'fog/aws/requests/s3/get_bucket'
          require 'fog/aws/requests/s3/get_bucket_acl'
          require 'fog/aws/requests/s3/get_bucket_location'
          require 'fog/aws/requests/s3/get_object'
          require 'fog/aws/requests/s3/get_object_acl'
          require 'fog/aws/requests/s3/get_object_torrent'
          require 'fog/aws/requests/s3/get_object_url'
          require 'fog/aws/requests/s3/get_request_payment'
          require 'fog/aws/requests/s3/get_service'
          require 'fog/aws/requests/s3/head_object'
          require 'fog/aws/requests/s3/put_bucket'
          require 'fog/aws/requests/s3/put_bucket_acl'
          require 'fog/aws/requests/s3/put_object'
          require 'fog/aws/requests/s3/put_request_payment'
          @required = true
        end

        if Fog.mocking?
          Fog::AWS::S3::Mock.new(options)
        else
          Fog::AWS::S3::Real.new(options)
        end
      end

      def self.parse_data(data)
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
          metadata[:body] = data.read
          metadata[:headers]['Content-Length'] = ::File.size(data.path).to_s
        end
        # metadata[:headers]['Content-MD5'] = Base64.encode64(Digest::MD5.digest(metadata[:body])).strip
        metadata
      end

      def self.reset_data(keys=Mock.data.keys)
        Mock.reset_data(keys)
      end

      module Utils
        def url(params, expires)
          params[:headers]['Date'] = expires.to_i
          query = [params[:query]].compact
          query << "AWSAccessKeyId=#{@aws_access_key_id}"
          query << "Signature=#{CGI.escape(signature(params))}"
          query << "Expires=#{params[:headers]['Date']}"
          "http://#{params[:host]}/#{params[:path]}?#{query.join('&')}"
        end
      end

      class Mock
        include Utils

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :buckets => {}
            }
          end
        end

        def self.reset_data(keys=data.keys)
          for key in [*keys]
            data.delete(key)
          end
        end

        def initialize(options={})
          @aws_access_key_id = options[:aws_access_key_id]
          @data = self.class.data[@aws_access_key_id]
        end

        def signature(params)
          "foo"
        end
      end

      class Real
        include Utils

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
          unless @aws_access_key_id = options[:aws_access_key_id]
            raise ArgumentError.new('aws_access_key_id is required to access ec2')
          end
          unless @aws_secret_access_key = options[:aws_secret_access_key]
            raise ArgumentError.new('aws_secret_access_key is required to access ec2')
          end
          @hmac       = HMAC::SHA1.new(@aws_secret_access_key)
          @host       = options[:host] || case options[:region]
            when 'ap-southeast-1'
              's3-ap-southeast-1.amazonaws.com'
            when 'us-west-1'
              's3-us-west-1.amazonaws.com'
            else
              's3.amazonaws.com'
            end
          @port       = options[:port]      || 443
          @scheme     = options[:scheme]    || 'https'
        end

        private

        def request(params, &block)
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}")
          params[:headers]['Date'] = Time.now.utc.strftime("%a, %d %b %Y %H:%M:%S +0000")
          params[:headers]['Authorization'] = "AWS #{@aws_access_key_id}:#{signature(params)}"

          response = @connection.request(params, &block)

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
          for pair in amz_headers
            canonical_amz_headers << "#{pair[0]}:#{pair[1]}\n"
          end
          string_to_sign << "#{canonical_amz_headers}"

          subdomain = params[:host].split(".#{@host}").first
          unless subdomain =~ /^(?:[a-z]|\d(?!\d{0,2}(?:\.\d{1,3}){3}$))(?:[a-z0-9]|\.(?![\.\-])|\-(?![\.])){1,61}[a-z0-9]$/
            Formatador.display_line("[yellow][WARN] fog: the specified s3 bucket name(#{subdomain}) is not a valid dns name.  See: http://docs.amazonwebservices.com/AmazonS3/latest/dev/index.html?Introduction.html[/]")
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
          if ['acl', 'location', 'logging', 'requestPayment', 'torrent'].include?(params[:query])
            canonical_resource << "?#{params[:query]}"
          end
          string_to_sign << "#{canonical_resource}"

          hmac = @hmac.update(string_to_sign)
          signature = Base64.encode64(hmac.digest).chomp!
        end
      end
    end
  end
end
