module Fog
  module Service

    def self.extended(other)
      super
      other.module_eval <<-EOS, __FILE__, __LINE__
        class Error < Fog::Errors::Error; end
        class NotFound < Fog::Errors::NotFound; end

        module Collections; end

        def self.new(options={})
          missing = []
          for requirement in requirements
            missing << requirement unless options[requirement]
          end
          unless missing.empty?
            if missing.length == 1
              raise(ArgumentError, [missing.first, "is required for this service"].join(' '))
            else
              raise(ArgumentError, [missing[0...-1].join(", "), 'and', missing[-1], 'are required for this service'].join(' '))
            end
          end

          unless @required
            for model in models
              require [@model_path, model].join('/')
            end
            for request in requests
              require [@request_path, request].join('/')
            end
            @required = true
          end

          if Fog.mocking?
            Mock.new(options)
          else
            Real.new(options)
          end
        end
      EOS
    end

    def model_path(new_path)
      @model_path = new_path
    end

    def model(new_model)
      models << new_model
    end

    def models
      @models ||= []
    end

    def request_path(new_path)
      @request_path = new_path
    end

    def request(new_request)
      requests << new_request
    end

    def requests
      @requests ||= []
    end

    def requires(*args)
      requirements.concat(args)
    end

    def requirements
      @requirements ||= []
    end

    def reset_data(keys=Mock.data.keys)
      Mock.reset_data(keys)
    end

  end
end

