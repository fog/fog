require 'fog/compute/models/server'

module Fog
  module Compute
    class Clodo
      class Server < Fog::Compute::Server
        identity :id

        attribute :addresses
        attribute :name
        attribute :image_id,    :aliases => 'imageId'
        attribute :type
        attribute :state,       :aliases => 'status'
        attribute :type
        attribute :vps_memory
        attribute :vps_memory_max
        attribute :vps_os_title
        attribute :vps_os_bits
        attribute :vps_os_type
        attribute :vps_vnc
        attribute :vps_cpu_load
        attribute :vps_cpu_max
        attribute :vps_cpu_1h_min
        attribute :vps_cpu_1h_max
        attribute :vps_mem_load
        attribute :vps_mem_max
        attribute :vps_mem_1h_min
        attribute :vps_mem_1h_max
        attribute :vps_hdd_load
        attribute :vps_hdd_max
        attribute :vps_traf_rx
        attribute :vps_traf_tx
        attribute :vps_createdate
        attribute :vps_billingdate
        attribute :vps_update
        attribute :vps_update_days
        attribute :vps_root_pass, :aliases => ['adminPass','password']
        attribute :vps_user_pass
        attribute :vps_vnc_pass

        def initialize(attributes={})
          self.image_id   ||= attributes[:vps_os] ? attributes[:vps_os] : 666
          super attributes
        end

        def destroy
          requires :id
          service.delete_server(id)
          true
        end

        def image
          requires :image_id
          image_id # API does not support image details request. :-(
        end

        def private_ip_address
          nil
        end

        def public_ip_address
          pubaddrs = addresses && addresses['public'] ? addresses['public'].select {|ip| ip['primary_ip']} : nil
          pubaddrs && !pubaddrs.empty? ? pubaddrs.first['ip'] : nil
        end

        def add_ip_address
          service.add_ip_address(id)
        end

        def move_ip_address(ip_address)
          service.move_ip_address(id, ip_address)
        end

        def delete_ip_address(ip_address)
          service.delete_ip_address(id, ip_address)
        end

        def ready?
          self.state == 'is_running'
        end

        def reboot(type = 'SOFT')
          requires :id
          service.reboot_server(id, type)
          true
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?
          requires :image_id
          data = service.create_server(image_id, attributes)
          merge_attributes(data.body['server'])
          true
        end

        def setup(credentials = {})
          requires :ssh_ip_address, :identity, :public_key, :username
          Fog::SSH.new(ssh_ip_address, username, credentials).run([
            %{mkdir .ssh},
            %{echo "#{public_key}" >> ~/.ssh/authorized_keys},
            %{passwd -l #{username}},
            %{echo "#{Fog::JSON.encode(attributes)}" >> ~/attributes.json},
          ])
        rescue Errno::ECONNREFUSED
          sleep(1)
          retry
        end

        def ssh(commands)
          super(commands, password ? {:password => password} : {})
        end

        def password
          vps_root_pass
        end

        private
      end
    end
  end
end
