require 'fog/core'
require 'fog/json'

module Fog
  module DNSMadeEasy
    extend Fog::Provider

    service(:dns, 'DNS')
  end
end
