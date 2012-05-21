Shindo.tests('Fog::Compute[:cloudstack] | extract template requests', ['cloudstack']) do

  @extract_template_format = {"extracttemplateresponse"=>{"jobid"=>Integer}}

  tests('success') do

    tests('#exract_template').formats(@extract_template_format) do
      Fog::Compute[:cloudstack].extract_template(
        Cloudstack::Compute::Constants::TEMPLATE_ID,
        'HTTP_DOWNLOAD',
        Cloudstack::Compute::Constants::FROM_ZONE_ID)
    end

  end

end