module Fog
  class Time < ::Time
    class << self

      def now
        ::Time.now - offset
      end

      def now=(new_now)
        old_now = ::Time.now
        @offset = old_now - new_now
        new_now
      end

      def offset
        @offset ||= 0
      end

    end
  end
end