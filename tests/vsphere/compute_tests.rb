Shindo.tests('Fog::Compute[:vsphere]', ['vsphere']) do

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

