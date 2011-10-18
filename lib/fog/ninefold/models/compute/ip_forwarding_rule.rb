require 'fog/core/model'

module Fog
  module Compute
    class Ninefold

      class IpForwardingRule < Fog::Model

        identity  :id

        attribute :protocol
        attribute :virtualmachineid
        attribute :virtualmachinename
        attribute :ipaddressid
        attribute :ipaddress
        attribute :startport
        attribute :endport
        attribute :state

        attribute :jobid

        def initialize(attributes={})
          super
        end

        def destroy
          requires :identity
          self.jobid = extract_job_id(connection.delete_ip_forwarding_rule(:id => identity))
          true
        end

        def ready?
          if jobid && connection.query_async_job_result(:jobid => jobid)['jobstatus'] == 0
            false
          else # No running job, we are ready. Refresh data.
            reload
            true
          end
        end

        def address
          Ninefold.address.get(ipaddressid)
        end

        def address=(addr)
          self.ipaddressid = addr.identity
        end

        def save
          raise "Operation not supported" if self.identity
          requires :ipaddressid
          requires :protocol
          requires :startport

          options = {
            :ipaddressid => ipaddressid,
            :protocol => protocol,
            :startport => startport,
            :endport => endport
          }.delete_if {|k,v| v.nil? || v == "" }
          data = connection.create_ip_forwarding_rule(options)
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
