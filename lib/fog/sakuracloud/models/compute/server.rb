require 'fog/core/model'

module Fog
  module Compute
    class SakuraCloud
      class Server < Fog::Model

        identity :ID
        attribute :Name
        attribute :ServerPlan
        attribute :Instance
        attribute :Disks
        attribute :Interfaces

        def save
          requires :Name, :ServerPlan
          data = service.create_server(@attributes[:Name], @attributes[:ServerPlan]).body["Server"]
          merge_attributes(data)
          true
        end

        def boot
          requires :ID
          service.boot_server(@attributes[:ID])
        end

        def stop(force = false)
          requires :ID
          service.stop_server(@attributes[:ID], force)
        end

        def delete(disks = [])
          requires :ID
          service.delete_server(@attributes[:ID], disks)
          true
        end
        alias_method :destroy, :delete

        def wait_for(user = 'root')
          # pending
          requires :ID
          ip = @attributes[:Interfaces].first['IPAddress']
          begin
            ssh = Fog::SSH.new(ip, user, :timeout => 3)
          rescue Net::SSH::AuthenticationFailed
            Fog::Loger.warning("Net::SSH::AuthenticationFailed")
          end
          ssh.run('id')
        end
      end
    end
  end
end
