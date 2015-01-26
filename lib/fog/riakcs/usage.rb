require 'fog/riakcs/core'
require 'time'

module Fog
  module RiakCS
    class Usage < Fog::Service
      requires :riakcs_access_key_id, :riakcs_secret_access_key
      recognizes :host, :path, :port, :scheme, :persistent

      request_path 'fog/riakcs/requests/usage'
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
          self.class.data[riakcs_uri]
        end

        def reset_data
          self.class.data.delete(riakcs_uri)
        end
      end

      class Real
        include Utils

        def initialize(options = {})
          configure_uri_options(options)
          @riakcs_access_key_id     = options[:riakcs_access_key_id]
          @riakcs_secret_access_key = options[:riakcs_secret_access_key]
          @connection_options       = options[:connection_options] || {}
          @persistent               = options[:persistent]         || false

          @connection = Fog::Storage.new(
            :provider              => 'AWS',
            :aws_access_key_id     => @riakcs_access_key_id,
            :aws_secret_access_key => @riakcs_secret_access_key,
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
