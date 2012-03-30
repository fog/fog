Shindo.tests('Fog::Compute[:cloudstack] | delete template requests', ['cloudstack']) do

  @delete_template_format = {
    "deletetemplateresponse" => {
      "jobid"       => Integer,
      "success"     => Fog::Nullable::Boolean,
      "displaytext" => Fog::Nullable::String
    }
  }

  tests('success') do

    tests('#delete_template').formats(@delete_template_format) do
      Fog::Compute[:cloudstack].delete_template(213)
    end
  end

end