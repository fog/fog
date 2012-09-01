require 'fog/core/model'
module Fog
  module AWS
    class Glacier

      class Vault < Fog::Model

        identity  :id,                    :aliases => 'VaultName'
        attribute :created_at,            :aliases => 'CreationDate', :type => :time
        attribute :last_inventory_at,     :aliases => 'LastInventoryDate', :type => :time
        attribute :number_of_archives,    :aliases => 'NumberOfArchives', :type => :integer
        attribute :size_in_bytes,         :aliases => 'SizeInBytes', :type => :integer
        attribute :arn,                   :aliases => 'VaultARN'

        def ready?
          # Glacier requests are synchronous
          true
        end

        def save
          requires :id
          data = connection.create_vault(id)
          reload
        end

        def destroy
          requires :id
          connection.delete_vault(id)
        end

      end
    end
  end
end
