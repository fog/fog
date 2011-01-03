def storage_providers
  {
    AWS       => {
      :mocked => true
    },
    Google    => {
      :mocked => true
    },
    Local     => {
      :mocked => true
    },
    Rackspace => {
      :mocked => false
    }
  }
end