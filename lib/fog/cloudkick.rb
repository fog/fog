module Fog
  module Cloudkick
    extend Fog::Provider
    service_path 'fog/cloudkick'
    service 'monitoring'
  end
end
