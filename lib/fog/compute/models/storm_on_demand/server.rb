require 'fog/compute/models/server'

module Fog
  module Compute
    class StormOnDemand

      class Server < Fog::Compute::Server
        identity :uniq_id

        attribute :accnt
        attribute :backup_enabled
        attribute :backup_plan
        attribute :backup_quota
        attribute :backup_size
        attribute :bandwidth_quota
        attribute :config_description
        attribute :config_id
        attribute :create_date
        attribute :domain
        attribute :ip
        attribute :ip_count
        attribute :manage_level
        attribute :subaccnt
        attribute :template
        attribute :template_description
        attribute :zone
        attribute :active

        attr_writer :password, :username

        def initialize(attributes={})
          super
        end

        def create(options)
          data = connection.create_server(options).body['servers']
          load(data)
        end

        def destroy
          requires :identity
          connection.delete_server(:uniq_id => identity)
          true
        end

        def ready?
          active == 1
        end

        def reboot
          requires :identity
          connection.reboot_server(:uniq_id => identity)
          true
        end

        def username
          @username ||= 'root'
        end

        def clone(options)
          requires :identity
          connection.clone_server({:uniq_id => identity}.merge!(options))
          true
        end
        def resize(options)
          requires :identity
          connection.resize_server({:uniq_id => identity}.merge!(options))
          true
        end
      end

    end
  end
end
