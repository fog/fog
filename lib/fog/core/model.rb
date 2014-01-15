require "fog/core/deprecated_connection_accessors"

module Fog
  class Model

    extend Fog::Attributes::ClassMethods
    include Fog::Attributes::InstanceMethods
    include Fog::Core::DeprecatedConnectionAccessors

    attr_accessor :collection
    attr_reader :service

    def initialize(new_attributes = {})
      # TODO Remove compatibility with old connection option
      @service = new_attributes.delete(:service)
      if @service.nil? && new_attributes[:connection]
        Fog::Logger.deprecation("Passing :connection option is deprecated, use :service instead [light_black](#{caller.first})[/]")
        @service = new_attributes[:connection]
      end
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
      Fog::JSON.encode(attributes)
    end

    def symbolize_keys(hash)
      return nil if hash.nil?
      hash.inject({}) do |options, (key, value)|
        options[(key.to_sym rescue key) || key] = value
        options
      end
    end

    def wait_for(timeout=Fog.timeout, interval=1, &block)
      reload_has_succeeded = false
      duration = Fog.wait_for(timeout, interval) do # Note that duration = false if it times out
        if reload
          reload_has_succeeded = true
          instance_eval(&block)
        else
          false
        end
      end
      if reload_has_succeeded
        return duration # false if timeout; otherwise {:duration => elapsed time }
      else
        raise Fog::Errors::Error.new("Reload failed, #{self.class} #{self.identity} not present.")
      end
    end

  end
end
