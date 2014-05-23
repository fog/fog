require 'fog/aws/models/elb/policy'
module Fog
  module AWS
    class ELB
      class Policies < Fog::Collection
        model Fog::AWS::ELB::Policy

        attr_accessor :data, :load_balancer

        def all
          load(munged_data)
        end

        def get(id)
          all.find{|policy| id == policy.id}
        end

        private
        def munged_data
          data.reduce([]){|m,e|
            policy_attribute_descriptions = e["PolicyAttributeDescriptions"]

            policy = {
              :id => e["PolicyName"],
              :type_name => e["PolicyTypeName"],
              :policy_attributes => policy_attributes(policy_attribute_descriptions)
            }

            case e["PolicyTypeName"]
            when 'AppCookieStickinessPolicyType'
              cookie_name = policy_attribute_descriptions.find{|h| h['AttributeName'] == 'CookieName'}['AttributeValue']
              policy['CookieName'] = cookie_name if cookie_name
            when 'LBCookieStickinessPolicyType'
              cookie_expiration_period = policy_attribute_descriptions.find{|h| h['AttributeName'] == 'CookieExpirationPeriod'}['AttributeValue'].to_i
              policy['CookieExpirationPeriod'] = cookie_expiration_period if cookie_expiration_period > 0
            end

            m << policy
            m
          }
        end

        def policy_attributes(policy_attribute_descriptions)
          policy_attribute_descriptions.reduce({}){|m,e|
            m[e["AttributeName"]] = e["AttributeValue"]
            m
          }
        end
      end
    end
  end
end
