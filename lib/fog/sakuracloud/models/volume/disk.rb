require 'fog/core/model'

module Fog
  module Volume
    class SakuraCloud
      class Disk < Fog::Model

        identity :ID
        attribute :Name
        attribute :Connection
        attribute :Availability
        attribute :Plan
        attribute :SizeMB
        attribute :SourceDisk
        attribute :SourceArchive

        def delete
          service.delete_disk(identity)
          true
        end
        alias_method :destroy, :delete

        def save
          requires :Name, :Plan, :SourceArchive
          data = service.create_disk(@attributes[:Name], @attributes[:Plan], @attributes[:SourceArchive]).body["Disk"]
          merge_attributes(data)
          true
        end

        def configure(sshkey_id)
          requires :ID
          service.configure_disk(@attributes[:ID], sshkey_id )
          true
        end

        def wait_for(retry_count = 20)
          requires :ID
          reload
          count = 1
          until @attributes[:Availability] == 'available'
            raise "Resource not available untill #{count * 3} seconds" if count > retry_count
            sleep 3
            print '.'
            reload
            count = count + 1
          end
          true
        end
      end
    end
  end
end
