## Note:
# If needed, these tests will create a new VM and public IP address. Because this is expensive, you
# can optionally specify VM_ID and IP_ID as environment variables, and we will use those. Note:
# The IP must not already have static nat enabled or any port mappings.

Shindo.tests('Fog::Compute[:ninefold] | nat requests', ['ninefold']) do

  if ENV['VM_ID'] && ENV['IP_ID']
    @ipid, @vmid = ENV['IP_ID'], ENV['VM_ID']
  elsif !Fog.mock?
    begin
      # Create a VM to work with
      networks = Fog::Compute[:ninefold].list_networks
      vm_job = Fog::Compute[:ninefold].deploy_virtual_machine(:serviceofferingid => Ninefold::Compute::TestSupport::SERVICE_OFFERING,
                                                         :templateid => Ninefold::Compute::TestSupport::TEMPLATE_ID,
                                                         :zoneid => Ninefold::Compute::TestSupport::ZONE_ID,
                                                         :networkids => networks[0]['id'])
      @vm = Ninefold::Compute::TestSupport.wait_for_job(vm_job)['jobresult']['virtualmachine']
      @vmid = @vm['id']

      # Allocate a public IP to work with
      ip_job = Fog::Compute[:ninefold].associate_ip_address(:zoneid => Ninefold::Compute::TestSupport::ZONE_ID)
      @ip = Ninefold::Compute::TestSupport.wait_for_job(ip_job)['jobresult']['ipaddress']
      @ipid = @ip['id']
    rescue => e
      puts "*** CREATING VM OR IP FAILED - PLEASE TEST AND CORRECT THIS FIRST"
      raise e
    end
  end

  tests('success') do

    tests("#enable_static_nat()").formats(Ninefold::Compute::Formats::Nat::ENABLE_NAT_RESPONSE) do
      pending if Fog.mocking?
      Fog::Compute[:ninefold].enable_static_nat(:ipaddressid => @ipid, :virtualmachineid => @vmid)
    end

    tests("#create_ip_forwarding_rule()").formats(Ninefold::Compute::Formats::Nat::FORWARDING_RULE) do
      pending if Fog.mocking?
      job = Fog::Compute[:ninefold].create_ip_forwarding_rule(:ipaddressid => @ipid,
                                                         :protocol => 'TCP',
                                                         :startport => 22)
      result = Ninefold::Compute::TestSupport.wait_for_job(job)['jobresult']['ipforwardingrule']
      @fwd_rule_id = result['id']
      result
    end

    tests("#list_ip_forwarding_rules()").formats(Ninefold::Compute::Formats::Nat::FORWARDING_RULES) do
      pending if Fog.mocking?
      Fog::Compute[:ninefold].list_ip_forwarding_rules
    end

    tests("#delete_ip_forwarding_rule()").formats(Ninefold::Compute::Formats::Nat::DELETE_RULE_RESPONSE) do
      pending if Fog.mocking?
      job = Fog::Compute[:ninefold].delete_ip_forwarding_rule(:id => @fwd_rule_id)
      Ninefold::Compute::TestSupport.wait_for_job(job)['jobresult']
    end


    tests("#disable_static_nat()").formats(Ninefold::Compute::Formats::Nat::DISABLE_NAT_RESPONSE) do
      pending if Fog.mocking?
      job = Fog::Compute[:ninefold].disable_static_nat(:ipaddressid => @ipid)
      Ninefold::Compute::TestSupport.wait_for_job(job)['jobresult']
    end

  end

  tests('failure') do

    tests("#associate_ip_address()").raises(Excon::Errors::HTTPStatusError) do
      pending if Fog.mocking?
      Fog::Compute[:ninefold].associate_ip_address
    end

  end

  unless ENV['VM_ID'] && ENV['IP_ID'] || Fog.mock?
    begin
      # Kill test VM
      vm_job = Fog::Compute[:ninefold].destroy_virtual_machine(:id => @vmid)
      Ninefold::Compute::TestSupport.wait_for_job(vm_job)

      # Disassociate public IP
      ip_job = Fog::Compute[:ninefold].disassociate_ip_address(:id => @ipid)
      Ninefold::Compute::TestSupport.wait_for_job(ip_job)
    rescue => e
      puts "*** DESTROYING VM OR IP FAILED - PLEASE TEST AND CORRECT THIS FIRST"
      raise e
    end
  end

end
