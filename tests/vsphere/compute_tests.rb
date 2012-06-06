Shindo.tests('Fog::Compute[:vsphere]', ['vsphere']) do

  require 'rbvmomi'
  require 'fog'
  compute = Fog::Compute[:vsphere]

  tests("| convert_vm_mob_ref_to_attr_hash") do
    # Mock the RbVmomi::VIM::ManagedObject class
    class MockManagedObject

      attr_reader :parent, :_ref

      def initialize
        @parent = @_ref = 'vm-123'
      end

      def collect! *pathSet
        { '_ref' => 'vm-123', 'name' => 'fakevm' }
      end
    end

    fake_vm_mob_ref = MockManagedObject.new

    tests("When converting an incomplete vm object") do
      test("it should return a Hash") do
        compute.convert_vm_mob_ref_to_attr_hash(fake_vm_mob_ref).kind_of? Hash
      end
      tests("The converted Hash should") do
        attr_hash = compute.convert_vm_mob_ref_to_attr_hash(fake_vm_mob_ref)
        test("have a name") { attr_hash['name'] == 'fakevm' }
        test("have a mo_ref") {attr_hash['mo_ref'] == 'vm-123' }
        test("have an id") { attr_hash['id'] == 'vm-123' }
        test("not have a instance_uuid") { attr_hash['instance_uuid'].nil? }
      end
    end

    tests("When passed a nil object") do
      attr_hash = compute.convert_vm_mob_ref_to_attr_hash(nil)
      test("it should return a nil object") do
        attr_hash.nil?
      end
    end
  end

  tests("| ct_mob_ref_to_attr_hash") do
    # adopt a real test bed of VSphere cloud
    class ConstClass
      DC_NAME = 'datacenter'# name reffing to datacenter in test bed
      ATR_DC_NAME = 'DC' # refer to datacenter attribute bean type
      CS_NAME = 'cluster01' # name reffing to a cluster sits in above datacenter
      ATR_CS_NAME = 'CS' # refer to cluster attribute bean type
      RP_NAME = 'test' # name reffing to a resource pool belong to above cluster
      ATR_RP_NAME = 'RP' # refer to resource pool attribute bean type
      HOST_NAME = 'w1-vhadp-05.eng.vmware.com' # name reffing to host belong to above resource pool
      ATR_HOST_NAME = 'HS' # refer to host attribute bean type
      DATASTORE_NAME = 'datastore01' # name reffing to a data store accesible from above host
      ATR_DS_NAME = 'DS' # refer to host attribute bean type
    end

    tests("When converting an datacenter management object") do
      dc_mob_ref = compute.get_dc_mob_ref_by_path(ConstClass::DC_NAME)
      test("it should return a Hash") do
        compute.ct_mob_ref_to_attr_hash(dc_mob_ref, ConstClass::ATR_DC_NAME).kind_of? Hash
      end
      tests("The converted Hash should") do
        attr_hash = compute.ct_mob_ref_to_attr_hash(dc_mob_ref, ConstClass::ATR_DC_NAME)
        test("have a name") { attr_hash['name'] == ConstClass::DC_NAME }
        test("have a mo_ref") {attr_hash['mo_ref'] == dc_mob_ref._ref.to_s }
        test("have an id") { attr_hash['id'] == dc_mob_ref._ref.to_s }
      end

      tests("When converting an cluster management object") do
        response = compute.get_clusters_by_dc_mob(dc_mob_ref)
        cs_mob_ref = response.find {|c| c.name == ConstClass::CS_NAME }
        test("it should return a Hash") do
          compute.ct_mob_ref_to_attr_hash(cs_mob_ref, ConstClass::ATR_CS_NAME).kind_of? Hash
        end
        tests("The converted Hash should") do
          attr_hash = compute.ct_mob_ref_to_attr_hash(cs_mob_ref, ConstClass::ATR_CS_NAME)
          %w{ name eff_mem max_mem }.each do |key|
            test("have a #{key} key") { attr_hash.has_key? key }
          end
        end

        tests("When converting an resource pool management object") do
          response = compute.get_rps_by_cs_mob(cs_mob_ref)
          rp_mob_ref = response.find {|r| r.name == ConstClass::RP_NAME }
          test("it should return a Hash") do
            compute.ct_mob_ref_to_attr_hash(rp_mob_ref, ConstClass::ATR_RP_NAME).kind_of? Hash
          end
          tests("The converted Hash should") do
            attr_hash = compute.ct_mob_ref_to_attr_hash(rp_mob_ref, ConstClass::ATR_RP_NAME)
            %w{ name limit_cpu limit_mem shares config_mem rev_used_mem used_cpu host_used_mem guest_used_mem  }.each do |key|
              test("have a #{key} key") { attr_hash.has_key? key }
            end
          end
        end

        tests("When converting an host management object") do
          response = compute.get_hosts_by_cs_mob(cs_mob_ref)
          host_mob_ref = response.find {|h| h.name == ConstClass::HOST_NAME }
          test("it should return a Hash") do
            compute.ct_mob_ref_to_attr_hash(host_mob_ref, ConstClass::ATR_HOST_NAME).kind_of? Hash
          end
          tests("The converted Hash should") do
            attr_hash = compute.ct_mob_ref_to_attr_hash(host_mob_ref, ConstClass::ATR_HOST_NAME)
            %w{ name total_memory cpu_num cpu_mhz used_cpu used_mem connection_state }.each do |key|
              test("have a #{key} key") { attr_hash.has_key? key }
            end
          end
        end

        tests("When converting an datastore management object") do
          response = compute.get_datastores_by_cs_mob(cs_mob_ref)
          host_mob_ref = response.find {|d| d.name == ConstClass::DATASTORE_NAME }
          test("it should return a Hash") do
            compute.ct_mob_ref_to_attr_hash(host_mob_ref, ConstClass::ATR_DS_NAME).kind_of? Hash
          end
          tests("The converted Hash should") do
            attr_hash = compute.ct_mob_ref_to_attr_hash(host_mob_ref, ConstClass::ATR_DS_NAME)
            %w{ name freeSpace capacity }.each do |key|
              test("have a #{key} key") { attr_hash.has_key? key }
            end
          end
        end
      end

    end

    tests("When passed a nil object") do
      attr_hash = compute.ct_mob_ref_to_attr_hash(nil, nil)
      test("it should return a nil object") do
        attr_hash.nil?
      end
    end
  end

  tests("Compute attributes") do
    %w{ vsphere_is_vcenter vsphere_rev vsphere_username vsphere_server }.each do |attr|
      test("it should respond to #{attr}") { compute.respond_to? attr }
    end
  end

  tests("Compute collections") do
    %w{ servers }.each do |collection|
      test("it should respond to #{collection}") { compute.respond_to? collection }
    end
  end
end

