require 'fog/core/collection'
require 'fog/cloudsigma/models/subscription'

module Fog
  module Compute
    class CloudSigma
      class Subscriptions < Fog::Collection
        model Fog::Compute::CloudSigma::Subscription

        def all
          resp = service.list_subscriptions
          data = resp.body['objects']
          load(data)
        end

        def get(sub_id)
          resp = service.get_subscription(sub_id)
          data = resp.body
          new(data)
        rescue Fog::CloudSigma::Errors::NotFound
          return nil
        end

        def check_price(subscriptions_list)
          subscriptions_list = subscriptions_list.map {|s| s.kind_of?(Hash) ? s : s.attributes}

          resp = service.calculate_subscription_price(subscriptions_list)

          PriceCalculation.new(resp.body)
        end

        def create_multiple(subscriptions_list)
          subscriptions_list = subscriptions_list.map { |s| s.kind_of?(Hash) ? s : s.attributes }

          resp = service.create_subscription(subscriptions_list)
          resp.body['objects'].map { |s| Subscription.new(s) }
        end
      end
    end
  end
end
