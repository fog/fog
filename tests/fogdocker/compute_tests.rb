Shindo.tests('Fog::Compute[:fogdocker]', ['fogdocker']) do

  compute = Fog::Compute[:fogdocker]

  tests("Compute collections") do
    %w{ servers images }.each do |collection|
      test("it should respond to #{collection}") { compute.respond_to? collection }
    end
  end

  tests("Compute requests") do
    %w{ api_version container_all container_create container_delete container_get
        container_action image_all image_create image_delete image_get image_search }.each do |collection|
      test("it should respond to #{collection}") { compute.respond_to? collection }
    end
  end
end
