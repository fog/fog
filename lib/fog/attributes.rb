module Fog
  module Attributes
    module ClassMethods

      def _load(marshalled)
        new(Marshal.load(marshalled))
      end

      def aliases
        @aliases ||= {}
      end

      def attributes
        @attributes ||= []
      end

      def attribute(name, other_names = [])
        class_eval <<-EOS, __FILE__, __LINE__
          attr_accessor :#{name}
        EOS
        @attributes ||= []
        @attributes |= [name]
        for other_name in [*other_names]
          aliases[other_name] = name
        end
      end

      def identity(name, other_names = [])
        @identity = name
        self.attribute(name, other_names)
      end

    end

    module InstanceMethods

      def _dump
        Marshal.dump(attributes)
      end

      def attributes
        attributes = {}
        for attribute in self.class.attributes
          attributes[attribute] = send("#{attribute}")
        end
        attributes
      end

      def identity
        send(self.class.instance_variable_get('@identity'))
      end

      def identity=(new_identity)
        send("#{self.class.instance_variable_get('@identity')}=", new_identity)
      end

      def merge_attributes(new_attributes = {})
        for key, value in new_attributes
          if aliased_key = self.class.aliases[key]
            send("#{aliased_key}=", value)
          else
            send("#{key}=", value)
          end
        end
        self
      end

      def new_record?
        !identity
      end

      def requires(*args)
        missing = []
        for arg in [:connection] | args
          missing << arg unless send("#{arg}")
        end
        unless missing.empty?
          if missing.length == 1
            raise(ArgumentError, "#{missing.first} is required for this operation")
          else
            raise(ArgumentError, "#{missing[0...-1].join(", ")} and #{missing[-1]} are required for this operation")
          end
        end
      end

      private

      def remap_attributes(attributes, mapping)
        for key, value in mapping
          if attributes.key?(key)
            attributes[value] = attributes.delete(key)
          end
        end
      end

    end
  end
end
