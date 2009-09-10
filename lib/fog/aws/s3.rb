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
        current_directory = File.dirname(__FILE__)
        load "#{current_directory}/../collection.rb"
        load "#{current_directory}/../connection.rb"
        load "#{current_directory}/../model.rb"
        load "#{current_directory}/../parser.rb"
        load "#{current_directory}/../response.rb"

        models_directory = "#{current_directory}/models/s3"
        load "#{models_directory}/bucket.rb"
        load "#{models_directory}/buckets.rb"
        load "#{models_directory}/object.rb"
        load "#{models_directory}/objects.rb"
        load "#{models_directory}/owner.rb"

        parsers_directory = "#{current_directory}/parsers/s3"
        load "#{parsers_directory}/copy_object.rb"
        load "#{parsers_directory}/get_bucket.rb"
        load "#{parsers_directory}/get_bucket_location.rb"
        load "#{parsers_directory}/get_request_payment.rb"
        load "#{parsers_directory}/get_service.rb"

        requests_directory = "#{current_directory}/requests/s3"
        load "#{requests_directory}/copy_object.rb"
        load "#{requests_directory}/delete_bucket.rb"
        load "#{requests_directory}/delete_object.rb"
        load "#{requests_directory}/get_bucket.rb"
        load "#{requests_directory}/get_bucket_location.rb"
        load "#{requests_directory}/get_object.rb"
        load "#{requests_directory}/get_request_payment.rb"
        load "#{requests_directory}/get_service.rb"
        load "#{requests_directory}/head_object.rb"
        load "#{requests_directory}/put_bucket.rb"
        load "#{requests_directory}/put_object.rb"
        load "#{requests_directory}/put_request_payment.rb"

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
          metadata[:headers]['Content-Length'] = File.size(data.path)
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

        canonical_resource  = "/"
        subdomain = params[:host].split(".#{@host}").first
        unless subdomain == @host
          canonical_resource << "#{subdomain}/"
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
