require 'fog/compute/models/server'

module Fog
  module Compute
    class Linode
      class Server < Fog::Compute::Server
        attr_reader :stack_script
        identity :id
        attribute :name
        attribute :status

        def initialize(attributes={})
          super
          self.username = 'root'
        end

        def ips
          Fog::Compute::Linode::Ips.new :server => self, :service => service
        end

        def public_ip_address
          ips.find{|ip| ip.ip !~ /^192\.168\./}.ip
        end

        def disks
          Fog::Compute::Linode::Disks.new :server => self, :service => service
        end

        def disks?
          not disks.empty?
        end

        def reboot
          service.linode_reboot id
        end

        def shutdown
          service.linode_shutdown id
        end

        def boot
          service.linode_boot id, config
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?
          @data_center, @flavor, @image, @kernel, @type, @payment_terms, @stack_script, @name, @password, @callback =
            attributes.values_at :data_center, :flavor, :image, :kernel, :type, :payment_terms, :stack_script, :name, :password, :callback

          create_linode
          @callback.call self if @callback
          create_disks
          create_config
          boot_linode
          self
        rescue Exception => ex
          destroy if id
          raise ex
        end

        def destroy
          requires :identity
          service.linode_shutdown id
          disks.each { |disk| disk.destroy }
          wait_for { not disks? }
          service.linode_delete id
        end

        def ready?
          status == 1
        end

        private
        def config
          service.linode_config_list(id).body['DATA'].first['ConfigID']
        end

        def create_linode
          self.id = service.linode_create(@data_center.id, @flavor.id, @payment_terms).body['DATA']['LinodeID']
          service.linode_update id, :label => @name
          ips.create
          reload
        end

        def create_disks
          @swap = disks.create :type => :swap, :name => @name, :size => 256
          @disk = disks.create(:type => @type, :image => @image, :stack_script => @stack_script,
                               :password => @password, :name => @name, :size => (@flavor.disk*1024)-256)
        end

        def create_config
          @config = service.linode_config_create(id, @kernel.id, @name, "#{@disk.id},#{@swap.id},,,,,,,").body['DATA']['ConfigID']
        end

        def boot_linode
          service.linode_boot id, @config
        end
      end
    end
  end
end
