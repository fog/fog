Shindo.tests("Fog::Compute::HPV2 | metadata for servers", ['hp', 'v2', 'compute']) do

  service = Fog::Compute.new(:provider => 'HP', :version => :v2)

  @base_image_id = ENV['BASE_IMAGE_ID'] || '7f60b54c-cd15-433f-8bed-00acbcd25a17'

  @server = service.servers.create(:name => 'fogsermetadatatests', :flavor_id => 100, :image_id => @base_image_id, :metadata => {'Meta1' => 'MetaValue1', 'Meta2' => 'MetaValue2'})
  @server.wait_for { ready? }

  tests('success') do

    tests('#all').succeeds do
      @server.metadata.all
    end

    tests("#get('Meta1')").succeeds do
      @data = @server.metadata.get('Meta1')
      test('metadata gets correct value') do
        @data.value == 'MetaValue1'
      end
    end

    tests("#update({'Meta3' => 'MetaValue3'})").succeeds do
      @data = @server.metadata.update({'Meta3' => 'MetaValue3'})
      test('metadata has updated correctly') do
        @server.metadata.get('Meta3').value == 'MetaValue3'
      end
    end

    tests("#set({'Meta4' => 'MetaValue4'})").succeeds do
      @data = @server.metadata.set({'Meta4' => 'MetaValue4'})
      test('metadata has set correctly') do
        @server.metadata.get('Meta4').value == 'MetaValue4'
      end
    end

    tests('#save').succeeds do
      m = @server.metadata.new(:key => 'Meta5', :value => 'MetaValue5')
      @data = m.save
      test('metadata has saved correctly') do
        @server.metadata.get('Meta5').value == 'MetaValue5'
      end
    end

    tests("#destroy('Meta5')").succeeds do
      @data = @server.metadata.destroy('Meta5')
      test('metadata has been destroyed') do
        @server.metadata.get('Meta5') == nil
      end
    end

  end

  @server.destroy

end
