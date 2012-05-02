Shindo.tests("Fog::Compute[:vsphere] | vm_config_ip request", 'vsphere') do

  require 'rubygems'
  require 'rbvmomi'
  require 'Fog'
  require 'guid'

  compute = Fog::Compute[:vsphere]

  response = nil
  response_linked = nil
  vm_moid = nil
  vm_uuid = nil

  class ConstClass
    DATACENTER = 'Datacenter2012'
    TEMPLATE = "/Datacenters/#{DATACENTER}/vm/vhelper-node-centos-5.8-x86_64-4G" #path of a vm which need update network
    IP_FOR_SET = '10.141.72.72'
    CONFIG = '{"device":"eth0","bootproto":"static","ipaddr":"10.141.72.72","netmask":"255.255.254.0","gateway":"10.141.73.253","dnsserver0":"10.132.71.1", "dnsserver1":"10.132.71.2" }'
    CONFIG2 = '{"device":"eth0","bootproto":"dhcp"}'
  end

  tests("set ip of new provisoned vm with a static value | The return value should") do
    response = compute.vm_clone('path' => ConstClass::TEMPLATE, 'name' => 'node_static_ip', 'power_on'=> false,'linked_clone' => true)
    re_vm_moid = response.fetch('vm_ref')
    response = compute.vm_config_ip('vm_moid'=>re_vm_moid, 'config_json'=>  ConstClass::CONFIG)
    %w{task_state}.each do |key|
      test("have a #{key} key") { response.has_key? key }
    end
    test("ip transfer success or not")  { response.fetch('task_state').to_s == 'success'}
    attrs = compute.get_vm_properties(re_vm_moid)
    response = compute.vm_power_on('instance_uuid' => attrs['instance_uuid'])
    %w{task_state}.each do |key|
      test("have a #{key} key") { response.has_key? key }
    end
    test("ip set success or not")  { response.fetch('task_state').to_s == 'success'}
    while(!attrs['ipaddress'])
      sleep(6)
      attrs = compute.get_vm_properties(re_vm_moid)
    end
    puts attrs['ipaddress']
    test("ip of new vm equal to preset ip or not")  { attrs['ipaddress'] ==  ConstClass::IP_FOR_SET }
  end

  tests("set ip of new provisoned vm with dhcp | The return value should") do
    response = compute.vm_clone('path' => ConstClass::TEMPLATE, 'name' => 'node_dhcp', 'power_on'=> false,'linked_clone' => true)
    re_vm_moid = response.fetch('vm_ref')
    response = compute.vm_config_ip('vm_moid'=>re_vm_moid, 'config_json'=>  ConstClass::CONFIG2)
    %w{task_state}.each do |key|
      test("have a #{key} key") { response.has_key? key }
    end
    test("ip transfer success or not")  { response.fetch('task_state').to_s == 'success'}
    attrs = compute.get_vm_properties(re_vm_moid)
    response = compute.vm_power_on('instance_uuid' => attrs['instance_uuid'])
    %w{task_state}.each do |key|
      test("have a #{key} key") { response.has_key? key }
    end
    test("ip set success or not")  { response.fetch('task_state').to_s == 'success'}
    while(!attrs['ipaddress'])
      sleep(6)
      attrs = compute.get_vm_properties(re_vm_moid)
    end
    puts attrs['ipaddress']
  end


end
