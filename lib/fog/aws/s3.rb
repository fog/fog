module Fog
  module AWS
    class S3

      if Fog.mocking?
        def self.reset_data
          @data = { :buckets => {} }
        end
        def self.data
          @data
        end
      end

      def self.reload
        load "fog/collection.rb"
        load "fog/connection.rb"
        load "fog/model.rb"
        load "fog/parser.rb"
        load "fog/response.rb"

        load "fog/aws/models/s3/bucket.rb"
        load "fog/aws/models/s3/buckets.rb"
        load "fog/aws/models/s3/object.rb"
        load "fog/aws/models/s3/objects.rb"
        load "fog/aws/models/s3/owner.rb"

        load "fog/aws/parsers/s3/copy_object.rb"
        load "fog/aws/parsers/s3/get_bucket.rb"
        load "fog/aws/parsers/s3/get_bucket_location.rb"
        load "fog/aws/parsers/s3/get_request_payment.rb"
        load "fog/aws/parsers/s3/get_service.rb"

        load "fog/aws/requests/s3/copy_object.rb"
        load "fog/aws/requests/s3/delete_bucket.rb"
        load "fog/aws/requests/s3/delete_object.rb"
        load "fog/aws/requests/s3/get_bucket.rb"
        load "fog/aws/requests/s3/get_bucket_location.rb"
        load "fog/aws/requests/s3/get_object.rb"
        load "fog/aws/requests/s3/get_request_payment.rb"
        load "fog/aws/requests/s3/get_service.rb"
        load "fog/aws/requests/s3/head_object.rb"
        load "fog/aws/requests/s3/put_bucket.rb"
        load "fog/aws/requests/s3/put_object.rb"
        load "fog/aws/requests/s3/put_request_payment.rb"

        if Fog.mocking?
          reset_data
        end
      end

      # Initialize connection to S3
      #
      # ==== Notes
      # options parameter must include values for :aws_access_key_id and 
      # :aws_secret_access_key in order to create a connection
      #
      # ==== Examples
      #   sdb = S3.new(
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
        @aws_access_key_id      = options[:aws_access_key_id]
        @aws_secret_access_key  = options[:aws_secret_access_key]
        @hmac       = HMAC::SHA1.new(@aws_secret_access_key)
        @host       = options[:host]      || 's3.amazonaws.com'
        @port       = options[:port]      || 443
        @scheme     = options[:scheme]    || 'https'
        @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}")
      end

      private

      def parse_data(data)
        metadata = {
          :body => nil,
          :headers => {}
        }

        if data.is_a?(String)
          metadata[:body] = data
          metadata[:headers]['Content-Length'] = metadata[:body].size.to_s
        else
          filename = File.basename(data.path)
          unless (mime_types = MIME::Types.of(filename)).empty?
            metadata[:headers]['Content-Type'] = mime_types.first.content_type
          end
          metadata[:body] = data.read
          metadata[:headers]['Content-Length'] = File.size(data.path).to_s
        end
        # metadata[:headers]['Content-MD5'] = Base64.encode64(Digest::MD5.digest(metadata[:body])).strip
        metadata
      end

      def request(params)
        params[:headers]['Date'] = Time.now.utc.strftime("%a, %d %b %Y %H:%M:%S +0000")

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
          puts("[WARN] fog: the specified s3 bucket name(#{subdomain}) is not a valid dns name.  See: http://docs.amazonwebservices.com/AmazonS3/latest/dev/index.html?Introduction.html")
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
        params[:headers]['Authorization'] = "AWS #{@aws_access_key_id}:#{signature}"

        response = @connection.request({
          :block    => params[:block],
          :body     => params[:body],
          :expects  => params[:expects],
          :headers  => params[:headers],
          :host     => params[:host],
          :method   => params[:method],
          :parser   => params[:parser],
          :path     => params[:path],
          :query    => params[:query]
        })

        response
      end

    end
  end
end

Fog::AWS::S3.reload
