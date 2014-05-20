#
# Author:: Matt Eldridge (<matt.eldridge@us.ibm.com>)
# © Copyright IBM Corporation 2014.
#
# LICENSE: MIT (http://opensource.org/licenses/MIT)
#

Shindo.tests("Fog::Compute[:softlayer] | Server model", ["softlayer"]) do
  pending unless Fog.mocking?

  tests("success") do
    vm_opts = {
        :flavor_id => 'm1.small',
        :image_id => '23f7f05f-3657-4330-8772-329ed2e816bc',
        :name => 'test-vm',
        :domain => 'example.com'
    }

    bmc_opts = {
        :flavor_id => 'm1.small',
        :os_code => 'UBUNTU_LATEST',
        :name => 'test-bmc',
        :domain => 'bare-metal-server.com',
        :bare_metal => true
    }

    @vm = Fog::Compute[:softlayer].servers.new(vm_opts)
    @bmc = Fog::Compute[:softlayer].servers.new(bmc_opts)

    ## defaults should be as exactly().timespected
    tests("#hourly_billing_flag") do
      returns(true) { @vm.hourly_billing_flag }
    end

    tests("#ephemeral_storage") do
      returns(false) { @vm.ephemeral_storage }
    end

    ## this should just function as an alias
    tests("#dns_name") do
      returns(@vm.dns_name) { @vm.fqdn }
    end

    tests("#name=") do
      @bmc.name = "new-test-bmc"
      returns(true) { @bmc.name == @bmc.attributes[:hostname] and @bmc.name == "new-test-bmc" }
    end

    tests("#ram=") do
      @bmc.ram = [{'hardwareComponentModel' => { 'capacity' => 4}}]
      returns(4096) { @bmc.ram }
    end

    ## the bare_metal? method should tell the truth
    tests("#bare_metal?") do
      returns(false) { @vm.bare_metal? }
      returns(true) { @bmc.bare_metal? }
    end

    tests("#save") do
      returns(true) { @vm.save }
    end

  end

  tests ("failure") do

    # should not allow a second save
    tests("#save").raises(Fog::Errors::Error) do
      @vm.save
    end

    tests("#destroy").raises(ArgumentError) do
      @bmc.destroy
    end

    @vm.destroy

  end
end
