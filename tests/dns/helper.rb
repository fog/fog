def dns_providers
  {
    AWS       => {
      :mocked => false
    },
    Bluebox   => {
      :mocked => false,
      :zone_attributes => {
        :ttl => 60
      }
    },
    Linode    => {
      :mocked => false,
      :zone_attributes => {
        :email => 'fog@example.com'
      }
    },
    Slicehost => {
      :mocked => false
    },
    Zerigo    => {
      :mocked => false
    },
    DNSimple  => {
      :mocked => false
    }
  }
end
