require 'fog/core/model'

module Fog
  module Compute
    class DigitalOcean
      class Image < Fog::Model
        identity  :id
        attribute :name
        attribute :distribution

        attr_accessor :os_version

        def full_name
          requires :distribution, :os_version
          "#{distribution} #{os_version}"
        end

        # Attempt guessing arch based on the name from DigitalOcean
        def arch
          requires :os_version
          os_version.end_with?("x64") ? "x86_64" : ( os_version.end_with?("x32") ? "i386" : nil )
        end
      end
    end
  end
end
