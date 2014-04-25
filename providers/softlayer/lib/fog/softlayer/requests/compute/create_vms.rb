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

        # Launch one or more SoftLayer VMs.
        #
        # @param [Array<Hash>] opts
        # @option opts [Array<Hash>] :body
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
        def create_vms(opts)
          raise ArgumentError, "Fog::Compute::Softlayer#create_vms expects argument of type Array" unless opts.kind_of?(Array)
          response = Excon::Response.new
          required = %w{hostname domain startCpus maxMemory hourlyBillingFlag localDiskFlag}

          begin
            opts.each {|vm| Fog::Softlayer.valid_request?(required, vm) or raise MissingRequiredParameter}
            response.status = 200
            response.body = []

            ## stub some responses
            fields = {
                "accountId" =>  Fog::Softlayer.mock_account_id,
                "createDate" => Time.now.iso8601,
                "dedicatedAccountHostOnlyFlag" => false,
                "domain" => nil,
                "fullyQualifiedDomainName" => nil,
                "hostname" => nil,
                "id" => Fog::Softlayer.mock_vm_id,
                "lastPowerStateId" => nil,
                "lastVerifiedDate" => nil,
                "maxCpu" => nil,
                "maxCpuUnits" => "CORE",
                "maxMemory" => nil,
                "metricPollDate" => nil,
                "modifyDate" => nil,
                "startCpus" => nil,
                "statusId" => 1001,
                "globalIdentifier" => Fog::Softlayer.mock_global_identifier
            }

            # clobber stubbed values where applicable
            response.body = opts.each_with_index.map do |vm,i|
              fields.reduce({}) do |result,(field,default)|
                result[field] = vm[field] || default
                result
              end
            end
          rescue MissingRequiredParameter
            response.status = 500
            response.body = {
                "code" => "SoftLayer_Exception_MissingCreationProperty",
                "error" => "Properties #{required.join(', ')} ALL must be set to create an instance of 'SoftLayer_Virtual_Guest'."
            }
          end
          @virtual_guests.push(response.body).flatten!
          response
        end

      end

      class Real
        def create_vms(opts)
          raise ArgumentError, "Fog::Compute::Softlayer#create_vms expects argument of type Array" unless opts.kind_of?(Array)
          request(:virtual_guest, :create_objects, :body => opts, :http_method => :POST)
        end
      end
    end
  end
end
