require 'fog/core/model'
require 'fog/aws/models/glacier/archives'
require 'fog/aws/models/glacier/jobs'

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

        def archives
          @archives ||= Fog::AWS::Glacier::Archives.new(:vault => self, :connection => connection)
        end

        def jobs(filters={})
          Fog::AWS::Glacier::Jobs.new(:vault => self, :connection => connection, :filters => filters)
        end

        def set_notification_configuration(topic, events)
          connection.set_vault_notification_configuration(id, topic, events)
        end

        def delete_notification_configuration
          connection.delete_vault_notification_configuration
        end
        
        def save
          requires :id
          connection.create_vault(id)
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
