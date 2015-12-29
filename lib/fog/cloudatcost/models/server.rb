require 'fog/compute/models/server'

module Fog
  module Compute
    class CloudAtCost
      class Server < Fog::Compute::Server
        identity  :sid
        attribute :id
        attribute :CustID
        attribute :packageid
        attribute :servername
        attribute :label
        attribute :vmname
        attribute :ip
        attribute :netmask
        attribute :gateway
        attribute :hostname
        attribute :rootpass
        attribute :vncport
        attribute :vncpass
        attribute :servertype
        attribute :template
        attribute :cpu
        attribute :cpuusage
        attribute :ram
        attribute :ramusage
        attribute :storage
        attribute :hdusage
        attribute :sdate
        attribute :status
        attribute :panel_note
        attribute :mode
        attribute :uid
        attribute :rdns
        attribute :rdnsdefault
        attribute :template_id


        def new_instance?
          not persisted?
        end

        def save
          raise Fog::Errors::Error.new('Re-saving an existing object may create a duplicate') if persisted?
          save!
        end

        def save!
          requires :cpu, :ram, :storage, :template_id
          data = service.create_server(cpu, ram, storage, template_id)
        end

        def destroy
          perform_action :delete_server
        end

        def power_on
          perform_action :power_on
        end

        def power_off
          perform_action :power_off
        end

        def reset
          perform_action :reset
        end

        def run_mode(mode)
          perform_action :run_mode, mode
        end

        def rename_server(name)
          perform_action :rename_server, name
        end

        def reverse_dns(hostname)
          perform_action :reverse_dns, hostname
        end

        def console
          perform_action :console
        end

        private

        def perform_action(action, *args)
          requires :sid
          response = service.send(action, sid, *args)
          response.body
        end

      end
    end
  end
end
