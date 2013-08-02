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
          all.detect{|policy| id == policy.id}
        end

        private
        def munged_data
          data.inject([]){|m,e|
            m << {
              :id => e["PolicyName"],
              :type_name => e["PolicyTypeName"],
              :policy_attributes => policy_attributes(e["PolicyAttributeDescriptions"])
            }
            m
          }
        end

        def policy_attributes(policy_attribute_descriptions)
          policy_attribute_descriptions.inject({}){|m,e|
            m[e["AttributeName"]] = e["AttributeValue"]
            m
          }
        end

      end

    end
  end
end
