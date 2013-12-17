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
        attribute :crtime
        attribute :value_scope, aliases: 'value-scope'
        attribute :uris, :type => :array

        def crtime=(new_crtime)
          attributes[:crtime] = Time.at(new_crtime.to_i / 1000)
        end

        def save
          requires :joyent_module, :stat
          munged_attributes = attributes.dup
          munged_attributes[:module] = munged_attributes.delete(:joyent_module)
          munged_attributes[:'value-dimension'] = munged_attributes.delete(:value_dimension) || (self.decomposition.size + 1)
          munged_attributes[:'value-arity'] = munged_attributes.delete(:value_arity) || 'scalar'
          munged_attributes[:'retention-time'] = munged_attributes.delete(:retention_time) || 600
          munged_attributes[:'idle-max'] = munged_attributes.delete(:idle_max) || 3600
          munged_attributes[:'persist-data'] = munged_attributes.delete(:persist_data) || false
          munged_attributes[:'value-scope'] = munged_attributes.delete(:value_scope) || 'interval'
          data = service.create_instrumentation(munged_attributes)
          merge_attributes(data.body)
          true
        end

        def destroy
          requires :id
          service.delete_instrumentation(self.identity)
          true
        end

        def values(since, n)
          requires :id
          data = service.get_instrumentation_value(self.uris.find {|uri| uri['name'] == 'value_raw'}['uri'], since, n).body
          data.map do |datum|
            Fog::Joyent::Analytics::Value.new(datum)
          end
        end

      end
    end
  end
end
