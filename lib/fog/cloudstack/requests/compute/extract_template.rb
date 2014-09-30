module Fog
  module Compute
    class Cloudstack

      class Real
        # Extracts a template
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/extractTemplate.html]
        def extract_template(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'extractTemplate') 
          else
            options.merge!('command' => 'extractTemplate', 
            'mode' => args[0], 
            'id' => args[1])
          end
          request(options)
        end
      end
 
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
    end
  end
end

