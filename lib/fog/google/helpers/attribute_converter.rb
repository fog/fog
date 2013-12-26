
module Fog
  module Compute
    class Google
      module AttributeConverter

        def self.included(base)
          base.extend(ClassMethods)
        end 

        module ClassMethods

          def convert_attribute(attribute_name)
            alias_method :"old #{attribute_name}=", :"#{attribute_name}="
            define_method :"#{attribute_name}=" do |value|
              self.send :"old #{attribute_name}=", self.convert_attribute(value)
            end
          end

        end

        def convert_attribute(value)
          index = value.rindex('/')
          index.nil? ? value : value[(index + 1)..-1]
        end

      end
    end
  end
end
