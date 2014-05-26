require 'fog/core/model'

module Fog
  module Volume
    class SakuraCloud
      class Archive < Fog::Model
        identity :id, :aliases => 'ID'
        attribute :name, :aliases => 'Name'
        attribute :size_mb, :aliases => 'SizeMB'
        attribute :plan, :aliases => 'Plan'
      end
    end
  end
end
