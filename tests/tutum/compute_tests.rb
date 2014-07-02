Shindo.tests('Fog::Compute[:tutum]', ['tutum']) do

  compute = Fog::Compute[:tutum]

  tests("Compute collections") do
    %w{ servers images applications }.each do |collection|
      test("it should respond to #{collection}") { compute.respond_to? collection }
    end
  end

  tests("Compute requests") do
    %w{ container_all container_create container_get container_action container_logs 
        container_terminate image_all image_get image_create  image_update image_delete 
        application_all application_get application_create application_update 
        application_action application_terminate}.each do |collection|
      test("it should respond to #{collection}") { compute.respond_to? collection }
    end
  end

  tests("require_attr") do
    test("when a required field is missing") do
      begin
        compute.require_attr(:foo, {})
        raise "Should have failed"
      rescue => e
        test("it raises an ArgumentError") { e.kind_of?  ArgumentError}
      end
    end

    test("when a required field is present") do
      test("it does not error") {
        compute.require_attr(:foo, {:foo => :bar})
        true
      }
    end
  end
end