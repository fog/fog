Shindo.tests("Fog::Compute[:hp] | metadata for images", ['hp']) do

  @base_image_id = ENV["BASE_IMAGE_ID"] || 1242

  @server = Fog::Compute[:hp].servers.create(:name => "fogsermdtests", :flavor_id => 100, :image_id => @base_image_id)
  @server.wait_for { ready? }
  response = @server.create_image("fogimgmetadatatests", :metadata => {'Meta1' => 'MetaValue1', 'Meta2' => 'MetaValue2'})
  unless Fog.mocking?
    sleep(10)
  end
  new_image_id = response.headers["Location"].split("/")[5]
  @image = Fog::Compute[:hp].images.get(new_image_id)
  tests('success') do

    tests("#all").succeeds do
      @image.metadata.all
    end

    tests("#get('Meta1')").succeeds do
      pending if Fog.mocking?
      @image.metadata.get('Meta1')
    end

    tests("#update({'Meta3' => 'MetaValue3'})").succeeds do
      @data = @image.metadata.update({'Meta3' => 'MetaValue3'})
      test("metadata has updated correctly") do
        @image.metadata.get('Meta3').value == "MetaValue3"
      end
    end

    tests("#set({'Meta4' => 'MetaValue4'})").succeeds do
      @data = @image.metadata.set({'Meta4' => 'MetaValue4'})
      test("metadata has set correctly") do
        @image.metadata.get('Meta4').value == "MetaValue4"
      end
    end

    tests("#save").succeeds do
      m = @image.metadata.new(:key => 'Meta5', :value => 'MetaValue5')
      @data = m.save
      test("metadata has saved correctly") do
        @image.metadata.get('Meta5').value == "MetaValue5"
      end
    end

    tests("#destroy('Meta5')").succeeds do
      @image.metadata.destroy('Meta5')
      test("metadata has been destroyed") do
        @image.metadata.get('Meta5') == nil
      end
    end

  end

  unless Fog.mocking?
    @image.destroy
  end
  @server.destroy

end
