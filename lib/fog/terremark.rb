module Fog
  module Terremark

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

    def self.new(options={})

      unless @required
        require 'fog/terremark/models/server'
        require 'fog/terremark/models/servers'
        require 'fog/terremark/models/task'
        require 'fog/terremark/models/tasks'
        require 'fog/terremark/parsers/get_catalog'
        require 'fog/terremark/parsers/get_catalog_item'
        require 'fog/terremark/parsers/get_internet_services'
        require 'fog/terremark/parsers/get_node_services'
        require 'fog/terremark/parsers/get_organization'
        require 'fog/terremark/parsers/get_organizations'
        require 'fog/terremark/parsers/get_public_ips'
        require 'fog/terremark/parsers/get_tasks_list'
        require 'fog/terremark/parsers/get_vapp_template'
        require 'fog/terremark/parsers/get_vdc'
        require 'fog/terremark/parsers/instantiate_vapp_template'
        require 'fog/terremark/parsers/internet_service'
        require 'fog/terremark/parsers/node_service'
        require 'fog/terremark/parsers/public_ip'
        require 'fog/terremark/parsers/task'
        require 'fog/terremark/parsers/vapp'
        require 'fog/terremark/requests/add_internet_service'
        require 'fog/terremark/requests/add_node_service'
        require 'fog/terremark/requests/create_internet_service'
        require 'fog/terremark/requests/delete_internet_service'
        require 'fog/terremark/requests/delete_node_service'
        require 'fog/terremark/requests/delete_public_ip'
        require 'fog/terremark/requests/delete_vapp'
        require 'fog/terremark/requests/deploy_vapp'
        require 'fog/terremark/requests/get_catalog'
        require 'fog/terremark/requests/get_catalog_item'
        require 'fog/terremark/requests/get_internet_services'
        require 'fog/terremark/requests/get_node_services'
        require 'fog/terremark/requests/get_organization'
        require 'fog/terremark/requests/get_organizations'
        require 'fog/terremark/requests/get_public_ip'
        require 'fog/terremark/requests/get_public_ips'
        require 'fog/terremark/requests/get_task'
        require 'fog/terremark/requests/get_tasks_list'
        require 'fog/terremark/requests/get_vapp'
        require 'fog/terremark/requests/get_vapp_template'
        require 'fog/terremark/requests/get_vdc'
        require 'fog/terremark/requests/instantiate_vapp_template'
        require 'fog/terremark/requests/reset'
        require 'fog/terremark/requests/power_off'
        require 'fog/terremark/requests/power_on'
        require 'fog/terremark/requests/shutdown'
        @required = true
      end

      unless options[:terremark_password]
        raise ArgumentError.new('terremark_password is required to access terremark')
      end
      unless options[:terremark_username]
        raise ArgumentError.new('terremark_username is required to access terremark')
      end
      if Fog.mocking?
        Fog::Terremark::Mock.new(options)
      else
        Fog::Terremark::Real.new(options)
      end
    end

    class Mock
      include Fog::Terremark::Parser

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

    class Real
      include Fog::Terremark::Parser

      def initialize(options={})
        @terremark_password = options[:terremark_password]
        @terremark_username = options[:terremark_username]
        @terremark_service  = options[:terremark_service] || :vcloud
        case options[:terremark_service]
        when :ecloud
          @host   = options[:host]   || "services.enterprisecloud.terremark.com"
          @path   = options[:path]   || "/api/v0.8a-ext2.0"
        when :vcloud
          @host   = options[:host]   || "services.vcloudexpress.terremark.com"
          @path   = options[:path]   || "/api/v0.8"
        else
          raise "Unsupported Terremark Service"
        end
        @port   = options[:port]   || 443
        @scheme = options[:scheme] || 'https'
        @cookie = get_organizations.headers['Set-Cookie']
      end

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

      def default_vdc_id
        if default_organization_id
          @default_vdc_id ||= begin
            vdcs = get_organization(default_organization_id).body['Links'].select {|link|
              link['type'] == 'application/vnd.vmware.vcloud.vdc+xml'
            }
            if vdcs.length == 1
              vdcs.first['href'].split('/').last.to_i
            else
              nil
            end
          end
        else
          nil
        end
      end

      def default_network_id
        if default_vdc_id
          @default_network_id ||= begin
            networks = get_vdc(default_vdc_id).body['AvailableNetworks']
            if networks.length == 1
              networks.first['href'].split('/').last.to_i
            else
              nil
            end
          end
        else
          nil
        end
      end

      def default_public_ip_id
        if default_vdc_id
          @default_public_ip_id ||= begin
            ips = get_public_ips(default_vdc_id).body['PublicIpAddresses']
            if ips.length == 1
              ips.first['Href'].split('/').last.to_i
            else
              nil
            end
          end
        else
          nil
        end
      end

      def default_tasks_list_id
        if default_organization_id
          @default_tasks_list_id ||= begin
            task_lists = get_organization(default_organization_id).body['Links'].select {|link|
              link['type'] == 'application/vnd.vmware.vcloud.tasksList+xml'
            }
            if task_lists.length == 1
              task_lists.first['href'].split('/').last.to_i
            else
              nil
            end
          end
        else
          nil
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

  end
end
