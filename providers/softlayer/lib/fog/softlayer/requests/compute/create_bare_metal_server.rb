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
        # @option opts [Integer] "processorCoreAmount"
        #   Number of CPU cores provisioned for the VM.
        # @option opts [Integer] "memoryCapacity"
        #   Available RAM for the server in GB.  Valid arguments are 1, 2, 4, 6, 8, 12, 16, 32, 48, 64
        # @option opts [Boolean] "hourlyBillingFlag"
        #   Should the VM be billed hourly or monthly (monthly is less expensive, minimum charge of 1 month).
        # @option opts [Boolean] "localDiskFlag"
        #   Should the root volume be on the machine or on the SAN
        # @option opts [String] "operatingSystemReferenceCode"
        #   A valid SoftLayer operatingSystemReferenceCode string
        # @option opts [Boolean] "dedicatedAccountHostOnlyFlag"
        #   Defaults to false, pass true for a single-tenant VM.
        # @return [Excon::Response]
        def create_bare_metal_server(opts)
          raise ArgumentError, "Fog::Compute::Softlayer#create_bare_metal_server expects argument of type Hash" unless opts.kind_of?(Hash)
          response = Excon::Response.new
          required = %w{hostname domain processorCoreAmount memoryCapacity hourlyBillingFlag operatingSystemReferenceCode}

          begin
            Fog::Softlayer.valid_request?(required, opts) or raise MissingRequiredParameter
            response.status = 200
            # a real response comes back with lots of nil values like this too, it takes 1 - 2 hours for a real VM to provision
            response.body = {
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
          rescue MissingRequiredParameter
            response.status = 500
            response.body = {
                "code" => "SoftLayer_Exception_MissingCreationProperty",
                "error" => "Properties #{required.join(', ')} ALL must be set to create an instance of 'SoftLayer_Hardware'."
            }
          end
          response
        end
      end

      class Real

        def create_bare_metal_server(opts)
          raise ArgumentError, "Fog::Compute::Softlayer#create_bare_metal_server expects argument of type Hash" unless opts.kind_of?(Hash)
          request(:hardware_server, :create_object, :body => opts, :http_method => :POST)
        end

      end
    end
  end
end
