require 'fog/compute/models/server'

module Fog
  module Compute
    class Vsphere
      class Snapshot < Fog::Model

        identity  :ref
        attribute :server_id

        attribute :name
        attribute :quiescedi, :default => false
        attribute :description, :default => ''
        attribute :create_time
        attribute :power_state, :default => 'none'
        attribute :ref
        attribute :mo_ref
        attribute :tree_node
        attribute :snapshot_name_chain
        attribute :ref_chain

        def child_snapshots(filters = {})
          service.snapshots(
            { :server_id => server_id, :parent_snapshot => self }.update(filters)
          )
        end

        def get_child(snapshot_ref)
          return self if ref == snapshot_ref
          child_snapshots().get(snapshot_ref)
        end
      end
    end
  end
end
