module Fog
  module Linode
    class Compute < Fog::Service

      requires :linode_api_key
      recognizes :port, :scheme, :persistent
      recognizes :provider # remove post deprecation

      model_path 'fog/compute/models/linode'

      request_path 'fog/compute/requests/linode'
      request :avail_datacenters
      request :avail_distributions
      request :avail_kernels
      request :avail_linodeplans
      request :avail_stackscripts
      # request :linode_boot
      request :linode_create
      request :linode_delete
      request :linode_list
      request :linode_reboot
      # request :linode_resize
      # request :linode_shutdown
      # request :linode_update

      class Mock

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {}
          end
        end

        def initialize(options={})
          unless options.delete(:provider)
            location = caller.first
            warning = "[yellow][WARN] Fog::Linode::Compute.new is deprecated, use Fog::Compute.new(:provider => 'Linode') instead[/]"
            warning << " [light_black](" << location << ")[/] "
            Formatador.display_line(warning)
          end

          @linode_api_key = options[:linode_api_key]
          @data = self.class.data[@linode_api_key]
        end

        def reset_data
          self.class.data.delete(@linode_api_key)
          @data = self.class.data[@linode_api_key]
        end

      end

      class Real

        def initialize(options={})
          unless options.delete(:provider)
            location = caller.first
            warning = "[yellow][WARN] Fog::Linode::Compute.new is deprecated, use Fog::Compute.new(:provider => 'Linode') instead[/]"
            warning << " [light_black](" << location << ")[/] "
            Formatador.display_line(warning)
          end

          require 'json'
          @linode_api_key = options[:linode_api_key]
          @host   = options[:host]    || "api.linode.com"
          @port   = options[:port]    || 443
          @scheme = options[:scheme]  || 'https'
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", options[:persistent])
        end

        def reload
          @connection.reset
        end

        def request(params)
          params[:query] ||= {}
          params[:query].merge!(:api_key => @linode_api_key)

          response = @connection.request(params.merge!({:host => @host}))

          unless response.body.empty?
            response.body = JSON.parse(response.body)
            if data = response.body['ERRORARRAY'].first
              error = case data['ERRORCODE']
              when 5
                Fog::Linode::Compute::NotFound
              else
                Fog::Linode::Compute::Error
              end
              raise error.new(data['ERRORMESSAGE'])
            end
          end
          response
        end

      end
    end
  end
end
