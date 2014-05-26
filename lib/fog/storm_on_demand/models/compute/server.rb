require 'fog/compute/models/server'

module Fog
  module Compute
    class StormOnDemand
      class Server < Fog::Compute::Server
        identity :uniq_id

        attribute :accnt
        attribute :active
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
        attribute :template
        attribute :template_description
        attribute :type
        attribute :zone

        attr_writer :password

        def initialize(attributes={})
          super
        end

        def destroy
          requires :identity
          service.delete_server(:uniq_id => identity)
          true
        end

        def ready?
          active == 1
        end

        def reboot(options={})
          requires :identity
          service.reboot_server({:uniq_id => identity}.merge!(options))
          true
        end

        def clone(options)
          requires :identity
          service.clone_server({:uniq_id => identity}.merge!(options))
          true
        end

        def resize(options)
          requires :identity
          service.resize_server({:uniq_id => identity}.merge!(options))
          true
        end

        def history(options={})
          requires :identity
          params = {:uniq_id => identity}.merge!(options)
          res = service.server_history(params).body
          res['items']
        end

        def shutdown(options={})
          requires :identity
          service.shutdown_server({:uniq_id => identity}.merge!(options)).body
        end

        def start
          reqwuires :identity
          service.start_server({:uniq_id => identity}).body
        end

        def status
          requires :identity
          service.server_status({:uniq_id => identity}).body
        end

        def update(options)
          requires :identity
          service.update_server({:uniq_id => identity}.merge!(options)).body
        end
      end
    end
  end
end
