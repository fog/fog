require 'fog/core/model'

module Fog
  module Linode
    class Compute
      class Server < Fog::Model
        identity :id
        attribute :name
        attribute :status

        def ips
          connection.ips.all(self.id)
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if identity
          data_center, flavor, image, name, password = attributes.values_at :data_center, :flavor, :image, :name, :password

          id = connection.linode_create(data_center.id, flavor.id, 1).body['DATA']['LinodeID']
          
          connection.linode_ip_addprivate id
          ip = connection.ips.all(id).find { |ip| !ip.public }
          
          script = connection.stack_scripts.get 2161
          script_options = { :hostname => name, :privip => ip.ip }

          swap = connection.linode_disk_create(id, "#{name}_swap", 'swap', flavor.ram).body['DATA']['DiskID']
          disk = connection.linode_disk_createfromstackscript(id, script.id, image.id, "#{name}_main",
                                                              (flavor.disk*1024)-flavor.ram, password, script_options).body['DATA']['DiskID']
          config = connection.linode_config_create(id, 110, name, "#{disk},#{swap},,,,,,,").body['DATA']['ConfigID']
          connection.linode_update id, :label => name
          connection.linode_boot id, config
          new_server = connection.servers.get id
#          merge_attributes(new_server)
          true
        end
      end
    end
  end
end
