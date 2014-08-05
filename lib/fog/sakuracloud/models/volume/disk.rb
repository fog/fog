require 'fog/core/model'

module Fog
  module Volume
    class SakuraCloud
      class Disk < Fog::Model
        identity :id, :aliases => 'ID'
        attribute :name, :aliases => 'Name'
        attribute :connection, :aliases => 'Connection'
        attribute :availability, :aliases => 'Availability'
        attribute :plan, :aliases => 'Plan'
        attribute :size_mb, :aliases => 'SizeMB'
        attribute :source_disk, :aliases => 'SourceDisk'
        attribute :source_archive, :aliases => 'SourceArchive'

        def delete
          service.delete_disk(identity)
          true
        end
        alias_method :destroy, :delete

        def save
          requires :name, :plan, :source_archive
          data = service.create_disk(@attributes[:name], @attributes[:plan], @attributes[:source_archive]).body["Disk"]
          merge_attributes(data)
          true
        end

        def configure(sshkey_id)
          requires :id
          service.configure_disk(@attributes[:id], sshkey_id )
          true
        end
      end
    end
  end
end
