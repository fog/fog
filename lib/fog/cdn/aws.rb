module Fog
  module AWS
    class CDN < Fog::Service

      requires :aws_access_key_id, :aws_secret_access_key
      recognizes :host, :path, :port, :scheme, :version, :persistent
      recognizes :provider # remove post deprecation

      model_path 'fog/cdn/models/aws'

      request_path 'fog/cdn/requests/aws'
      request 'delete_distribution'
      request 'get_distribution'
      request 'get_distribution_list'
      request 'post_distribution'
      request 'post_invalidation'
      request 'put_distribution_config'

      class Mock

        def self.data
          @data ||= Hash.new do |hash, region|
            hash[region] = Hash.new do |region_hash, key|
              region_hash[key] = {
                :buckets => {}
              }
            end
          end
        end

        def initialize(options={})
          unless options.delete(:provider)
            location = caller.first
            warning = "[yellow][WARN] Fog::AWS::CDN.new is deprecated, use Fog::CDN.new(:provider => 'AWS') instead[/]"
            warning << " [light_black](" << location << ")[/] "
            Formatador.display_line(warning)
          end

          require 'mime/types'
          @aws_access_key_id  = options[:aws_access_key_id]
          @region             = options[:region]
          @data = self.class.data[@region][@aws_access_key_id]
        end

        def reset_data
          self.class.data[@region].delete(@aws_access_key_id)
          @data = self.class.data[@region][@aws_access_key_id]
        end

        def signature(params)
          "foo"
        end

      end

      class Real

        # Initialize connection to Cloudfront
        #
        # ==== Notes
        # options parameter must include values for :aws_access_key_id and
        # :aws_secret_access_key in order to create a connection
        #
        # ==== Examples
        #   cdn = Fog::AWS::CDN.new(
        #     :aws_access_key_id => your_aws_access_key_id,
        #     :aws_secret_access_key => your_aws_secret_access_key
        #   )
        #
        # ==== Parameters
        # * options<~Hash> - config arguments for connection.  Defaults to {}.
        #
        # ==== Returns
        # * cdn object with connection to aws.
        def initialize(options={})
          unless options.delete(:provider)
            location = caller.first
            warning = "[yellow][WARN] Fog::AWS::CDN.new is deprecated, use Fog::CDN.new(:provider => 'AWS') instead[/]"
            warning << " [light_black](" << location << ")[/] "
            Formatador.display_line(warning)
          end

          require 'fog/core/parser'

          @aws_access_key_id = options[:aws_access_key_id]
          @aws_secret_access_key = options[:aws_secret_access_key]
          @hmac     = Fog::HMAC.new('sha1', @aws_secret_access_key)
          @host     = options[:host]      || 'cloudfront.amazonaws.com'
          @path     = options[:path]      || '/'
          @port     = options[:port]      || 443
          @scheme   = options[:scheme]    || 'https'
          @version  = options[:version]  || '2010-11-01'
          unless options.has_key?(:persistent)
            options[:persistent] = true
          end
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}#{@path}", options[:persistent])
        end

        def reload
          @connection.reset
        end

        private

        def request(params, &block)
          params[:headers] ||= {}
          params[:headers]['Date'] = Fog::Time.now.to_date_header
          params[:headers]['Authorization'] = "AWS #{@aws_access_key_id}:#{signature(params)}"
          params[:path] = "/#{@version}/#{params[:path]}" 
          @connection.request(params, &block)
        end

        def signature(params)
          string_to_sign = params[:headers]['Date']
          signed_string = @hmac.sign(string_to_sign)
          signature = Base64.encode64(signed_string).chomp!
        end
      end
    end
  end
end
