module Fog
  module Compute
    class Ecloud
      class LoginBanner < Fog::Ecloud::Model
        identity :href

        attribute :display, :aliases => :Display, :type => :boolean
        attribute :text, :aliases => :Text

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
