require 'fog/cloudsigma/nested_model'

module Fog
  module Compute
    class CloudSigma
      class Subscription < Fog::CloudSigma::CloudsigmaModel
        identity :id

        attribute :status, :type => :string
        attribute :uuid, :type => :string
        attribute :resource, :type => :string
        attribute :auto_renew, :type => :boolean
        attribute :descendants
        attribute :start_time, :type => :time
        attribute :price, :type => :float
        attribute :period, :type => :string
        attribute :remaining, :type => :string
        attribute :amount, :type => :integer
        attribute :end_time, :type => :time
        attribute :discount_percent, :type => :float
        attribute :subscribed_object, :type => :string
        attribute :discount_amount, :type => :float

        def save
          create
        end

        def create
          requires :resource, :amount
          data = attributes

          response = service.create_subscription(data)
          new_attributes = response.body['objects'].first
          merge_attributes(new_attributes)
        end

        def extend(period=nil, end_time=nil)
          requires :identity
          data = {}
          if period
            data[:period] = period
          elsif end_time
            data[:end_time] = end_time
          end
          response = service.extend_subscription(identity, data)

          self.class.new(response.body)
        end
      end
    end
  end
end
