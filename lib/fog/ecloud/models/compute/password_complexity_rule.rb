module Fog
  module Compute
    class Ecloud
      class PasswordComplexityRule < Fog::Ecloud::Model
        identity :href

        attribute :rule_type, :aliases => :RuleType
        attribute :custom_rules, :aliases => :CustomRules
        attribute :description, :aliases => :Description

        def minimum_characters
          custom_rules[:MinimumCharacters]
        end

        def minimum_upper_case_characters
          custom_rules[:MinimumUpperCaseCharacters]
        end

        def minimum_lower_case_characters
          custom_rules[:MinimumLowerCaseCharacters]
        end

        def minimum_numeric_characters
          custom_rules[:MinimumNumericCharacters]
        end

        def minimum_special_characters
          custom_rules[:MinimumSpecialCharacters]
        end

        def maximum_consecutive_characters_from_prior_password
          custom_rules[:MaximumConsecutiveCharactersFromPriorPassword]
        end

        def minimum_lifetime_restriction
          custom_rules[:MinimumLifetimeRestriction]
        end

        def minimum_generations_before_reuse
          custom_rules[:MinimumGenerationsBeforeReuse]
        end

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
