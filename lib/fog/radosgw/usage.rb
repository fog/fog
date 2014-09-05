require 'fog/radosgw/core'
require 'time'

module Fog
  module Radosgw
    class Usage < Fog::Service
      requires :radosgw_access_key_id, :radosgw_secret_access_key
      recognizes :host, :path, :port, :scheme, :persistent

      request_path 'fog/radosgw/requests/usage'
      request :get_usage

      class Mock
        include Utils

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {}
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options = {})
          configure_uri_options(options)
        end

        def data
          self.class.data[radosgw_uri]
        end

        def reset_data
          self.class.data.delete(radosgw_uri)
        end
      end

      class Real
        include Utils

        def initialize(options = {})
          configure_uri_options(options)
          @radosgw_access_key_id     = options[:radosgw_access_key_id]
          @radosgw_secret_access_key = options[:radosgw_secret_access_key]
          @connection_options       = options[:connection_options] || {}
          @persistent               = options[:persistent]         || false

          @s3_connection = Fog::Storage.new(
            :provider              => 'AWS',
            :aws_access_key_id     => @radosgw_access_key_id,
            :aws_secret_access_key => @radosgw_secret_access_key,
            :host                  => @host,
            :port                  => @port,
            :scheme                => @scheme,
            :connection_options    => @connection_options
          )
        end
      end
    end
  end
end
