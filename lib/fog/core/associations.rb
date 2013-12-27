module Fog
  module Core
    module Associations

      def included(base)
        base.extend(ClassMethods)
      end

      def initialze(new_attributes = {})
        @assotiations_attributes = assotiations_names.map { |name| new_attributes.delete(name) }.collect
        # @assotiations_attributes 
        super(new_attributes)
      end

      module ClassMethods

        def has_many(assotiation_name, options = {})
          associciation_alias_name = options[:alias] || assotiation_name
          define_method assotiation_name do |variable|
            result = instance_variable_get :"@#{assotiation_name}"
            if result.nil?
              attributes = @assotiations_attributes[associciation_alias_name] || []
              result = attributes.map { |a| collection.new(associciation_model_class) }
              instance_variable_set :"@#{assotiation_name}", result
            end
            result
          end
        end

        def belongs_to(model_name, options = {})
          # wip
        end
        
      end
    end
  end
end
