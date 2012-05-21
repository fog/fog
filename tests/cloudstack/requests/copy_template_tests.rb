Shindo.tests('Fog::Compute[:cloudstack] | copy template requests', ['cloudstack']) do

  @copy_template_format = {"copytemplateresponse"=>{"jobid"=>Integer}}

  tests('success') do
    tests('#copy_template').formats(@copy_template_format) do
      Fog::Compute[:cloudstack].copy_template(
        Cloudstack::Compute::Constants::TEMPLATE_ID,
        Cloudstack::Compute::Constants::FROM_ZONE_ID,
        Cloudstack::Compute::Constants::TO_ZONE_ID)
    end
  end
end