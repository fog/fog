#
# Author:: Matt Eldridge (<matt.eldridge@us.ibm.com>)
# © Copyright IBM Corporation 2014.
#
# LICENSE: MIT (http://opensource.org/licenses/MIT)
#
module Fog
  module Compute
    class Softlayer

      class Mock

        # Launch a single SoftLayer VM.
        #
        # @param [<Hash>] opts
        # @option opts [<Hash>] :body
        #   HTTP request body parameters
        # @option opts [String] "hostname"
        #   VM hostname, should be unique within the domain.
        # @option opts [String] "domain"
        #   VM domain.
        # @option opts [Integer] "startCpus"
        #   Number of CPU cores provisioned for the VM.
        # @option opts [Integer] "maxMemory"
        #   Available RAM for the VM in MB.  Valid arguments are 1024, 2048, 4096, 6144, 8192, 12288, 16384, 32768, 49152, 65536
        # @option opts [Boolean] "hourlyBillingFlag"
        #   Should the VM be billed hourly or monthly (monthly is less expensive, minimum charge of 1 month).
        # @option opts [Boolean] "localDiskFlag"
        #   Should the root volume be on the machine or on the SAN
        # @option opts [String] "operatingSystemReferenceCode"
        #   A valid SoftLayer operatingSystemReferenceCode string
        # @option opts [Boolean] "dedicatedAccountHostOnlyFlag"
        #   Defaults to false, pass true for a single-tenant VM.
        # @return [Excon::Response]
        def create_vm(opts)
          raise ArgumentError, "Fog::Compute::Softlayer#create_vm expects argument of type Hash" unless opts.kind_of?(Hash)
          opts = [opts]
          self.create_vms(opts)
        end

      end

      class Real
        def create_vm(opts)
          raise ArgumentError, "Fog::Compute::Softlayer#create_vm expects argument of type Hash" unless opts.kind_of?(Hash)
          opts = [opts]
          self.create_vms(opts)
        end
      end
    end
  end
end
