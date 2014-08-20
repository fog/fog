Shindo.tests('Fog::Compute[:vsphere] | get_network request', ['vsphere']) do

  compute = Fog::Compute[:vsphere]


  class DistributedVirtualPortgroup
    attr_accessor :name, :dvs_name

    def initialize attrs
      @name = attrs.fetch(:name)
      @dvs_name = attrs.fetch(:dvs_name)
    end

    def config
      OpenStruct.new( :distributedVirtualSwitch => OpenStruct.new(:name => dvs_name))
    end
  end

  fake_networks = [OpenStruct.new(:name => 'non-dvs'),
                   DistributedVirtualPortgroup.new( :name => 'web1', :dvs_name => 'dvs5'),
                   DistributedVirtualPortgroup.new( :name => 'web1', :dvs_name => 'dvs11'),
                   DistributedVirtualPortgroup.new( :name => 'other', :dvs_name => 'other'),
                  ]


  tests('#choose_finder should') do
    test('choose the network based on network name and dvs name'){
      finder = compute.send(:choose_finder, 'web1', 'dvs11')
      found_network = fake_networks.find{ |n| finder.call(n) }
      found_network.name == 'web1' && found_network.dvs_name == 'dvs11'
    }
    test('choose the network based on network name and any dvs'){
      finder = compute.send(:choose_finder, 'web1', :dvs)
      found_network = fake_networks.find{ |n| finder.call(n) }
      found_network.name == 'web1' && found_network.dvs_name == 'dvs5'
    }
    test('choose the network based on network name only'){
      finder = compute.send(:choose_finder, 'other', nil)
      found_network = fake_networks.find{ |n| finder.call(n) }
      found_network.name == 'other' && found_network.dvs_name == 'other'
    }
    test('choose the network based on network name only for non-dvs'){
      finder = compute.send(:choose_finder, 'non-dvs', nil)
      found_network = fake_networks.find{ |n| finder.call(n) }
      found_network.name == 'non-dvs' && found_network.class.name.to_s == 'OpenStruct'
    }
  end
end
