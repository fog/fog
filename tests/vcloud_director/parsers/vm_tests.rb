require 'fog/xml'
require 'fog/vcloud_director/parsers/compute/vm'

Shindo.tests('Parsers::Compute::VcloudDirector::Vm', ['vclouddirector', 'all']) do
  parser = Nokogiri::XML::SAX::Parser.new(Fog::Parsers::Compute::VcloudDirector::Vm.new)
  vm_response_xml = File.open(File.join(File.dirname(__FILE__), '..', 'fixtures','vm.xml')).read
  parser.parse(vm_response_xml)
  vm = parser.document.response[:vm]

  tests('correctly parses vm xml reponse from a GET') do
    tests('#id').returns('vm-17a2a3a9-248c-475d-8ee0-8dd45f7f8368'){ vm[:id] }
    tests('#ip_address').returns('10.81.196.204'){ vm[:ip_address] }
    tests('#deployed').returns(true){ vm[:deployed] }
    tests('#status').returns('on'){ vm[:status] }
    tests('#name').returns('nas.test.com'){ vm[:name] }
    tests('#type').returns('application/vnd.vmware.vcloud.vm+xml'){ vm[:type] }
    tests('#cpu').returns('1'){ vm[:cpu] }
    tests('#memory').returns('2048'){ vm[:memory] }
    tests('#operating_system').returns('Oracle Linux 4/5/6 (64-bit)'){ vm[:operating_system] }
    tests('#links').returns(false){ vm[:links].empty? }

    tests('#network_adapters').returns(2){ vm[:network_adapters].size }
    
    primary_nic = vm[:network_adapters].select { |nic| nic[:primary] }.first
    tests('#network_adapters:ip_address').returns('192.168.96.10'){ primary_nic[:ip_address] }
    tests('#network_adapters:primary').returns(true){ primary_nic[:primary] }
    tests('#network_adapters:ip_allocation_mode').returns('POOL'){ primary_nic[:ip_allocation_mode] }
    tests('#network_adapters:network').returns('Non-DMZNetwork'){ primary_nic[:network] }

    secondary_nic = vm[:network_adapters].select { |nic| nic[:primary] == false }.first
    tests('#network_adapters:ip_address').returns('10.81.196.204'){ secondary_nic[:ip_address] }
    tests('#network_adapters:primary').returns(false){ secondary_nic[:primary] }
    tests('#network_adapters:ip_allocation_mode').returns('POOL'){ secondary_nic[:ip_allocation_mode] }
    tests('#network_adapters:network').returns('nfs-net-01'){ secondary_nic[:network] }

    tests('#disks').returns(false){ vm[:disks].empty? }
    tests('#disks:0').returns({'Hard disk 1'=>10240}){ vm[:disks][0] }
  end

end

Shindo.tests('Parsers::Compute::VcloudDirector::Vms', ['vclouddirector', 'all']) do
  parser = Nokogiri::XML::SAX::Parser.new(Fog::Parsers::Compute::VcloudDirector::Vms.new)
  vapp_response_xml = File.open(File.join(File.dirname(__FILE__), '..', 'fixtures','vapp.xml')).read
  parser.parse(vapp_response_xml)
  vms = parser.document.response[:vms]

  tests('correctly parses first vm from vapp xml reponse') do
    tests('vms[0]#id').returns('vm-f09c53c0-d0b3-4a31-9c8d-19de2c676e1e'){ vms[0][:id] }
    tests('vms[0]#ip_address').returns('192.168.96.4'){ vms[0][:ip_address] }
    tests('vms[0]#deployed').returns(false){ vms[0][:deployed] }
    tests('vms[0]#status').returns('on'){ vms[0][:status] }
    tests('vms[0]#name').returns('summoning-dark'){ vms[0][:name] }
    tests('vms[0]#type').returns('application/vnd.vmware.vcloud.vm+xml'){ vms[0][:type] }
    tests('vms[0]#cpu').returns('2'){ vms[0][:cpu] }
    tests('vms[0]#memory').returns('2048'){ vms[0][:memory] }
    tests('vms[0]#operating_system').returns('Microsoft Windows Server 2008 R2 (64-bit)'){ vms[0][:operating_system] }
    tests('vms[0]#links').returns(false){ vms[0][:links].empty? }
    tests('vms[0]#network_adapters').returns(false){ vms[0][:network_adapters].empty? }

    tests('#network_adapters').returns(2){ vms[0][:network_adapters].size }
    
    primary_nic = vms[0][:network_adapters].select { |nic| nic[:primary] }.first
    tests('vms[0]#network_adapters:ip_address').returns('192.168.96.4'){ primary_nic[:ip_address] }
    tests('vms[0]#network_adapters:primary').returns(true){ primary_nic[:primary] }
    tests('vms[0]#network_adapters:ip_allocation_mode').returns('POOL'){ primary_nic[:ip_allocation_mode] }
    tests('vms[0]#network_adapters:network').returns('Non-DMZNetwork'){ primary_nic[:network] }

    secondary_nic = vms[0][:network_adapters].select { |nic| nic[:primary] == false }.first
    tests('vms[0]#network_adapters:ip_address').returns('10.81.196.205'){ secondary_nic[:ip_address] }
    tests('vms[0]#network_adapters:primary').returns(false){ secondary_nic[:primary] }
    tests('vms[0]#network_adapters:ip_allocation_mode').returns('POOL'){ secondary_nic[:ip_allocation_mode] }
    tests('vms[0]#network_adapters:network').returns('nfs-net-01'){ secondary_nic[:network] }

    tests('vms[0]#disks').returns(false){ vms[0][:disks].empty? }
    tests('vms[0]#disks:0').returns({'Hard disk 1'=>61440}){ vms[0][:disks][0] }
  end

  tests('correctly parses second vm from vapp xml reponse') do
    tests('vms[1]#id').returns('vm-315485fb-e4a2-4dae-8890-2c21439da1fb'){ vms[1][:id] }
    tests('vms[1]#ip_address').returns('10.81.196.206'){ vms[1][:ip_address] }
    tests('vms[1]#deployed').returns(false){ vms[1][:deployed] }
    tests('vms[1]#status').returns('on'){ vms[1][:status] }
    tests('vms[1]#name').returns('sam-vimes'){ vms[1][:name] }
    tests('vms[1]#type').returns('application/vnd.vmware.vcloud.vm+xml'){ vms[1][:type] }
    tests('vms[1]#cpu').returns('1'){ vms[1][:cpu] }
    tests('vms[1]#memory').returns('2048'){ vms[1][:memory] }
    tests('vms[1]#operating_system').returns('Oracle Linux 4/5/6 (64-bit)'){ vms[1][:operating_system] }
    tests('vms[1]#links').returns(false){ vms[1][:links].empty? }

    tests('#network_adapters').returns(2){ vms[1][:network_adapters].size }
    
    primary_nic = vms[1][:network_adapters].select { |nic| nic[:primary] }.first
    tests('vms[0]#network_adapters:ip_address').returns('192.168.96.5'){ primary_nic[:ip_address] }
    tests('vms[0]#network_adapters:primary').returns(true){ primary_nic[:primary] }
    tests('vms[0]#network_adapters:ip_allocation_mode').returns('POOL'){ primary_nic[:ip_allocation_mode] }
    tests('vms[0]#network_adapters:network').returns('Non-DMZNetwork'){ primary_nic[:network] }

    secondary_nic = vms[1][:network_adapters].select { |nic| nic[:primary] == false }.first
    tests('vms[0]#network_adapters:ip_address').returns('10.81.196.206'){ secondary_nic[:ip_address] }
    tests('vms[0]#network_adapters:primary').returns(false){ secondary_nic[:primary] }
    tests('vms[0]#network_adapters:ip_allocation_mode').returns('POOL'){ secondary_nic[:ip_allocation_mode] }
    tests('vms[0]#network_adapters:network').returns('nfs-net-01'){ secondary_nic[:network] }

    tests('vms[1]#disks').returns(false){ vms[1][:disks].empty? }
    tests('vms[1]#disks:0').returns({'Hard disk 1'=>10240}){ vms[1][:disks][0] }
  end

end
