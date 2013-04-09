Shindo.tests('Fog::Compute[:cloudstack] | template requests', ['cloudstack']) do

  @templates_format = {
    'listtemplatesresponse'  => {
      'count' => Integer,
      'template' => [
        'id' => Integer,
        'name' => String,
        'displaytext' => String,
        'ispublic' => Fog::Boolean,
        'created' => String,
        'isready' => Fog::Boolean,
        'passwordenabled' => Fog::Boolean,
        'format' => String,
        'isfeatured' => Fog::Boolean,
        'crossZones' => Fog::Boolean,
        'ostypeid' => Integer,
        'ostypename' => String,
        'account' => String,
        'zoneid' => Integer,
        'zonename' => String,
        'status' => Fog::Nullable::String,
        'size' => Fog::Nullable::Integer,
        'templatetype' => String,
        'hypervisor' => String,
        'domain' => String,
        'domainid' => Integer,
        'isextractable' => Fog::Boolean,
        'checksum' => Fog::Nullable::String,
        'sourcetemplateid' => Fog::Nullable::Integer,
        'accountid' => Fog::Nullable::Integer,
        'bootable' => Fog::Nullable::Boolean,
        'hostid' => Fog::Nullable::Integer,
        'hostname' => Fog::Nullable::String,
        'jobid' => Fog::Nullable::Integer,
        'jobstatus' => Fog::Nullable::Integer,
        'removed' => Fog::Nullable::Boolean,
        'templatetag' => Fog::Nullable::String,
        'templatetype' => Fog::Nullable::String
      ]
    }
  }

  # TODO: check this
  #
  # in documentation http://cloudstack.apache.org/docs/api/apidocs-4.0.0/user/createTemplate.html
  # we have wrong response description
  #
  # real response for cloudstack api 4.0
  # {"createtemplateresponse"=>
  #   {"id"=>"15a98aee-a9af-4263-849c-3650c5b5f7ff", "jobid"=>"6db40d1a-5737-4955-afbc-9954ff49547a"}
  # }
  #
  @create_template_format = {
    'createtemplateresponse'=> {
        'id' => String,
        'jobid' => String
    }
  }

  tests('success') do

    tests('#list_templates').formats(@templates_format) do
      pending if Fog.mocking?
      Fog::Compute[:cloudstack].list_templates('templateFilter' => "executable")
    end

    tests('#create_template').formats(@create_template_format) do
      compute = Fog::Compute[:cloudstack]

      compute.data[:volumes] = { '1ef854d-279e-4e68-9059-74980fd7b29b' => {'id' => '1ef854d-279e-4e68-9059-74980fd7b29b' } }
      compute.data[:os_types] = { 'daf124c8-95d8-4756-8e1c-1871b073babb' => {'id' => 'daf124c8-95d8-4756-8e1c-1871b073babb' } }

      compute.create_template 'displaytext' => 'saved template',
                                               'name' => 'template name',
                                               'ostypeid' => 'daf124c8-95d8-4756-8e1c-1871b073babb',
                                               'volumeid' => '1ef854d-279e-4e68-9059-74980fd7b29b'
    end

  end

end