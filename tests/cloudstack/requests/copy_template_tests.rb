Shindo.tests('Fog::Compute[:cloudstack] | copy template requests', ['cloudstack']) do

  @copy_template_format = {}

  tests('success') do
    tests('#copy_template').formats(@copy_template_format) do
      pending if Fog.mocking?
      Fog::Compute[:cloudstack].copy_template(213, 2, 1)
    end
  end
end