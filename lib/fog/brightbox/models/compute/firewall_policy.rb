require 'fog/core/model'

module Fog
  module Compute
    class Brightbox

      class FirewallPolicy < Fog::Model

        identity :id
        attribute :url
        attribute :resource_type

        attribute :name
        attribute :description

        attribute :default

        attribute :server_group_id, :aliases => "server_group", :squash => "id"
        attribute :created_at, :type => :time
        attribute :rules

        # Sticking with existing Fog behaviour, save does not update but creates a new resource
        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if identity
          options = {
            :server_group => server_group_id,
            :name => name,
            :description => description
          }.delete_if {|k,v| v.nil? || v == "" }
          data = connection.create_firewall_policy(options)
          merge_attributes(data)
          true
        end

        def apply_to(server_group_id)
          requires :identity
          options = {
            :server_group => server_group_id
          }
          data = connection.apply_to_firewall_policy(identity, options)
          merge_attributes(data)
          true
        end

        def remove(server_group_id)
          requires :identity
          options = {
            :server_group => server_group_id
          }
          data = connection.remove_firewall_policy(identity, options)
          merge_attributes(data)
          true
        end

        def destroy
          requires :identity
          data = connection.destroy_firewall_policy(identity)
          true
        end

      end

    end
  end
end
