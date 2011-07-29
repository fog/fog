module Fog
  module HP
    class Storage < Fog::Service

      requires    :hp_secret_key, :hp_account_id
      recognizes  :hp_auth_uri, :hp_servicenet, :hp_cdn_ssl, :persistent
      recognizes  :provider # remove post deprecation

      model_path 'fog/storage/models/hp'
      model       :directory
      collection  :directories
      model       :file
      collection  :files

      request_path 'fog/storage/requests/hp'
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
#          @cdn ||= Fog::CDN.new(
#            :provider     => 'HP',
#            :hp_password  => @hp_password,
#            :hp_username  => @hp_username
#          )
          nil
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
          unless options.delete(:provider)
            location = caller.first
            warning = "[yellow][WARN] Fog::HP::Storage.new is deprecated, use Fog::Storage.new(:provider => 'HP') instead[/]"
            warning << " [light_black](" << location << ")[/] "
            Formatador.display_line(warning)
          end

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
          unless options.delete(:provider)
            location = caller.first
            warning = "[yellow][WARN] Fog::HP::Storage.new is deprecated, use Fog::Storage.new(:provider => 'HP') instead[/]"
            warning << " [light_black](" << location << ")[/] "
            Formatador.display_line(warning)
          end

          require 'mime/types'
          require 'json'
          @hp_secret_key = options[:hp_secret_key]
          @hp_account_id = options[:hp_account_id]
          @hp_cdn_ssl = options[:hp_cdn_ssl]
          credentials = Fog::HP.authenticate(options)
          @auth_token = credentials['X-Auth-Token']

          uri = URI.parse(credentials['X-Storage-Url'])
          @host   = options[:hp_servicenet] == true ? "snet-#{uri.host}" : uri.host
          @path   = uri.path
          @port   = uri.port
          @scheme = uri.scheme
          Excon.ssl_verify_peer = false if options[:hp_servicenet] == true
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", options[:persistent])
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
              Fog::HP::Storage::NotFound.slurp(error)
            else
              error
            end
          end
          if !response.body.empty? && parse_json && response.headers['Content-Type'] =~ %r{application/json}
            response.body = JSON.parse(response.body)
          end
          response
        end

      end
    end
  end
end
