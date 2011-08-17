require 'fog/core/model'

module Fog
  module Glesys
    class Compute

      class Template < Fog::Model
        extend Fog::Deprecation

        identity :templateid

        attribute :platform
        attribute :name
        attribute :os
        attribute :min_mem_size
        attribute :min_disk_size

        def list
          connection.template_list
        end

      end
    end
  end
end
