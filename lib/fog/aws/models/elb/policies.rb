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
        # Munge a hash like:
        # {'LBCookieStickinessPolicies' => [policies...],
        # 'AppCookieStickinessPolicies' => [policies...]}
        # to a single array of policies with a cookie_stickiness value
        def munged_data
          munged_data = []
          data['LBCookieStickinessPolicies'].each do |policy|
            munged_data << policy.merge(:cookie_stickiness => :lb)
          end
           data['AppCookieStickinessPolicies'].each do |policy|
            munged_data << policy.merge(:cookie_stickiness => :app)
          end
           munged_data
        end

      end

    end
  end
end

