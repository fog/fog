require 'fog/ecloudv2/models/compute/password_complexity_rule'

module Fog
  module Compute
    class Ecloudv2
      class PasswordComplexityRules < Fog::Ecloudv2::Collection

        identity :href

        model Fog::Compute::Ecloudv2::PasswordComplexityRule

        def all
          data = connection.get_password_complexity_rules(href).body
          load(data)
        end

        def get(uri)
          if data = connection.get_password_complexity_rule(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
