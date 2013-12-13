require 'fog/core/model'

module Fog
  module Joyent
    class Analytics
      class Instrumentation < Fog::Model
        identity :id
        attribute :joyent_module, :aliases => 'module'
        attribute :stat
        attribute :predicate
        attribute :decomposition, :type => :array
        attribute :value_dimension, aliases: 'value-dimension', :type => :integer
        attribute :value_arity, aliases: 'value-arity'
        attribute :retention_time, aliases: 'retention-time', :type => :integer
        attribute :granularity, :type => :integer
        attribute :idle_max, aliases: 'idle-max', :type => :integer
        attribute :transformations, :type => :array
        attribute :persist_data, aliases: 'persist-data', :type => :boolean
        attribute :crtime, :type => :integer
        attribute :value_scope, aliases: 'value-scope'
        attribute :uris, :type => :array

        def save
          requires :joyent_module, :stat
          munged_attributes = attributes.dup
          munged_attributes[:module] = munged_attributes.delete(:joyent_module)
          data = service.create_instrumentation(munged_attributes)
          merge_attributes(data.body)
          true
        end

        def destroy
          requires :id
          service.delete_instrumentation(self.identity)
          true
        end

      end
    end
  end
end
