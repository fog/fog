require 'fog/model'

module Fog
  module Bluebox

    class BlockInstantiationError < StandardError; end

    class Server < Fog::Model

      identity :id

      attribute :memory
      attribute :storage
      attribute :hostname
      attribute :cpu
      attribute :ips
      attribute :status
      attribute :flavor_id
      attribute :image_id

      # Not reported by the API, but used at create time
      attr_accessor :name, :password, :hash, :text, :error

      def destroy
        requires :id
        connection.destroy_block(@id)
        true
      end

      def flavor
        requires :flavor_id
        connection.flavors.get(@flavor_id)
      end

      def image
        requires :image_id
        connection.images.get(@image_id)
      end

      def ready?
        @status == 'running'
      end

      def reboot(type = 'SOFT')
        requires :id
        connection.reboot_block(@id, type)
        true
      end

      def save
        requires :flavor_id, :image_id, :name, :password
        data = connection.create_block(@flavor_id, @image_id, @name, @password)
        merge_attributes(data.body)
        true
      end
    end

  end
end
