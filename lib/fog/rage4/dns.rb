require 'fog/rage4'
require 'fog/dns'

module Fog
  module DNS
    class Rage4 < Fog::Service

      requires :rage4_email, :rage4_api_key
      recognizes :rage4_url, :host, :path, :port, :scheme, :persistent

      model_path 'fog/rage4/models/dns'
      model       :record
      collection  :records
      model       :zone
      collection  :zones

      request_path 'fog/rage4/requests/dns'
      request :list_domains
      request :get_domain
      request :get_domain_by_name
      request :create_domain
      request :create_domain_vanity
      request :create_reverse_domain_4
      request :create_reverse_domain_6
      request :update_domain
      request :delete_domain
      request :import_domain
      request :sync_domain

      request :export_zone_file
      request :show_current_usage
      request :show_global_usage
      request :list_record_types
      request :list_geo_regions
      request :list_records

      request :create_record
      request :update_record
      request :delete_record
      request :set_record_failover

      class Mock

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :domains => [],
              :records => {}
            }
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          @rage4_email = options[:rage4_email]
          @rage4_password  = options[:rage4_api_key]
        end

        def data
          self.class.data[@rage4_email]
        end

        def reset_data
          self.class.data.delete(@rage4_email)
        end

      end

      class Real

        def initialize(options={})
          @rage4_email = options[:rage4_email]
          @rage4_password  = options[:rage4_api_key]
          @connection_options = options[:connection_options] || {}
          if options[:rage4_url]
            uri = URI.parse(options[:rage4_url])
            options[:host]    = uri.host
            options[:port]    = uri.port
            options[:scheme]  = uri.scheme
          end
          @host       = options[:host]        || "secure.rage4.com"
          @persistent = options[:persistent]  || false
          @port       = options[:port]        || 443
          @scheme     = options[:scheme]      || 'https'
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
        end

        def reload
          @connection.reset
        end

        def request(params)
          params[:headers] ||= {}
          key = "#{@rage4_email}:#{@rage4_password}"
          params[:headers].merge!({ "Authorization" => "Basic " + Base64.encode64(key).gsub("\n",'')})

          response = @connection.request(params)

          unless response.body.empty?
            response.body = Fog::JSON.decode(response.body)
          end
          response
        end
      end
    end
  end
end
