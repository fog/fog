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
        attribute :create_date, :type => :time
        attribute :domain
        attribute :ip
        attribute :ip_count
        attribute :manage_level
        attribute :template
        attribute :template_description
        attribute :type
        attribute :zone

        def initialize(attributes={})
          super
        end

        def save
          requires :config_id
          requires :domain
          requires :template
          options = {
            :config_id => config_id,
            :domain => domain,
            :password => attributes[:password],
            :template => template,
            :backup_id => attributes[:backup_id],
            :image_id => attributes[:image_id],
            :public_ssh_key => attributes[:public_ssh_key],
            :backup_enabled => backup_enabled,
            :backup_plan => backup_plan,
            :backup_quota => backup_quota
          }.delete_if {|k,v| v.nil? || v == "" }
          data = service.create_server(options).body
          merge_attributes(data)
          true
        end

        def update
          requires :identity
          options = {
            :uniq_id => identity,
            :backup_enabled => backup_enabled,
            :backup_plan => backup_plan,
            :backup_quota => backup_quota,
            :bandwidth_quota => bandwidth_quota,
            :domain => domain
          }.delete_if {|k,v| v.nil? || v == "" }
          data = service.update_server(options).body
          merge_attributes(data)
          true
        end

        def destroy
          requires :identity
          service.delete_server(:uniq_id => identity)
          true
        end

        def ready?
          active == 1
        end

        def reboot(options)
          requires :identity
          service.reboot_server({:uniq_id => identity}.merge!(options))
          true
        end

        def shutdown(options)
          requires :identity
          service.shutdown_server({:uniq_id => identity}.merge!(options))
          true
        end

        def start
          requires :identity
          service.start_server(:uniq_id => identity)
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

      end

    end
  end
end
