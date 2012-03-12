module Fog
  class Model

    extend Fog::Attributes::ClassMethods
    include Fog::Attributes::InstanceMethods

    attr_accessor :collection, :connection

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

    def reload
      requires :identity

      return unless data = begin
        collection.get(identity)
      rescue Excon::Errors::SocketError
        nil
      end

      new_attributes = data.attributes
      merge_attributes(new_attributes)
      self
    end

    def to_json(options = {})
      require 'multi_json'
      MultiJson.encode(attributes)
    end

    def symbolize_keys(hash)
      return nil if hash.nil?
      hash.inject({}) do |options, (key, value)|
        options[(key.to_sym rescue key) || key] = value
        options
      end
    end

    def wait_for(timeout=Fog.timeout, interval=1, &block)
      reload
      retries = 3
      Fog.wait_for(timeout, interval) do
        if reload
          retries = 3
        elsif retries > 0
          retries -= 1
          sleep(1)
        elsif retries == 0
          raise Fog::Errors::Error.new("Reload failed, #{self.class} #{self.identity} went away.")
        end
        instance_eval(&block)
      end
    end

  end
end
