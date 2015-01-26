module Fog
  module Rackspace
    class Orchestration
      class Template < Fog::Model

        %w{description heat_template_version parameters resources}.each do |a|
          attribute a.to_sym
        end

      end
    end
  end
end
