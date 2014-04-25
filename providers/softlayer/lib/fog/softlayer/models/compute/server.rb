#
# Author:: Matt Eldridge (<matt.eldridge@us.ibm.com>)
# © Copyright IBM Corporation 2014.
#
# LICENSE: MIT (http://opensource.org/licenses/MIT)
#
require 'fog/compute/models/server'

module Fog
  module Compute
    class Softlayer

      class Server < Fog::Compute::Server

        identity  :id
        attribute :name,                     :aliases => 'hostname'
        attribute :domain
        attribute :fqdn,                     :aliases => 'fullyQualifiedDomainName'
        attribute :cpu,                      :aliases => ['startCpus', 'processorCoreAmount']
        attribute :ram,                      :aliases => ['maxMemory', 'memory']
        attribute :disk,                     :aliases => ['blockDevices','hardDrives'], :type => :squash
        attribute :private_ip,               :aliases => 'primaryBackendIpAddress'
        attribute :public_ip,                :aliases => 'primaryIpAddress'
        attribute :flavor_id
        attribute :bare_metal,               :aliases => 'bareMetalInstanceFlag'
        attribute :os_code,                  :aliases => 'operatingSystemReferenceCode'
        attribute :image_id,                 :type => :squash
        attribute :ephemeral_storage,        :aliases => 'localDiskFlag'

        # Times
        attribute :created_at,              :aliases => ['createDate', 'provisionDate'], :type => :time
        attribute :last_verified_date,      :aliases => 'lastVerifiedDate', :type => :time
        attribute :metric_poll_date,        :aliases => 'metricPollDate', :type => :time
        attribute :modify_date,             :aliases => 'modifyDate', :type => :time

        # Metadata
        attribute :account_id,              :aliases => 'accountId', :type => :integer
        attribute :datacenter
        attribute :single_tenant,           :aliases => 'dedicatedAccountHostOnlyFlag'
        attribute :global_identifier,       :aliases => 'globalIdentifier'
        attribute :hourly_billing_flag,     :aliases => 'hourlyBillingFlag'


        def initialize(attributes = {})
          super(attributes)
          set_defaults
        end

        def bare_metal?
          bare_metal
        end

        def bare_metal=(set)
          attributes[:bare_metal] = case set
            when true, 'true', 1
              1
            when false, 'false', 0, nil
              0
            else
              raise ArgumentError, ":bare_metal cannot be #{set.class}"
          end
        end

        def bare_metal
          attributes[:bare_metal] === 1 ? true : false
        end

        def image_id=(uuid)
          attributes[:image_id] = {:globalIdentifier => uuid}
        end

        def image_id
          attributes[:image_id][:globalIdentifier] unless attributes[:image_id].nil?
        end

        def ram=(set)
          if set.is_a?(Array) and set.first['hardwareComponentModel']
            set = 1024 * set.first['hardwareComponentModel']['capacity'].to_i
          end
          attributes[:ram] = set
        end

        def name=(set)
          attributes[:hostname] = set
        end

        def name
          attributes[:hostname]
        end

        #def ram
        #
        #end

        def snapshot
          # TODO: implement
        end

        def reboot(use_hard_reboot = true)
          # TODO: implement
        end

        def start
          # TODO: implement

          #requires :identity
          #service.start_server(identity)
          true
        end

        def stop
          # TODO: implement
        end

        def shutdown
          # TODO: implement
        end

        def destroy
          requires :id
          request = bare_metal? ? :delete_bare_metal_server : :delete_vm
          response = service.send(request, self.id)
          response.body
        end

        # Returns the public DNS name of the server
        #
        # @return [String]
        #
        def dns_name
          fqdn
        end

        def state
          if bare_metal?
            service.request(:hardware_server, "#{id}/getServerPowerState").body
          else
            service.request(:virtual_guest, "#{id}/getPowerState").body['name']
          end

        end

        def ready?
          if bare_metal?
            state == "on"
          else
            state == "Running"
          end
        end

        # Creates server
        # * requires attributes: :name, :domain, and :flavor_id OR (:cpu_count && :ram && :disks)
        #
        # @note You should use servers.create to create servers instead calling this method directly
        #
        # * State Transitions
        #   * BUILD -> ACTIVE
        #   * BUILD -> ERROR (on error)
        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?

          data = if bare_metal?
            pre_save
            service.create_bare_metal_server(attributes).body
          else
            pre_save
            service.create_vm(attributes).body
          end
          merge_attributes(data.first)
          true
        end

        def pre_save
          extract_flavor
          validate_attributes
          remap_attributes(attributes, attributes_mapping)
          clean_attributes
        end

        private

        ##
        # Generate mapping for use with remap_attributes
        def attributes_mapping
          common = {
              :hourly_billing_flag => :hourlyBillingFlag,
              :os_code  =>  :operatingSystemReferenceCode,

          }

          conditional = if bare_metal?
            {
              :cpu  =>   :processorCoreAmount,
              :ram  =>   :memoryCapacity,
              :disk =>   :hardDrives,
              :bare_metal => :bareMetalInstanceFlag
            }
          else
            {
              :cpu  =>   :startCpus,
              :ram  =>   :maxMemory,
              :disk =>   :blockDevices,
              :image_id =>  :blockDeviceTemplateGroup,
              :ephemeral_storage => :localDiskFlag,
            }
          end
          common.merge(conditional)
        end

        ##
        # Remove model attributes that aren't expected by the SoftLayer API
        def clean_attributes
          @bare_metal = attributes.delete(:bare_metal)
          attributes.delete(:flavor_id)
          attributes.delete(:ephemeral_storage)
        end


        ##
        # Expand a "flavor" into cpu, ram, and disk attributes
        def extract_flavor
          if attributes[:flavor_id]
            flavor = @service.flavors.get(attributes[:flavor_id])
            flavor.nil? and Fog::Errors::Error.new("Unrecognized flavor in #{self.class}##{__method__}")
            attributes[:cpu] = flavor.cpu
            attributes[:ram] = flavor.ram
            attributes[:disk] = flavor.disk unless attributes[:image_id]
            if bare_metal?
              value = flavor.disk.first['diskImage']['capacity'] < 500 ? 250 : 500
              attributes[:disk] = [{'capacity'=>value}]
              attributes[:ram] = attributes[:ram] / 1024 if attributes[:ram] > 64
            end
          end
        end

        def validate_attributes
          requires :name, :domain, :cpu, :ram
          requires_one :os_code, :image_id
          requires_one :image_id, :disk
          bare_metal? and image_id and raise ArgumentError, "Bare Metal Cloud does not support booting from Image"
        end

        def set_defaults
          attributes[:hourly_billing_flag] = true if attributes[:hourly_billing_flag].nil?
          attributes[:ephemeral_storage] = false if attributes[:ephemeral_storage].nil?
          attributes[:domain] = service.default_domain if attributes[:domain].nil?
        end

      end
    end
  end
end
