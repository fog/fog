module Fog
  module Joyent
    extend Fog::Provider

    service(:compute, 'joyent/compute', 'Compute')

  end
end
