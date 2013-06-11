require 'fog/core'

require 'fog/vcloudng/parser'
require 'fog/vcloudng/compute'

module Fog
  module Vcloudng
    VCLOUDNG_OPTIONS = [:vcloudng_username, :vcloudng_password, :vcloudng_host]
  end
end