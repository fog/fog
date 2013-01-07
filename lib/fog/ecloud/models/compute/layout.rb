module Fog
  module Compute
    class Ecloud
      class Layout < Fog::Ecloud::Model
        identity :href

        attribute :type, :aliases => :Type
        attribute :other_links, :aliases => :Links

        def rows
          @rows ||= self.service.rows(:href => href)
        end

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
