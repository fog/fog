require 'fog/core/model'

module Fog
  module Compute
    class Rackspace
      class Flavor < Fog::Model
        identity :id

        attribute :disk
        attribute :name
        attribute :ram

        def bits
          64
        end

        def cores
          # Each server is assigned 4 virtual cores and
	  # given a percentage of CPU cycles based on size
          4 * case ram
          when 256
            1/64.0
          when 512
            1/32.0
          when 1024
            1/16.0
          when 2048
            1/8.0
          when 4096
            1/4.0
          when 8192
            1/2.0
          when 15872
            1
          when 30720
            2
          end
        end
      end
    end
  end
end
