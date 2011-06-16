def dns_providers
  {
    :aws          => {
      :mocked => false
    },
    :bluebox      => {
      :mocked => false,
      :zone_attributes => {
        :ttl => 60
      }
    },
    :dnsimple     => {
      :mocked => false
    },
    :dnsmadeeasy  => {
      :mocked => false
    },
    :linode       => {
      :mocked => false,
      :zone_attributes => {
        :email => 'fog@example.com'
      }
    },
    :slicehost    => {
      :mocked => false
    },
    :zerigo       => {
      :mocked => false
    }
  }
end
