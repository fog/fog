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
        attribute :value_dimension, :aliases => 'value-dimension', :type => :integer
        attribute :value_arity, :aliases => 'value-arity'
        attribute :retention_time, :aliases => 'retention-time', :type => :integer
        attribute :granularity, :type => :integer
        attribute :idle_max, :aliases => 'idle-max', :type => :integer
        attribute :transformations, :type => :array
        attribute :persist_data, :aliases => 'persist-data', :type => :boolean
        attribute :crtime
        attribute :value_scope, :aliases => 'value-scope'
        attribute :uris, :type => :array

        def initialize(attributes={})
          self.decomposition = []
          self.value_arity = 'scalar'
          self.retention_time = 600
          self.idle_max = 3600
          self.persist_data = false
          self.value_scope = 'interval'
          super
        end

        def crtime=(new_crtime)
          attributes[:crtime] = Time.at(new_crtime.to_i / 1000)
        end

        def decomposition=(value)
          attributes[:decomposition] = value
          self.value_dimension = self.decomposition.size + 1
          self.decomposition
        end

        def save
          requires :joyent_module, :stat
          munged_attributes = self.attributes.dup
          remap_attributes(munged_attributes, {
              :joyent_module => 'module',
              :value_dimension => 'value-dimension',
              :value_arity => 'value-arity',
              :retention_time => 'retention-time',
              :idle_max => 'idle-max',
              :persist_data => 'persist-data',
              :value_scope => 'value-scope'
          })

          data = service.create_instrumentation(munged_attributes)
          merge_attributes(data.body)
          true
        end

        def destroy
          requires :id
          service.delete_instrumentation(self.identity)
          true
        end

        # Get a set of datapoints back for an instrumentation
        # use start_time and ndatapoints so we can get back a range of datapoints
        # the interval between datapoints should correspond to the granularity of the instrumentation
        # @param [Time] start_time
        # @param [Integer] ndatapoints
        def values(start_time, ndatapoints)
          requires :id, :granularity
          data = service.get_instrumentation_value(self.uris.find {|uri| uri['name'] == 'value_raw'}['uri'], start_time, ndatapoints, self.granularity).body
          data.map do |datum|
            Fog::Joyent::Analytics::Value.new(datum)
          end
        end
      end
    end
  end
end
