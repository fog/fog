require 'fog/core/model'

module Fog
  module Compute
    class SakuraCloud
      class SshKey < Fog::Model

        identity :ID
        attribute :Name
        attribute :PublicKey

      end
    end
  end
end
