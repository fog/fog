Shindo.tests('Fog::Compute[:cloudstack] | copy template requests', ['cloudstack']) do

  @copy_template_format = {"copytemplateresponse"=>{"jobid"=>Integer}}

  tests('success') do
    tests('#copy_template').formats(@copy_template_format) do
      Fog::Compute[:cloudstack].copy_template(213, 1, 2)
    end
  end
end