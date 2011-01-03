def dns_providers
  {
    AWS       => {
      :mocked => false
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
    }
  }
end