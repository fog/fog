require 'fog/core/model'

module Fog
  module Joyent
    class Analytics
      class Instrumentation < Fog::Model
        identity :id
        attribute :joyent_module, :aliases => 'module'
        attribute :stat
        attribute :predicate
        attribute :decomposition
        attribute :value_dimension, aliases: 'value-dimension'
        attribute :value_arity, aliases: 'value-arity'
        attribute :retention_time, aliases: 'retention-time'
        attribute :granularity
        attribute :idle_max, aliases: 'idle-max'
        attribute :transformations
        attribute :persist_data, aliases: 'persist-data'
        attribute :crtime
        attribute :value_scope, aliases: 'value-scope'
        attribute :uris

      end
    end
  end
end
