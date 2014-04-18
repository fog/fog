Shindo.tests('Fog::Compute[:cloudstack] | extract template requests', ['cloudstack']) do

  @extract_template_format = {
    'extracttemplateresponse'  => {
      'jobid' => Integer }}

  @queary_async_job_result_format = {
    'queryasyncjobresultresponse'  => {
      'jobid' => Integer,
      'jobstatus' => Integer,
      'jobprocstatus' => Integer,
      'jobresultcode' => Integer,
      'jobresulttype' => String,
      'jobresult' => {
        'template' => {
          'id' => Integer,
          'name' => String,
          'extractId' => Integer,
          'accountid' => Integer,
          'state' => String,
          'zoneid' => Integer,
          'zonename' => String,
          'extractMode' => String,
          'url' => String
        }
      }
    }
  }

  tests('success') do

    tests('#extract_template').formats(@extract_template_format) do
      Fog::Compute::Cloudstack::Mock.reset
      Fog::Compute[:cloudstack].extract_template({'id' => 1, 'mode' => 'HTTP_DOWNLOAD'})
    end

    tests('#query_async_job_result').formats(@queary_async_job_result_format) do
      Fog::Compute::Cloudstack::Mock.reset
      jobid = Fog::Compute[:cloudstack].extract_template({'id' => 1, 'mode' => 'HTTP_DOWNLOAD'})["extracttemplateresponse"]["jobid"]
      Fog::Compute[:cloudstack].query_async_job_result('jobid' => jobid)
    end
  end

end
