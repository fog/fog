module Fog
  module Vcloud
    module Extension
      include Fog::Service

      @versions = []

      def self.extended(other)
        other.module_eval <<-EOS,__FILE__,__LINE__
          module #{other}::Real
            extend Fog::Vcloud::Generators
          end
          module #{other}::Mock
          end
            def self.supported_versions
              @versions
            end
          def self.extended(klass)
            unless @required
              models.each do |model|
                require File.join(@model_path, model.to_s)
              end
              requests.each do |request|
                require File.join(@request_path, request.to_s)
              end
              @required = true
            end
            if Fog.mocking?
              klass.extend #{other}::Real
              klass.extend #{other}::Mock
            else
              klass.extend #{other}::Real
            end
          end
        EOS
      end

      def versions(*args)
        @versions = args
      end

    end
  end
end
