require 'fog/core/model'

module Fog
  module Compute
    class SakuraCloud
      class SshKey < Fog::Model
        identity :id, :aliases => 'ID'
        attribute :name, :aliases => 'Name'
        attribute :public_key, :aliases => 'PublicKey'
      end
    end
  end
end
