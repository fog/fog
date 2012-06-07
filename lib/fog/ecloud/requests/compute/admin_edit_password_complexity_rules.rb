module Fog
  module Compute
    class Ecloud
      class Real

        def password_complexity_rules_edit(data)
          validate_data([:rule_type], data)
          if data[:rule_type] == "Custom"
            raise ArgumentError.new("Required data missing: custom_rules") unless data[:custom_rules]
          end
          validate_data([:minimum_characters, :minimum_uppercase_characters, :minimum_lowercase_characters, :minimum_numeric_characters, :minimum_special_characters, :maximum_consecutive_characters_from_prior_passwords, :minimum_lifetime_restriction, :minimum_generations_before_reuse], data[:custom_rules])
          body = build_password_complexity_rules_edit(data)
          request(
            :expects => 202,
            :method => 'PUT',
            :headers => {},
            :body => body,
            :uri => data[:uri],
            :parse => true
          )
        end

        private

        
        def build_password_complexity_rules_edit(data)
          xml = Builder::XmlMarkup.new
          xml.PasswordComplexityRules do
            xml.RuleType data[:rule_type]
            if data[:rule_type] == "Custom"
              xml.CustomRules do
                xml.MinimumCharacters do
                  xml.Enabled data[:custom_rules][:minimum_characters][:enabled]
                  xml.Value data[:custom_rules][:minimum_characters][:value]
                end
                xml.MinimumUpperCaseCharacters do
                  xml.Enabled data[:custom_rules][:minimum_uppercase_characters][:enabled]
                  xml.Value data[:custom_rules][:minimum_uppercase_characters][:value]
                end
                xml.MinimumLowerCaseCharacters do
                  xml.Enabled data[:custom_rules][:minimum_lowercase_characters][:enabled]
                  xml.Value data[:custom_rules][:minimum_lowercase_characters][:value]
                end
                xml.MinimumNumericCharacters do
                  xml.Enabled data[:custom_rules][:minimum_numeric_characters][:enabled]
                  xml.Value data[:custom_rules][:minimum_numeric_characters][:value]
                end
                xml.MinimumSpecialCharacters do
                  xml.Enabled data[:custom_rules][:minimum_special_characters][:enabled]
                  xml.Value data[:custom_rules][:minimum_special_characters][:value]
                end
                xml.MaximumConsecutiveCharactersFromPriorPasswords do
                  xml.Enabled data[:custom_rules][:maximum_consecutive_characters_from_prior_passwords][:enabled]
                  xml.Value data[:custom_rules][:maximum_consecutive_characters_from_prior_passwords][:value]
                end
                xml.MinimumLifetimeRestriction do
                  xml.Enabled data[:custom_rules][:minimum_lifetime_restriction][:enabled]
                  xml.Value data[:custom_rules][:minimum_lifetime_restriction][:value]
                end
                xml.MinimumGenerationsBeforeReuse do
                  xml.Enabled data[:custom_rules][:minimum_generations_before_reuse][:enabled]
                  xml.Value data[:custom_rules][:minimum_generations_before_reuse][:value]
                end
              end
            end
            if data[:description]
              xml.Description data[:description]
            end
          end    
        end
      end
    end
  end
end
