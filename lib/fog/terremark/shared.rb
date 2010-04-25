module Fog
  module Terremark
    module Shared

      module Parser

        def parse(data)
          case data['type']
          when 'application/vnd.vmware.vcloud.vApp+xml'
            servers.new(data.merge!(:connection => self))
          else
            data
          end
        end

      end

      module Real

        # TODO: bust cache on organization creation?
        def default_organization_id
          @default_organization_id ||= begin
            org_list = get_organizations.body['OrgList']
            if org_list.length == 1
              org_list.first['href'].split('/').last.to_i
            else
              nil
            end
          end
        end

        private

        def request(params)
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}")
          headers = {}
          if @cookie
            headers.merge!('Cookie' => @cookie)
          end
          response = @connection.request({
            :body     => params[:body],
            :expects  => params[:expects],
            :headers  => headers.merge!(params[:headers] || {}),
            :host     => @host,
            :method   => params[:method],
            :parser   => params[:parser],
            :path     => "#{@path}/#{params[:path]}"
          })
        end

      end

      module Mock
        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {}
          end
        end

        def self.reset_data(keys=data.keys)
          for key in [*keys]
            data.delete(key)
          end
        end

        def initialize(options={})
          @terremark_username = options[:terremark_username]
          @data = self.class.data[@terremark_username]
        end
      end

      def check_shared_options(options)
        %w{ecloud vcloud}.each do |cloud|
          cloud_option_keys = options.keys.select { |key| key.to_s =~ /^terremark_#{cloud}_.*/ }
          unless cloud_option_keys.length == 0 || cloud_option_keys.length == 2
            raise ArgumentError.new("terremark_#{cloud}_username and terremark_#{cloud}_password required to access teremark")
          end
        end
      end

      def shared_requires
        require 'fog/terremark/models/shared/address'
        require 'fog/terremark/models/shared/addresses'
        require 'fog/terremark/models/shared/network'
        require 'fog/terremark/models/shared/networks'
        require 'fog/terremark/models/shared/server'
        require 'fog/terremark/models/shared/servers'
        require 'fog/terremark/models/shared/task'
        require 'fog/terremark/models/shared/tasks'
        require 'fog/terremark/parsers/shared/get_catalog'
        require 'fog/terremark/parsers/shared/get_catalog_item'
        require 'fog/terremark/parsers/shared/get_internet_services'
        require 'fog/terremark/parsers/shared/get_node_services'
        require 'fog/terremark/parsers/shared/get_organization'
        require 'fog/terremark/parsers/shared/get_organizations'
        require 'fog/terremark/parsers/shared/get_public_ips'
        require 'fog/terremark/parsers/shared/get_tasks_list'
        require 'fog/terremark/parsers/shared/get_vapp_template'
        require 'fog/terremark/parsers/shared/get_vdc'
        require 'fog/terremark/parsers/shared/instantiate_vapp_template'
        require 'fog/terremark/parsers/shared/internet_service'
        require 'fog/terremark/parsers/shared/network'
        require 'fog/terremark/parsers/shared/node_service'
        require 'fog/terremark/parsers/shared/public_ip'
        require 'fog/terremark/parsers/shared/task'
        require 'fog/terremark/parsers/shared/vapp'
        require 'fog/terremark/requests/shared/add_internet_service'
        require 'fog/terremark/requests/shared/add_node_service'
        require 'fog/terremark/requests/shared/create_internet_service'
        require 'fog/terremark/requests/shared/delete_internet_service'
        require 'fog/terremark/requests/shared/delete_public_ip'
        require 'fog/terremark/requests/shared/delete_node_service'
        require 'fog/terremark/requests/shared/delete_vapp'
        require 'fog/terremark/requests/shared/deploy_vapp'
        require 'fog/terremark/requests/shared/get_catalog'
        require 'fog/terremark/requests/shared/get_catalog_item'
        require 'fog/terremark/requests/shared/get_internet_services'
        require 'fog/terremark/requests/shared/get_network'
        require 'fog/terremark/requests/shared/get_node_services'
        require 'fog/terremark/requests/shared/get_organization'
        require 'fog/terremark/requests/shared/get_organizations'
        require 'fog/terremark/requests/shared/get_public_ip'
        require 'fog/terremark/requests/shared/get_public_ips'
        require 'fog/terremark/requests/shared/get_task'
        require 'fog/terremark/requests/shared/get_tasks_list'
        require 'fog/terremark/requests/shared/get_vapp'
        require 'fog/terremark/requests/shared/get_vapp_template'
        require 'fog/terremark/requests/shared/get_vdc'
        require 'fog/terremark/requests/shared/instantiate_vapp_template'
        require 'fog/terremark/requests/shared/reset'
        require 'fog/terremark/requests/shared/power_off'
        require 'fog/terremark/requests/shared/power_on'
        require 'fog/terremark/requests/shared/shutdown'

      end

    end
  end
end
