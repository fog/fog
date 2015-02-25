require 'fog/core/model'

module Fog
  module Orchestration
    class OpenStack
      class Template < Fog::Model

        %w{format description template_version parameters resources content}.each do |a|
          attribute a.to_sym
        end

      end
    end
  end
end
