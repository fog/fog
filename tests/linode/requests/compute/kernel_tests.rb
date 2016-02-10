Shindo.tests('Fog::Compute[:linode] | kernel requests', ['linode']) do

  @kernels_format = Linode::Compute::Formats::BASIC.merge({
    'DATA' => [{
      'LABEL'               => String,
      'ISXEN'               => Integer,
      'ISKVM'               => Integer,
      'ISPVOPS'             => Integer,
      'KERNELID'            => Integer
    }]
  })

  tests('success') do
    tests('#avail_kernels').formats(@kernels_format) do
      pending if Fog.mocking?
      Fog::Compute[:linode].avail_kernels.body
    end
  end
end
