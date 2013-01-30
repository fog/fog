Shindo.tests("Fog::Compute[:hp] | metadata for servers", ['hp']) do

  @base_image_id = ENV["BASE_IMAGE_ID"] || 1242

  @server = Fog::Compute[:hp].servers.create(:name => "fogsermetadatatests", :flavor_id => 100, :image_id => @base_image_id, :metadata => {'Meta1' => 'MetaValue1', 'Meta2' => 'MetaValue2'})
  @server.wait_for { ready? }

  tests('success') do

    tests("#all").succeeds do
      @server.metadata.all
    end

    tests("#get('Meta1')").succeeds do
      @data = @server.metadata.get('Meta1')
      test("metadata gets correct value") do
        @data.value == "MetaValue1"
      end
    end

    tests("#update({'Meta3' => 'MetaValue3'})").succeeds do
      @data = @server.metadata.update({'Meta3' => 'MetaValue3'})
      test("metadata has updated correctly") do
        @server.metadata.get('Meta3').value == "MetaValue3"
      end
    end

    tests("#set({'Meta4' => 'MetaValue4'})").succeeds do
      @data = @server.metadata.set({'Meta4' => 'MetaValue4'})
      test("metadata has set correctly") do
        @server.metadata.get('Meta4').value == "MetaValue4"
      end
    end

    tests("#save").succeeds do
      m = @server.metadata.new(:key => 'Meta5', :value => 'MetaValue5')
      @data = m.save
      test("metadata has saved correctly") do
        @server.metadata.get('Meta5').value == "MetaValue5"
      end
    end

    tests("#destroy('Meta5')").succeeds do
      @data = @server.metadata.destroy('Meta5')
      test("metadata has been destroyed") do
        @server.metadata.get('Meta5') == nil
      end
    end

  end

  @server.destroy

end
