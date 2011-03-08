require 'fog/core/model'

module Fog
  module Linode
    class Compute
      class Server < Fog::Model
        attr_reader :stack_script
        identity :id
        attribute :name
        attribute :status

        def ips
          @ips = Fog::Linode::Compute::Ips.new :server => self, :connection => connection
        end

        def disks
          @disks = Fog::Linode::Compute::Disks.new :server => self, :connection => connection
        end

        def disks?
          not disks.empty?
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if identity
          @data_center, @flavor, @image, @type, @payment_terms, @stack_script, @name, @password, @callback =
            attributes.values_at :data_center, :flavor, :image, :type, :payment_terms, :stack_script, :name, :password, :callback

          create_linode
          @callback.call self if @callback
          create_disks
          create_config
          boot_linode
        rescue Exception => ex
          destroy if id
          raise ex
        end

        def destroy
          requires :identity
          connection.linode_shutdown id
          disks.each { |disk| disk.destroy }
          wait_for { not disks? }
          connection.linode_delete id
        end

        private
        def create_linode
          self.id = connection.linode_create(@data_center.id, @flavor.id, @payment_terms).body['DATA']['LinodeID']
          connection.linode_update id, :label => @name
          ips.create
          reload
        end
        
        def create_disks
          @swap = disks.create :type => :swap, :name => @name, :size => @flavor.ram
          @disk = disks.create(:type => @type, :image => @image, :stack_script => @stack_script,
                               :password => @password, :name => @name, :size => (@flavor.disk*1024)-@flavor.ram)
        end

        def create_config
          @config = connection.linode_config_create(id, 110, @name, "#{@disk.id},#{@swap.id},,,,,,,").body['DATA']['ConfigID']
        end

        def boot_linode
          connection.linode_boot id, @config
        end
      end
    end
  end
end
