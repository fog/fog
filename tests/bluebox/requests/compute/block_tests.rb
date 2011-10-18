Shindo.tests('Fog::Compute[:bluebox] | block requests', ['bluebox']) do

  @block_format = {
    'cpu'             => Float,
    'description'     => String,
    'hostname'        => String,
    'id'              => String,
    'ips'             => [{'address' => String}],
    'lb_applications' => [],
    'memory'          => Integer,
    'product'         => Bluebox::Compute::Formats::PRODUCT,
    'status'          => String,
    'storage'         => Integer,
    'template'        => String
  }

  tests('success') do

    @product_id   = '94fd37a7-2606-47f7-84d5-9000deda52ae' # 1 GB
    @template_id  = compute_providers[:bluebox][:server_attributes][:image_id]
    @password     = 'chunkybacon'

    @block_id = nil

    tests("create_block('#{@product_id}', '#{@template_id}', {'password' => '#{@password}'})").formats(@block_format.merge('add_to_lb_application_results' => {'text' => String})) do
      pending if Fog.mocking?
      data = Fog::Compute[:bluebox].create_block(@product_id, @template_id, {'password' => @password}).body
      @block_id = data['id']
      data
    end

    unless Fog.mocking?
      Fog::Compute[:bluebox].servers.get(@block_id).wait_for { ready? }
    end

    tests("get_block('#{@block_id}')").formats(@block_format) do
      pending if Fog.mocking?
      Fog::Compute[:bluebox].get_block(@block_id).body
    end

    tests("get_blocks").formats([@block_format.reject {|key,value| ['product', 'template'].include?(key)}]) do
      pending if Fog.mocking?
      Fog::Compute[:bluebox].get_blocks.body
    end

    tests("reboot_block('#{@block_id}')").formats({'status' => String, 'text' => String}) do
      pending if Fog.mocking?
      Fog::Compute[:bluebox].reboot_block(@block_id).body
    end

    unless Fog.mocking?
      Fog::Compute[:bluebox].servers.get(@block_id).wait_for { ready? }
    end

    tests("destroy_block('#{@block_id})'").formats({'text' => String}) do
      pending if Fog.mocking?
      Fog::Compute[:bluebox].destroy_block(@block_id).body
    end

  end

  tests('failure') do

    tests("get_block('00000000-0000-0000-0000-000000000000')").raises(Fog::Compute::Bluebox::NotFound) do
      pending if Fog.mocking?
      Fog::Compute[:bluebox].get_block('00000000-0000-0000-0000-000000000000')
    end

    tests("reboot_block('00000000-0000-0000-0000-000000000000')").raises(Fog::Compute::Bluebox::NotFound) do
      pending if Fog.mocking?
      Fog::Compute[:bluebox].reboot_block('00000000-0000-0000-0000-000000000000')
    end

    tests("destroy_block('00000000-0000-0000-0000-000000000000')").raises(Fog::Compute::Bluebox::NotFound) do
      pending if Fog.mocking?
      Fog::Compute[:bluebox].destroy_block('00000000-0000-0000-0000-000000000000')
    end

  end

end
