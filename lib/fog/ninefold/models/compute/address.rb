require 'fog/core/model'

module Fog
  module Compute
    class Ninefold

      class Address < Fog::Model

        identity  :id

        attribute :account
        attribute :allocated
        attribute :associatednetworkid
        attribute :domain
        attribute :domainid
        attribute :forvirtualnetwork
        attribute :ipaddress
        attribute :issourcenat
        attribute :isstaticnat
        attribute :jobid
        attribute :jobstatus
        attribute :networkid
        attribute :state
        attribute :virtualmachinedisplayname
        attribute :virtualmachineid
        attribute :virtualmachinename
        attribute :vlanid
        attribute :vlanname
        attribute :zoneid
        attribute :zonename

        def initialize(attributes={})
          super
        end

        def destroy
          requires :identity
          self.jobid = extract_job_id(connection.disassociate_ip_address(:id => identity))
          true
        end

        def enable_static_nat(server)
          server.kind_of?(Integer) ? serverid = server : serverid = server.identity
          res = connection.enable_static_nat(:virtualmachineid => serverid, :ipaddressid => identity)
          reload
          to_boolean(res['success'])
        end

        def disable_static_nat()
          self.jobid = extract_job_id(connection.disable_static_nat(:ipaddressid => identity))
          true
        end

        def reload
          self.virtualmachinedisplayname = nil
          self.virtualmachineid = nil
          self.virtualmachinename = nil
          super
        end

        def ready?
          if jobid && connection.query_async_job_result(:jobid => jobid)['jobstatus'] == 0
            false
          else # No running job, we are ready. Refresh data.
            reload
            true
          end
        end

        def save
          raise "Operation not supported" if self.identity
          requires :zoneid

          options = {
            :zoneid => zoneid,
            :networkid => networkid,
            :account => account,
            :domainid => domainid
          }.delete_if {|k,v| v.nil? || v == "" }
          data = connection.associate_ip_address(options)
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

        # needed to hack around API inconsistencies
        def to_boolean(val)
          val && (val.to_s.match(/(true|t|yes|y|1)$/i) != nil)
        end

      end
    end
  end
end
