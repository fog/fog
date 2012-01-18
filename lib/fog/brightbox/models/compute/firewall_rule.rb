require 'fog/core/model'

module Fog
  module Compute
    class Brightbox

      class FirewallRule < Fog::Model

        identity :id
        attribute :url
        attribute :resource_type

        attribute :description

        attribute :source
        attribute :source_port
        attribute :destination
        attribute :destination_port
        attribute :protocol
        attribute :icmp_type_name
        attribute :created_at, :type => :time

        attribute :firewall_policy_id, :aliases => "firewall_policy", :squash => "id"

        # Sticking with existing Fog behaviour, save does not update but creates a new resource
        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if identity
          requires :firewall_policy_id
          options = {
            :firewall_policy => firewall_policy_id,
            :protocol => protocol,
            :description => description,
            :source => source,
            :source_port => source_port,
            :destination => destination,
            :destination_port => destination_port,
            :icmp_type_name => icmp_type_name
          }.delete_if {|k,v| v.nil? || v == "" }
          data = connection.create_firewall_rule(options)
          merge_attributes(data)
          true
        end

        def destroy
          requires :identity
          connection.destroy_firewall_rule(identity)
          true
        end

      end

    end
  end
end
