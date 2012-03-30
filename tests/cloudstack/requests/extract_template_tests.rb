Shindo.tests('Fog::Compute[:cloudstack] | extract template requests', ['cloudstack']) do

  @extract_template_format = {"extracttemplateresponse"=>{"jobid"=>Integer}}

  tests('success') do

    tests('#exract_template').formats(@extract_template_format) do
      Fog::Compute[:cloudstack].extract_template(206, 'HTTP_DOWNLOAD', 1)
    end

  end

end