require 'fog/core/model'
module Fog
  module AWS
    class ELB

      class Policy < Fog::Model
        identity :id, :aliases => 'PolicyName'

        attribute :cookie,     :aliases => 'CookieName'
        attribute :expiration, :aliases => 'CookieExpirationPeriod'
        attribute :type_name
        attribute :policy_attributes

        attr_accessor :cookie_stickiness # Either :app or :lb

        def save
          requires :id, :load_balancer
          service_method = nil
          args = [load_balancer.id, id]

          if cookie_stickiness
            case cookie_stickiness
            when :app
              requires :cookie
              method = :create_app_cookie_stickiness_policy
              args << cookie
            when :lb
              method = :create_lb_cookie_stickiness_policy
              args << expiration if expiration
            else
              raise ArgumentError.new('cookie_stickiness must be :app or :lb')
            end
          else
            requires :type_name, :policy_attributes
            method = :create_load_balancer_policy
            args << type_name
            args << policy_attributes
          end

          service.send(method, *args)
          reload
        end

        def destroy
          requires :id, :load_balancer
          service.delete_load_balancer_policy(load_balancer.id, id)
          reload
        end

        def reload
          load_balancer.reload
        end

        def load_balancer
          collection.load_balancer
        end

      end

    end
  end
end
