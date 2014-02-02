require 'fog/aws/core'

module Fog
  module AWS
    class Glacier < Fog::Service
      extend Fog::AWS::CredentialFetcher::ServiceMethods
      
      requires :aws_access_key_id, :aws_secret_access_key
      recognizes :region, :host, :path, :port, :scheme, :persistent, :use_iam_profile, :aws_session_token, :aws_credentials_expire_at

      request_path 'fog/aws/requests/glacier'

      request :abort_multipart_upload
      request :complete_multipart_upload
      request :create_archive
      request :create_vault
      request :delete_archive
      request :delete_vault
      request :delete_vault_notification_configuration
      request :describe_job
      request :describe_vault
      request :get_job_output
      request :get_vault_notification_configuration
      request :initiate_job
      request :initiate_multipart_upload
      request :list_jobs
      request :list_multipart_uploads
      request :list_parts
      request :list_vaults
      request :set_vault_notification_configuration
      request :upload_part

      model_path 'fog/aws/models/glacier'
      model      :vault
      collection :vaults

      MEGABYTE = 1024*1024

      class TreeHash

        def self.digest(body)
          new.add_part(body)
        end

        def reduce_digests(digests)
          while digests.length > 1
            digests = digests.each_slice(2).collect do |pair|
              if pair.length == 2
                Digest::SHA256.digest(pair[0]+pair[1])
              else
                pair.first
              end
            end
          end
          digests.first
        end

        def initialize
          @digests = []
        end

        def add_part(bytes)
          part = self.digest_for_part(bytes)
          @digests << part
          part.unpack('H*').first
        end

        def digest_for_part(body)
          chunk_count = [body.bytesize / MEGABYTE + (body.bytesize % MEGABYTE > 0 ? 1 : 0), 1].max
          if body.respond_to? :byteslice
            digests_for_part = chunk_count.times.collect {|chunk_index| Digest::SHA256.digest(body.byteslice(chunk_index * MEGABYTE, MEGABYTE))}
          else
            if body.respond_to? :encoding
              old_encoding = body.encoding
              body.force_encoding('BINARY')
            end
            digests_for_part = chunk_count.times.collect {|chunk_index| Digest::SHA256.digest(body.slice(chunk_index * MEGABYTE, MEGABYTE))}
            if body.respond_to? :encoding
              body.force_encoding(old_encoding)
            end
          end
          reduce_digests(digests_for_part)
        end

        def hexdigest
          digest.unpack('H*').first
        end

        def digest
          reduce_digests(@digests)
        end
      end

      class Mock

        def initialize(options={})
          Fog::Mock.not_implemented
        end

      end

      class Real
        include Fog::AWS::CredentialFetcher::ConnectionMethods
        # Initialize connection to Glacier
        #
        # ==== Notes
        # options parameter must include values for :aws_access_key_id and
        # :aws_secret_access_key in order to create a connection
        #
        # ==== Examples
        #   ses = SES.new(
        #    :aws_access_key_id => your_aws_access_key_id,
        #    :aws_secret_access_key => your_aws_secret_access_key
        #   )
        #
        # ==== Parameters
        # * options<~Hash> - config arguments for connection.  Defaults to {}.
        #   * region<~String> - optional region to use. For instance, 'us-east-1' and etc.
        #
        # ==== Returns
        # * Glacier object with connection to AWS.
        def initialize(options={})

          @use_iam_profile = options[:use_iam_profile]
          @region = options[:region] || 'us-east-1'

          setup_credentials(options)

          @connection_options     = options[:connection_options] || {}
          @host = options[:host] || "glacier.#{@region}.amazonaws.com"
          @version = '2012-06-01'
          @path       = options[:path]        || '/'
          @persistent = options[:persistent]  || false
          @port       = options[:port]        || 443
          @scheme     = options[:scheme]      || 'https'

          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}#{@path}", @persistent, @connection_options)
        end


        private
        def setup_credentials(options)
          @aws_access_key_id      = options[:aws_access_key_id]
          @aws_secret_access_key  = options[:aws_secret_access_key]
          @aws_session_token      = options[:aws_session_token]
          @aws_credentials_expire_at = options[:aws_credentials_expire_at]

          @signer = Fog::AWS::SignatureV4.new( @aws_access_key_id, @aws_secret_access_key,@region,'glacier')
        end

        def request(params, &block)
          refresh_credentials_if_expired

          date = Fog::Time.now
          params[:headers]['Date'] = date.to_date_header
          params[:headers]['x-amz-date'] = date.to_iso8601_basic

          params[:headers]['Host'] = @host
          params[:headers]['x-amz-glacier-version'] = @version
          params[:headers]['x-amz-security-token'] = @aws_session_token if @aws_session_token
          params[:headers]['Authorization'] = @signer.sign params, date

          response = @connection.request(params, &block)
          if response.headers['Content-Type'] == 'application/json' && response.body.size > 0 #body will be empty if the streaming form has been used
            response.body  = Fog::JSON.decode(response.body)
          end
          response
        end
      end
    end
  end
end
