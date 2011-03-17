module Fog
  module Linode
    class Compute < Fog::Service

      requires :linode_api_key
      recognizes :port, :scheme, :persistent
      recognizes :provider # remove post deprecation

      model_path 'fog/compute/models/linode'
      model :flavor
      collection :flavors
      model :image
      collection :images
      model :server
      collection :servers
      model :kernel
      collection :kernels
      model :data_center
      collection :data_centers
      model :stack_script
      collection :stack_scripts
      model :ip
      collection :ips
      model :disk
      collection :disks

      request_path 'fog/compute/requests/linode'
      request :avail_datacenters
      request :avail_distributions
      request :avail_kernels
      request :avail_linodeplans
      request :avail_stackscripts
      request :linode_disk_create
      request :linode_disk_list
      request :linode_disk_delete
      request :linode_disk_createfromdistribution
      request :linode_disk_createfromstackscript     
      request :linode_ip_list
      request :linode_ip_addprivate
      request :linode_config_list
      request :linode_config_create
      request :linode_create
      request :linode_delete
      request :linode_list
      request :linode_boot
      request :linode_reboot
      request :linode_shutdown
      request :linode_update
      request :stackscript_list
      # request :linode_resize      

      class Mock

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {}
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          unless options.delete(:provider)
            location = caller.first
            warning = "[yellow][WARN] Fog::Linode::Compute.new is deprecated, use Fog::Compute.new(:provider => 'Linode') instead[/]"
            warning << " [light_black](" << location << ")[/] "
            Formatador.display_line(warning)
          end

          @linode_api_key = options[:linode_api_key]
        end

        def data
          self.class.data[@linode_api_key]
        end

        def reset_data
          self.class.data.delete(@linode_api_key)
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
