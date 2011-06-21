Shindo.tests('Fog::Compute[:linode] | kernel requests', ['linode']) do

  @kernels_format = Linode::Compute::Formats::BASIC.merge({
    'DATA' => [{ 
      'LABEL'               => String,
      'ISXEN'               => Integer,
      'ISPVOPS'             => Integer,
      'KERNELID'            => Integer
    }]
  })

  tests('success') do
    @kernel_id = nil

    tests('#avail_kernels').formats(@kernels_format) do
      pending if Fog.mocking?
      data = Fog::Compute[:linode].avail_kernels.body
      @kernel_id = data['DATA'].first['KERNELID']
      data
    end

    tests("@avail_kernels(#{@kernel_id})").formats(@kernels_format) do
      pending if Fog.mocking?
      Fog::Compute[:linode].avail_kernels(@kernel_id).body
    end
  end
end
