module Fog
  module DNSimple
    class DNS < Fog::Service

      requires :dnsimple_email, :dnsimple_password
      recognizes :host, :path, :port, :scheme, :persistent
      recognizes :provider # remove post deprecation

      model_path 'fog/dns/models/dnsimple'
      model       :record
      collection  :records
      model       :zone
      collection  :zones

      request_path 'fog/dns/requests/dnsimple'
      request :list_domains
      request :create_domain
      request :get_domain
      request :delete_domain
      request :create_record
      request :list_records
      request :update_record
      request :delete_record
      request :get_record

      class Mock

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {}
          end
        end

        def initialize(options={})
          unless options.delete(:provider)
            location = caller.first
            warning = "[yellow][WARN] Fog::DNS::DNSimple.new is deprecated, use Fog::DNS.new(:provider => 'DNSimple') instead[/]"
            warning << " [light_black](" << location << ")[/] "
            Formatador.display_line(warning)
          end

          @dnsimple_email = options[:dnsimple_email]
          @dnsimple_password  = options[:dnsimple_password]
          @data = self.class.data[@dnsimple_email]
        end

        def reset_data
          self.class.data.delete(@dnsimple_email)
          @data = self.class.data[@dnsimple_email]
        end

      end

      class Real

        def initialize(options={})
          unless options.delete(:provider)
            location = caller.first
            warning = "[yellow][WARN] Fog::DNSimple::DNS.new is deprecated, use Fog::DNS.new(:provider => 'DNSimple') instead[/]"
            warning << " [light_black](" << location << ")[/] "
            Formatador.display_line(warning)
          end

          require 'json'

          @dnsimple_email = options[:dnsimple_email]
          @dnsimple_password  = options[:dnsimple_password]
          @host   = options[:host]    || "dnsimple.com"
          @port   = options[:port]    || 443
          @scheme = options[:scheme]  || 'https'
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", options[:persistent])
        end

        def reload
          @connection.reset
        end

        def request(params)
          params[:headers] ||= {}
          key = "#{@dnsimple_email}:#{@dnsimple_password}"
          params[:headers].merge!({ "Authorization" => "Basic " + Base64.encode64(key).chomp,
                                    "Accept" => "application/json",
                                    "Content-Type" => "application/json" })

          response = @connection.request(params.merge!({:host => @host}))

          unless response.body.empty?
            response.body = JSON.parse(response.body)
          end
          response
        end
      end
    end
  end
end
