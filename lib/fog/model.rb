module Fog
  class Model

    def self._load(marshalled)
      new(Marshal.load(marshalled))
    end

    def self.aliases
      @aliases ||= {}
    end

    def self.attributes
      @attributes ||= []
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

    def _dump
      Marshal.dump(attributes)
    end

    attr_accessor :connection

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

    def identity
      send(self.class.instance_variable_get('@identity'))
    end

    def identity=(new_identity)
      send("#{identity}=", new_identity)
    end

    def initialize(new_attributes = {})
      merge_attributes(new_attributes)
    end

    def inspect
      Thread.current[:formatador] ||= Formatador.new
      data = "#{Thread.current[:formatador].indentation}<#{self.class.name}"
      Thread.current[:formatador].indent do
        unless self.class.attributes.empty?
          data << "\n#{Thread.current[:formatador].indentation}"
          data << self.class.attributes.map {|attribute| "#{attribute}=#{send(attribute).inspect}"}.join(",\n#{Thread.current[:formatador].indentation}")
        end
      end
      data << "\n#{Thread.current[:formatador].indentation}>"
      data
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
      if data = collection.get(identity)
        new_attributes = data.attributes
        merge_attributes(new_attributes)
        self
      end
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

    def to_json
      attributes.to_json
    end

    def wait_for(timeout = 600, &block)
      reload
      Fog.wait_for(timeout) { reload && instance_eval(&block) }
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
