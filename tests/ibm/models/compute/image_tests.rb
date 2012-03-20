Shindo.tests('Fog::Compute[:ibm] | image', ['ibm']) do

  @image_id = '20010001'
  @clone_name = 'fog-test-clone-image-' + Time.now.to_i.to_s(32)

  tests('success') do

    tests("Fog::Compute[:ibm].images.get('#{@image_id}')") do
      @image = Fog::Compute[:ibm].images.get(@image_id)
      returns(@image_id) { @image.id }
    end

    tests("Fog::Compute::Image#clone") do
      clone_id = @image.clone(@clone_name, @clone_name)
      @clone = Fog::Compute[:ibm].images.get(clone_id)
      returns(@clone_name) { @clone.name }
    end

    tests("Fog::Compute::Image#destroy") do
      returns(true) { @clone.destroy }
    end

  end

end
