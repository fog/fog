require 'fog/ecloud/models/compute/password_complexity_rule'

module Fog
  module Compute
    class Ecloud
      class PasswordComplexityRules < Fog::Ecloud::Collection

        identity :href

        model Fog::Compute::Ecloud::PasswordComplexityRule

        def all
          data = service.get_password_complexity_rules(href).body
          load(data)
        end

        def get(uri)
          if data = service.get_password_complexity_rule(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
