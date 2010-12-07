module Fog
  class Service

    class Error < Fog::Errors::Error; end
    class NotFound < Fog::Errors::NotFound; end

    module Collections

      def collections
        service.collections
      end

      def requests
        service.requests
      end

    end

    class << self

      # this is to accomodate Real implementations of Service subclasses
      # NOTE: it might be good to enforce parameter specs to Mock classes as well.
      def inject_parameter_specs
        lambda do |spec|
          implementation = "Real"
          self.const_set(implementation, Class.new) unless self.const_defined? implementation
          realclass = self.const_get implementation

          if realclass.declared_parameters_for(:'self.new', :required).empty?
            required = declared_parameters_for(:'self.new', :required)
            realclass.send(:requires, *required)
          end
        
          if realclass.declared_parameters_for(:'self.new', :optional).empty?
            optional = declared_parameters_for(:'self.new', :optional)
            realclass.send(:recognizes, *optional) 
          end
        end
      end

      def inherited(child)
        child.class_eval <<-EOS, __FILE__, __LINE__
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

      def requirements
        declared_parameters_for :'self.new', :required
      end

      def new(options={})
        if Fog.bin
          default_credentials = filter_parameters(Fog.credentials)
          options = default_credentials.merge(options)
        end

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

      def reset_data(keys=Mock.data.keys)
        Mock.reset_data(keys)
      end

    end

  end
end

