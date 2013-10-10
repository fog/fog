require 'securerandom'

module Fog
  class UUID
    class << self

      def uuid
        if supported?
          SecureRandom.uuid
        else
          raise "UUID generation is not supported by your ruby implementation. Please try upgrading to Ruby 1.9.x."
        end
      end

      def supported?
        SecureRandom.respond_to?(:uuid)
      end

    end
  end
end