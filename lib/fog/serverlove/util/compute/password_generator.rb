module Fog
  module Compute
    class Serverlove
      class PasswordGenerator
        def self.generate
          ('a'...'z').to_a.concat(('A'...'Z').to_a).shuffle[0,8].join
        end
      end
    end
  end
end
