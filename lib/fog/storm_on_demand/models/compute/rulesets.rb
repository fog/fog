require 'fog/core/collection'
require 'fog/storm_on_demand/models/compute/ruleset'

module Fog
  module Compute
    class StormOnDemand
      class Rulesets < Fog::Collection
        model Fog::Compute::StormOnDemand::Ruleset

        def create(name, server_id)
          r = service.create_ruleset(:name => name, :uniq_id => server_id).body
          new(r)
        end

        def get(ruleset)
          r = service.get_ruleset(:ruleset => ruleset).body
          new(r)
        end

        def all(options={})
          r = service.list_rulesets(options).body[:item]
          load(r)
        end
        
      end
    end
  end
end
