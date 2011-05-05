require 'fog/core/model'
module Fog
  module AWS
    class ELB

      class Policy < Fog::Model
        identity :id, :aliases => 'PolicyName'

        attribute :cookie,     :aliases => 'CookieName'
        attribute :expiration, :aliases => 'CookieExpirationPeriod'

        attr_accessor :cookie_stickiness # Either :app or :lb

        def save
          requires :id, :load_balancer, :cookie_stickiness
          connection_method = nil
          args = [load_balancer.id, id]
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

          connection.send(method, *args)
          reload
        end

        def destroy
          requires :id, :load_balancer
          connection.delete_load_balancer_policy(load_balancer.id, id)
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
