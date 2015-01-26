Shindo.tests("Fog::Compute::HPV2 | metadata requests", ['hp', 'v2', 'compute']) do

  service = Fog::Compute.new(:provider => 'HP', :version => :v2)

  @metadata_format = {
    'metadata'  => Fog::Nullable::Hash
  }
  @metaitem_format = {
    'meta'  => Fog::Nullable::Hash
  }

  @base_image_id = ENV["BASE_IMAGE_ID"] || "7f60b54c-cd15-433f-8bed-00acbcd25a17"

  tests('success') do
    @server_name = 'fogmetadatatest'
    @server_id = nil
    # check to see if there are any existing servers, otherwise create one
    if (data = service.list_servers(:status => 'ACTIVE').body['servers'][0])
      @server_id = data['id']
    else
      #@server = service.servers.create(:name => @server_name, :flavor_id => 100, :image_id => @base_image_id, :metadata => {'Meta1' => 'MetaValue1', 'Meta2' => 'MetaValue2'} )
      #@server.wait_for { ready? }
      data = service.create_server(@server_name, 100, @base_image_id, {'metadata' => {'Meta1' => 'MetaValue1', 'Meta2' => 'MetaValue2'} }).body['server']
      @server_id = data['id']
    end

    tests("#list_metadata('servers', #{@server_id})").formats(@metadata_format) do
      metadata = service.list_metadata('servers', @server_id).body
      test ("metadata exists") do
        metadata['metadata']['Meta1'] == "MetaValue1"
      end
      metadata
    end

    tests("#set_metadata('servers', #{@server_id}, {'MetaNew3' => 'MetaNewValue3'})").formats(@metadata_format) do
      data = service.set_metadata('servers', @server_id, {'MetaNew3' => 'MetaNewValue3'}).body
      test ("metadata set correctly") do
        metadata = service.list_metadata('servers', @server_id).body
        metadata['metadata']['MetaNew3'] == "MetaNewValue3"
      end
      data
    end

    tests("#update_metadata('servers', #{@server_id}, {'MetaUpd4' => 'MetaUpdValue4'})").formats(@metadata_format) do
      data = service.update_metadata('servers', @server_id, {'MetaUpd4' => 'MetaUpdValue4'}).body
      test ("metadata updated correctly") do
        metadata = service.list_metadata('servers', @server_id).body
        metadata['metadata']['MetaUpd4'] == "MetaUpdValue4"
      end
      data
    end

    tests("#get_meta('servers', #{@server_id}, 'MetaNew3')").formats(@metaitem_format) do
      mitem = service.get_meta('servers', @server_id, 'MetaNew3').body
      test ("metadata item exists") do
        mitem['meta']['MetaNew3'] == "MetaNewValue3"
      end
      mitem
    end

    tests("#update_meta('servers', #{@server_id}, 'MetaNew3', 'MetaUpdValue3')").formats(@metaitem_format) do
      mitem = service.update_meta('servers', @server_id, 'MetaNew3', 'MetaUpdValue3').body
      test ("metadata item updated correctly") do
        mitem['meta']['MetaNew3'] == "MetaUpdValue3"
      end
      mitem
    end

    tests("#delete_meta('servers', #{@server_id}, 'MetaNew3')").succeeds do
      data = service.delete_meta('servers', @server_id, 'MetaNew3').body
      test ("metadata item deleted correctly") do
        metadata = service.list_metadata('servers', @server_id).body
        metadata['metadata'].fetch('MetaNew3', nil) == nil
      end
      data
    end

    service.delete_server(@server_id)

  end

  tests('failure') do

    tests("#update_metadata('servers', 0, {'MetaUpd4' => 'MetaUpdValue4'})").raises(Fog::Compute::HPV2::NotFound) do
      service.update_metadata('servers', 0, {'MetaUpd4' => 'MetaUpdValue4'})
    end

    tests("#get_meta('servers', 0, 'MetaNew3')").raises(Fog::Compute::HPV2::NotFound) do
      service.get_meta('servers', 0, 'MetaNew3')
    end

    tests("#update_meta('servers', 0, 'MetaNew3', 'MetaUpdValue3')").raises(Fog::Compute::HPV2::NotFound) do
      service.update_meta('servers', 0, 'MetaNew3', 'MetaUpdValue3')
    end

    tests("#delete_meta('servers', 0, 'MetaNew3')").raises(Fog::Compute::HPV2::NotFound) do
      service.delete_meta('servers', 0, 'MetaNew3')
    end

  end
end
