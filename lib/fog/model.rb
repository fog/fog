module Fog
  class Model

    def self._load(marshalled)
      new(Marshal.load(marshalled))
    end

    def self.attribute(name, other_names = [])
      class_eval <<-EOS, __FILE__, __LINE__
        attr_accessor :#{name}
      EOS
      @attributes ||= []
      @attributes |= [name]
      for other_name in [*other_names]
        aliases[other_name] = name
      end
    end

    def self.identity(name, other_names = [])
      @identity = name
      self.attribute(name, other_names)
    end

    def self.aliases
      @aliases ||= {}
    end

    def self.attributes
      @attributes ||= []
    end

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

    def collection
      @collection
    end

    def connection=(new_connection)
      @connection = new_connection
    end

    def connection
      @connection
    end

    def identity
      send(self.class.instance_variable_get('@identity'))
    end

    def initialize(new_attributes = {})
      merge_attributes(new_attributes)
    end

    def inspect
      data = "#<#{self.class.name}"
      for attribute in self.class.attributes
        data << " #{attribute}=#{send(attribute).inspect}"
      end
      data << ">"
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

    def reload
      new_attributes = collection.get(identity).attributes
      merge_attributes(new_attributes)
    end

    private

    def collection=(new_collection)
      @collection = new_collection
    end

    def remap_attributes(attributes, mapping)
      for key, value in mapping
        if attributes.key?(key)
          attributes[value] = attributes.delete(key)
        end
      end
    end

  end
end
