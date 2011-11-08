module Fog

  def self.services
    @services ||= {}
  end

  class Service

    class Error < Fog::Errors::Error; end
    class NotFound < Fog::Errors::NotFound; end

    module Collections

      def collections
        service.collections
      end

      def mocked_requests
        service.mocked_requests
      end

      def requests
        service.requests
      end

    end

    class << self

      def inherited(child)
        child.class_eval <<-EOS, __FILE__, __LINE__
          class Error < Fog::Service::Error; end
          class NotFound < Fog::Service::NotFound; end

          module Collections
            include Fog::Service::Collections

            def service
              #{child}
            end
          end

          def self.service
            #{child}
          end
        EOS
      end

      def new(options={})
        # attempt to load credentials from config file
        begin
          default_credentials = Fog.credentials.reject {|key, value| !(recognized | requirements).include?(key)}
          options = default_credentials.merge(options)
        rescue LoadError
          # if there are no configured credentials, do nothing
        end

        validate_options(options)
        coerce_options(options)
        setup_requirements

        if Fog.mocking?
          service::Mock.send(:include, service::Collections)
          service::Mock.new(options)
        else
          service::Real.send(:include, service::Collections)
          service::Real.new(options)
        end
      end

      def setup_requirements
        if superclass.respond_to?(:setup_requirements)
          superclass.setup_requirements
        end

        @required ||= false
        unless @required
          for collection in collections
            require [@model_path, collection].join('/')
            constant = collection.to_s.split('_').map {|characters| characters[0...1].upcase << characters[1..-1]}.join('')
            service::Collections.module_eval <<-EOS, __FILE__, __LINE__
              def #{collection}(attributes = {})
                #{service}::#{constant}.new({:connection => self}.merge(attributes))
              end
            EOS
          end
          for model in models
            require [@model_path, model].join('/')
          end
          for request in requests
            require [@request_path, request].join('/')
            if service::Mock.method_defined?(request)
              mocked_requests << request
            else
              service::Mock.module_eval <<-EOS, __FILE__, __LINE__
                def #{request}(*args)
                  Fog::Mock.not_implemented
                end
              EOS
            end
          end
          @required = true
        end
      end

      def model_path(new_path)
        @model_path = new_path
      end

      def collection(new_collection)
        collections << new_collection
      end

      def collections
        @collections ||= []
      end

      def coerce_options(options)
        options.each do |key, value|
          value_string = value.to_s.downcase
          if value.nil?
            options.delete(key)
          elsif value == value_string.to_i.to_s
            options[key] = value.to_i
          else
            options[key] = case value_string
            when 'false'
              false
            when 'true'
              true
            else
              value
            end
          end
        end
      end

      def mocked_requests
        @mocked_requests ||= []
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

      def recognizes(*args)
        recognized.concat(args)
      end

      def recognized
        @recognized ||= [:connection_options]
      end

      def validate_options(options)
        keys = []
        for key, value in options
          unless value.nil?
            keys << key
          end
        end
        missing = requirements - keys
        unless missing.empty?
          raise ArgumentError, "Missing required arguments: #{missing.join(', ')}"
        end

        unless recognizes.empty?
          unrecognized = options.keys - requirements - recognized
          unless unrecognized.empty?
            raise ArgumentError, "Unrecognized arguments: #{unrecognized.join(', ')}"
          end
        end
      end

    end

  end
end

