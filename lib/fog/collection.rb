module Fog
  class Collection < Array

    Array.public_instance_methods(false).each do |method|
      class_eval <<-RUBY
        def #{method}(*args)
          lazy_load
          super
        end
      RUBY
    end

    %w[reject select].each do |method|
      class_eval <<-RUBY
        def #{method}(*args)
          lazy_load
          data = super
          self.class.new(:connection => self.connection).load(data.map {|member| member.attributes})
        end
      RUBY
    end

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

    def self.model(new_model)
      @model = new_model
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

    def connection=(new_connection)
      @connection = new_connection
    end

    def connection
      @connection
    end

    def create(attributes = {})
      object = new(attributes)
      object.save
      object
    end

    def initialize(attributes = {})
      merge_attributes(attributes)
      @loaded = false
    end

    def inspect
      Thread.current[:formatador] ||= Formatador.new
      data = "#{Thread.current[:formatador].indentation}<#{self.class.name}\n"
      Thread.current[:formatador].indent do
        unless self.class.attributes.empty?
          data << "#{Thread.current[:formatador].indentation}"
          data << self.class.attributes.map {|attribute| "#{attribute}=#{send(attribute).inspect}"}.join(",\n#{Thread.current[:formatador].indentation}")
          data << "\n"
        end
        data << "#{Thread.current[:formatador].indentation}["
        unless self.empty?
          data << "\n"
          Thread.current[:formatador].indent do
            data << self.map {|member| member.inspect}.join(",\n")
            data << "\n"
          end
          data << Thread.current[:formatador].indentation
        end
        data << "]\n"
      end
      data << "#{Thread.current[:formatador].indentation}>"
      data
    end

    def load(objects)
      if @loaded
        clear
      end
      @loaded = true
      for object in objects
        self << new(object)
      end
      self
    end

    def model
      self.class.instance_variable_get('@model')
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

    def new(attributes = {})
      model.new(
        attributes.merge!(
          :collection => self,
          :connection => connection
        )
      )
    end

    def reload
      self.clear.concat(all)
    end

    def table(attributes = nil)
      Formatador.display_table(self.map {|instance| instance.attributes}, attributes)
    end

    private

    def lazy_load
      unless @loaded
        self.all
      end
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
