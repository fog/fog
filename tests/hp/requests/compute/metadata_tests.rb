Shindo.tests("Fog::Compute[:hp] | metadata requests", ['hp']) do

  @metadata_format = {
    'metadata'  => Fog::Nullable::Hash
  }
  @metaitem_format = {
    'meta'  => Fog::Nullable::Hash
  }

  @base_image_id = ENV["BASE_IMAGE_ID"] || 1242

  tests('success') do
    @server_name = "fogmetadatatest"
    @server = Fog::Compute[:hp].servers.create(:name => @server_name, :flavor_id => 100, :image_id => @base_image_id, :metadata => {'Meta1' => 'MetaValue1', 'Meta2' => 'MetaValue2'} )
    @server.wait_for { ready? }

    tests("#list_metadata('servers', #{@server.id})").formats(@metadata_format) do
      metadata = Fog::Compute[:hp].list_metadata('servers', @server.id).body
      test ("metadata exists") do
        metadata['metadata']['Meta1'] == "MetaValue1"
      end
      metadata
    end

    tests("#set_metadata('servers', #{@server.id}, {'MetaNew3' => 'MetaNewValue3'})").formats(@metadata_format) do
      data = Fog::Compute[:hp].set_metadata('servers', @server.id, {'MetaNew3' => 'MetaNewValue3'}).body
      test ("metadata set correctly") do
        metadata = Fog::Compute[:hp].list_metadata('servers', @server.id).body
        metadata['metadata']['MetaNew3'] == "MetaNewValue3"
      end
      data
    end

    tests("#update_metadata('servers', #{@server.id}, {'MetaUpd4' => 'MetaUpdValue4'})").formats(@metadata_format) do
      data = Fog::Compute[:hp].update_metadata('servers', @server.id, {'MetaUpd4' => 'MetaUpdValue4'}).body
      test ("metadata updated correctly") do
        metadata = Fog::Compute[:hp].list_metadata('servers', @server.id).body
        metadata['metadata']['MetaUpd4'] == "MetaUpdValue4"
      end
      data
    end

    tests("#get_meta('servers', #{@server.id}, 'MetaNew3')").formats(@metaitem_format) do
      mitem = Fog::Compute[:hp].get_meta('servers', @server.id, 'MetaNew3').body
      test ("metadata item exists") do
        mitem['meta']['MetaNew3'] == "MetaNewValue3"
      end
      mitem
    end

    tests("#update_meta('servers', #{@server.id}, 'MetaNew3', 'MetaUpdValue3')").formats(@metaitem_format) do
      mitem = Fog::Compute[:hp].update_meta('servers', @server.id, 'MetaNew3', 'MetaUpdValue3').body
      test ("metadata item updated correctly") do
        mitem['meta']['MetaNew3'] == "MetaUpdValue3"
      end
      mitem
    end

    tests("#delete_meta('servers', #{@server.id}, 'MetaNew3')").succeeds do
      data = Fog::Compute[:hp].delete_meta('servers', @server.id, 'MetaNew3').body
      test ("metadata item deleted correctly") do
        metadata = Fog::Compute[:hp].list_metadata('servers', @server.id).body
        metadata['metadata'].fetch('MetaNew3', nil) == nil
      end
      data
    end

    @server.destroy
  end
end
