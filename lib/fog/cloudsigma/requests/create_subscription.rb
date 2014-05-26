module Fog
  module Compute
    class CloudSigma
      class Real
        def create_subscription(data)
          create_request("subscriptions/", data)
        end
      end

      class Mock
        def create_subscription(data)
          if data[:period] != '1 month' || data[:start_time] || data[:end_time]
            raise Fog::Errors::MockNotImplemented.new('Currently only mocks for subscriptions with period 1 month from now are implemented as mock')
          end

          id = Fog::Mock.random_numbers(3).to_i
          defaults = {'id' => id,
                      'start_time' => DateTime.now,
                      'end_time' => DateTime.now + 30 * 24 * 60 *60,
                      'auto_renew' => false,
                      'amount' => 1.0}

          if data[:resource] == 'vlan'
            vlan_uuid = self.class.random_uuid
            self.data[:vlans][vlan_uuid] = {'uuid' => vlan_uuid,
                                            'subscription' => {'id' => id},
                                            'servers' => [],
                                            'meta' => {},
                                            'tags' => []}
            defaults['subscribed_object'] = vlan_uuid
          end

          mock_create(:subscriptions, 200, data, id, defaults)
        end
      end
    end
  end
end
