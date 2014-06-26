module Fog
  module Compute
    class Cloudstack
      class Real

        # Extracts a template.
        #
        # {CloudStack API Reference}[http://http://download.cloud.com/releases/3.0.0/api_3.0.0/user/extractTemplate.html]
        def extract_template(options={})
          options.merge!(
            'command' => 'extractTemplate'
          )

          request(options)
        end

      end # Real

      class Mock
        def extract_template(options={})
          Fog.credentials[:cloudstack_zone_id] = 1105

          template_id = options['id']
          template_mode = options['mode']

          zoneid = self.data[:zones].keys[0]
          zone = self.data[:zones][zoneid]

          template = {}
          template['id'] = template_id
          template['name'] = "test template"
          template['extractId'] = 1
          template['accountid'] = 1
          template['state'] = "DOWNLOAD_URL_CREATED"
          template['zoneid'] = zoneid
          template['zonename'] = self.data[:zones][zoneid]["name"]
          template['extractMode'] = template_mode
          template['url'] = "http:%2F%2Fexample.com"

          job_id = 1
          job = {
            "jobid"         => job_id,
            "jobstatus"     => 1,
            "jobprocstatus" => 0,
            "jobresultcode" => 0,
            "jobresulttype" => "object",
            "jobresult"     => { "template" => template }
          }

          self.data[:jobs][job_id] = job
          {
            "extracttemplateresponse" => {
              "jobid" => job_id
            }
          }
        end
      end # Mock
    end # CloudStack
  end # Compute
end # Fog
