require 'fog/compute/models/server'

module Fog
  module Compute
    class Ninefold

      class Server < Fog::Compute::Server
        extend Fog::Deprecation
        deprecate :serviceofferingid, :flavor_id
        deprecate :templateid,        :image_id

        identity  :id

        attribute :account
        attribute :cpunumber
        attribute :cpuspeed

        attribute :cpuused
        attribute :created,             :type => :time
        attribute :displayname
        attribute :domain
        attribute :domainid
        attribute :flavor_id,           :aliases => :serviceofferingid
        attribute :forvirtualnetwork
        attribute :group
        attribute :groupid
        attribute :guestosid
        attribute :haenable
        attribute :hostid
        attribute :hostname
        attribute :hypervisor
        attribute :image_id,            :aliases => :templateid
        #attribute :ipaddress
        attribute :isodisplaytext
        attribute :isoid
        attribute :isoname
        attribute :jobid
        attribute :jobstatus
        attribute :memory
        attribute :name
        attribute :networkkbsread
        attribute :networkkbswrite
        attribute :nic
        attribute :password
        attribute :passwordenabled
        attribute :rootdeviceid
        attribute :rootdevicetype
        attribute :securitygroup
        attribute :serviceofferingname
        attribute :state
        attribute :templatedisplaytext
        attribute :templatename
        attribute :zoneid
        attribute :zonename

        # used for creation only.
        attribute :networkids
        attribute :diskofferingid
        attribute :keypair
        attribute :securitygroupids
        attribute :size
        attribute :userdata

        #attribute :account_id, :aliases => "account", :squash => "id"
        #attribute :image_id, :aliases => "image", :squash => "id"
        #attribute :flavor_id, :aliases => "server_type", :squash => "id"
        #attribute :zone_id, :aliases => "zone", :squash => "id"


        def initialize(attributes={})
          merge_attributes({
            :flavor_id => 105, # '1CPU, 384MB, 80GB HDD'
            :image_id  => 421  # 'XEN Basic Ubuntu 10.04 Server x64 PV r2.0'
          })
          super
        end

        # This is temporary - we need to model nics.
        def ipaddress
          nic[0] ? nic[0]['ipaddress'] : nil
        end

        def reboot
          requires :identity
          self.jobid = extract_job_id(connection.reboot_virtual_machine(:id => identity))
          puts "jobid: " + jobid.to_s
          true
        end

        def start
          requires :identity
          self.jobid = extract_job_id(connection.start_virtual_machine(:id => identity))
          true
        end

        def stop
          requires :identity
          self.jobid = extract_job_id(connection.stop_virtual_machine(:id => identity))
          true
        end

        def destroy
          requires :identity
          self.jobid = extract_job_id(connection.destroy_virtual_machine(:id => identity))
          true
        end

        def flavor
          requires :flavor_id
          connection.flavors.get(flavor_id)
        end

        def image
          requires :image_id
          connection.images.get(image_id)
        end

        def ready?
          if jobid
            # we do this by polling the last job id status.
            res = connection.query_async_job_result(:jobid => jobid)
            if res['jobstatus'] == 0
              false
            else
              # update with new values.
              merge_attributes(res['jobresult']['virtualmachine'])
              true
            end
          else # No running job, we are ready. Refresh data.
            reload
            true
          end
        end

        def save
          raise "Operation not supported" if self.identity
          requires :flavor_id, :image_id, :zoneid

          unless networkids
            # No network specified, use first in this zone.
            networks = connection.list_networks(:zoneid => zoneid)
            if networks.empty?
              raise "No networks. Please create one, or specify a network ID"
            else
              # use the network with the lowest ID - the safe default
              self.networkids = networks.sort {|x,y| x['id'] <=> y['id']}[0]['id']
            end
          end

          options = {
            :serviceofferingid => flavor_id,
            :templateid => image_id,
            :name => name,
            :zoneid => zoneid,
            :networkids => networkids,
            :account => account,
            :diskofferingid => diskofferingid,
            :displayname => displayname,
            :domainid => domainid,
            :group => group,
            :hypervisor => hypervisor,
            :keypair => keypair,
            :securitygroupids => securitygroupids,
            :size => size,
            :userdata => userdata
          }.delete_if {|k,v| v.nil? || v == "" }
          data = connection.deploy_virtual_machine(options)
          merge_attributes(data)
          true
        end

        private

        def extract_job_id(job)
          if job.kind_of? Integer
            job
          else
            job['jobid'] || job['id']
          end
        end

      end
    end
  end
end
