module Fog
  class Vcloud < Fog::Service
    class Service < Fog::Service

      class << self

        @versions = []

        def inherited(child)
          super
          child.class_eval <<-EOS, __FILE__, __LINE__
            module #{child}::Real
              extend Fog::Vcloud::Generators
            end
            module #{child}::Mock
            end
          EOS
          child.extend(child::Real)
          if Fog.mocking?
            child.extend(child::Mock)
          end
        end

      end

    end
  end
end
