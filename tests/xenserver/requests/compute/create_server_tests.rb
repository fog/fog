Shindo.tests('Fog::Compute[:xenserver] | create_server request', ['xenserver']) do

  compute = Fog::Compute[:xenserver]
  servers = compute.servers
  # pre-flight cleanup
  (servers.all :name_matches => test_ephemeral_vm_name).each do |s|
    s.destroy
  end
  (servers.templates.select { |t| t.name == test_ephemeral_vm_name}).each do |s|
    s.destroy
  end

  tests('create_server should') do
    raises(StandardError, 'raise exception when template nil') do
      compute.create_server 'fooserver', nil
    end

    ref = compute.create_server test_ephemeral_vm_name, test_template_name
    test('return a valid reference') do
      if (ref != "OpaqueRef:NULL") and (ref.split("1") != "NULL")
        true
      else
        false
      end
    end
  end

  tests('get_vm_by_name should') do
    test('return a valid OpaqueRef') do
      (compute.get_vm_by_name(test_template_name) =~ /OpaqueRef:/) and \
        (compute.get_vm_by_name(test_template_name) != "OpaqueRef:NULL" )
    end
    returns(nil, 'return nil if VM does not exist') { compute.get_vm_by_name('sdfsdf') }
  end

  tests('create_server_raw should') do
    raises(ArgumentError, 'raise exception when name_label nil') do
      compute.create_server_raw
    end
    test('create a server') do
      ref = compute.create_server_raw(
        {
          :name_label => test_ephemeral_vm_name,
          :affinity => compute.hosts.first
        }
      )
      valid_ref? ref
    end
    test('create a server with name foobar') do
      ref = compute.create_server_raw(
        {
          :name_label => test_ephemeral_vm_name,
          :affinity => compute.hosts.first
        }
      )
      (compute.servers.get ref).name == test_ephemeral_vm_name
    end
    test('set the PV_bootloader attribute to eliloader') do
      ref = compute.create_server_raw(
        {
          :name_label => test_ephemeral_vm_name,
          :affinity => compute.hosts.first,
          :PV_bootloader => 'eliloader',
        }
      )
      (compute.servers.get ref).pv_bootloader == 'eliloader'
    end
    test('set the :pv_bootloader attribute to eliloader') do
      ref = compute.create_server_raw(
        {
          :name_label => test_ephemeral_vm_name,
          :affinity => compute.hosts.first,
          :pv_bootloader => 'eliloader',
        }
      )
      (compute.servers.get ref).pv_bootloader == 'eliloader'
    end
    test('set the "vcpus_attribute" to 1') do
      ref = compute.create_server_raw(
        {
          :name_label => test_ephemeral_vm_name,
          :affinity => compute.hosts.first,
          'vcpus_max' => '1',
        }
      )
      (compute.servers.get ref).vcpus_max == '1'
    end
    tests('set lowercase hash attributes') do
      %w{
        VCPUs_params
        HVM_boot_params
      }.each do |a|
        test("set the :#{a} to { :foo => 'bar' }") do
          ref = compute.create_server_raw(
            {
              :name_label => test_ephemeral_vm_name,
              :affinity => compute.hosts.first,
              a.downcase.to_sym => {:foo => :bar},
            }
          )
          eval "(compute.servers.get ref).#{a.to_s.downcase}['foo'] == 'bar'"
        end
      end
      %w{ VCPUs_at_startup
          VCPUs_max
          PV_bootloader_args
          PV_bootloader
          PV_kernel
          PV_ramdisk
          PV_legacy_args
      }.each do |a|
        test("set the :#{a} to 1") do
          ref = compute.create_server_raw(
            {
              :name_label => test_ephemeral_vm_name,
              :affinity => compute.hosts.first,
              a.downcase.to_sym => '1',
            }
          )
          eval "(compute.servers.get ref).#{a.to_s.downcase} == '1'"
        end
      end
    end
  end

  tests('The expected options') do
    raises(ArgumentError, 'raises ArgumentError when ref,class missing') { compute.create_server }
  end
end
