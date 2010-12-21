require File.join(File.dirname(__FILE__), 'core')

module Fog
  module Brightbox
    extend Fog::Provider
    service_path 'fog/brightbox'
    service 'compute'
  end
end