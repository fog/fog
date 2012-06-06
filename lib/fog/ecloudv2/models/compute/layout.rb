module Fog
  module Compute
    class Ecloudv2
      class Layout < Fog::Ecloudv2::Model
        identity :href

        attribute :type, :aliases => :Type
        attribute :other_links, :aliases => :Links

        def rows
          @rows = Fog::Compute::Ecloudv2::Rows.new(:connection => connection, :href => href)
        end

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
