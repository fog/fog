def storage_providers
  {
    AWS       => {
      :mocked => true
    },
    Google    => {
      :mocked => true
    },
    Local     => {
      :mocked => false
    },
    Rackspace => {
      :mocked => false
    }
  }
end