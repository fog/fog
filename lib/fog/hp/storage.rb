require File.expand_path(File.join(File.dirname(__FILE__), '..', 'hp'))
require 'fog/storage'

module Fog
  module Storage
    class HP < Fog::Service

      requires    :hp_secret_key, :hp_account_id
      recognizes  :hp_auth_uri, :hp_servicenet, :hp_cdn_ssl, :hp_cdn_uri, :persistent, :connection_options

      model_path 'fog/hp/models/storage'
      model       :directory
      collection  :directories
      model       :file
      collection  :files

      request_path 'fog/hp/requests/storage'
      request :delete_container
      request :delete_object
      request :get_container
      request :get_containers
      request :get_object
      request :head_container
      request :head_containers
      request :head_object
      request :put_container
      request :put_object

      module Utils

        def cdn
          unless @hp_cdn_uri.nil?
            @cdn ||= Fog::CDN.new(
              :provider       => 'HP',
              :hp_account_id  => @hp_account_id,
              :hp_secret_key  => @hp_secret_key,
              :hp_auth_uri    => @hp_auth_uri,
              :hp_cdn_uri     => @hp_cdn_uri
            )
            if @cdn.enabled?
              @cdn
            end
          else
            nil
          end
        end

        def url
          "#{@scheme}://#{@host}:#{@port}#{@path}"
        end

        def acl_to_header(acl)
          header = {}
          case acl
            when "private"
              header['X-Container-Read']  = ""
              header['X-Container-Write'] = ""
            when "public-read"
              header['X-Container-Read']  = ".r:*,.rlistings"
            when "public-write"
              header['X-Container-Write'] = "*"
            when "public-read-write"
              header['X-Container-Read']  = ".r:*,.rlistings"
              header['X-Container-Write'] = "*"
          end
          header
        end

        def header_to_acl(read_header=nil, write_header=nil)
          acl = nil
          if read_header.nil? && write_header.nil?
            acl = nil
          elsif !read_header.nil? && read_header.include?(".r:*") && write_header.nil?
            acl = "public-read"
          elsif !write_header.nil? && write_header.include?("*") && read_header.nil?
            acl = "public-write"
          elsif !read_header.nil? && read_header.include?(".r:*") && !write_header.nil? && write_header.include?("*")
            acl = "public-read-write"
          end
        end

        # Take care of container names with '?' in them
        def escape_name(name)
          if name.include?('?')
            URI.escape(name).gsub('?', '%3F')
          else
            URI.escape(name)
          end
        end

        def info
          {:url => url, :auth_token => @auth_token}
        end
      end

      class Mock
        include Utils
        def self.acls(type)
          type
        end

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :acls => {
                :container => {},
                :object => {}
              },
              :containers => {}
            }
            end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          require 'mime/types'
          @hp_secret_key = options[:hp_secret_key]
          @hp_account_id = options[:hp_account_id]
        end

        def data
          self.class.data[@hp_account_id]
        end

        def reset_data
          self.class.data.delete(@hp_account_id)
        end

      end

      class Real
        include Utils
        attr_reader :hp_cdn_ssl

        def initialize(options={})
          require 'mime/types'
          require 'multi_json'
          @hp_secret_key = options[:hp_secret_key]
          @hp_account_id = options[:hp_account_id]
          @hp_auth_uri   = options[:hp_auth_uri]
          @hp_cdn_ssl    = options[:hp_cdn_ssl]
          @hp_cdn_uri    = options[:hp_cdn_uri]
          @connection_options = options[:connection_options] || {}
          credentials = Fog::HP.authenticate(options, @connection_options)
          @auth_token = credentials['X-Auth-Token']

          uri = URI.parse(credentials['X-Storage-Url'])
          @host   = options[:hp_servicenet] == true ? "snet-#{uri.host}" : uri.host
          @path   = uri.path
          @persistent = options[:persistent] || false
          @port   = uri.port
          @scheme = uri.scheme
          Excon.ssl_verify_peer = false if options[:hp_servicenet] == true
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
        end

        def reload
          @connection.reset
        end

        def request(params, parse_json = true, &block)
          begin
            response = @connection.request(params.merge!({
              :headers  => {
                'Content-Type' => 'application/json',
                'X-Auth-Token' => @auth_token
              }.merge!(params[:headers] || {}),
              :host     => @host,
              :path     => "#{@path}/#{params[:path]}",
            }), &block)
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::Storage::HP::NotFound.slurp(error)
            else
              error
            end
          end
          if !response.body.empty? && parse_json && response.headers['Content-Type'] =~ %r{application/json}
            response.body = MultiJson.decode(response.body)
          end
          response
        end

      end
    end
  end
end
