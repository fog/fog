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
end