Shindo.tests('Fog::Orchestration::Rackspace', ['rackspace']) do

  service = Fog::Orchestration.new(:provider => :rackspace)

  link_format = {
    'href' => String,
    'rel' => String
  }

  template_validate_format = {
    'Description' => String,
    'Parameters' => Hash
  }
  template_parameters_format = [
    'Default' => Fog::Nullable::String,
    'Description' => String,
    'NoEcho' => String, # ack!
    'Type' => String,
    'Label' => Fog::Nullable::String
  ]
  create_stack_format = {
    'stack' => {
      'id' => String,
      'links' => [
        link_format
      ]
    }
  }
  stack_data_format = {
    'stack' => {
      'disable_rollback' => Fog::Boolean,
      'description' => String,
      'parameters' => Hash,
      'stack_status_reason' => String,
      'stack_name' => String,
      'outputs' => Fog::Nullable::Array,
      'creation_time' => String,
      'links' => [
        link_format
      ],
      'capabilities' => [String],
      'notification_topics' => [String],
      'timeout_mins' => Fog::Nullable::Integer,
      'stack_status' => String,
      'updated_time' => Fog::Nullable::String,
      'id' => String,
      'template_description' => String
    }
  }
  update_stack_format = String
  template_stack_format = Hash
  list_stacks_format = {
    'stacks' => [
      {
        'stack' => {
          'id' => String,
          'stack_name' => String,
          'description' => String,
          'links' => [
            link_format
          ],
          'stack_status' => String,
          'stack_status_reason' => String,
          'creation_time' => String,
          'updated_time' => String
        }
      }
    ]
  }
  list_events_stack_format = {
    'events' => [
      {
        'event_time' => String,
        'id' => String,
        'links' => [
          link_format
        ],
        'logical_resource_id' => String,
        'physical_resource_id' => Fog::Nullable::String,
        'resource_name' => String,
        'resource_status' => String,
        'resource_status_reason' => Fog::Nullable::String
      }
    ]
  }
  list_resources_stack_format = {
    'resources' => [
      {
        'resource_name' => String,
        'links' => [
          link_format
        ],
        'logical_resource_id' => String,
        'physical_resource_id' => String,
        'updated_time' => String,
        'required_by' => Array,
        'resource_type' => String,
        'resource_status' => String,
        'resource_status_reason' => Fog::Nullable::String
      }
    ]
  }
  template_stack_format = {
    'Description' => Fog::Nullable::String,
    'Parameters' => Fog::Nullable::Hash,
    'Resources' => Fog::Nullable::Hash,
    'Outputs' => Fog::Nullable::Hash,
    'AWSTemplateFormatVersion' => String
  }

  test_template = '{"AWSTemplateFormatVersion":"2010-09-09","Parameters":{"Creator":{"Default":"someuser","Type":"String","Description":"Creator of stack"}},"Resources":{"TestNet":{"Type":"Rackspace::Cloud::Network","Properties":{"cidr":"192.168.9.0/24","label":"TestNet"}}}}'

  tests('validation success') do
    validation = service.template_validate(:template => test_template).body
    tests("template_validate(:template => test_template)").
      formats(template_validate_format){ validation }
    tests("template_validate(:template => test_template) | parameters").
      formats(template_parameters_format){ validation['Parameters'].values }
  end

  tests('validation failure') do
    tests("template_validate(:template => test_template + 'junk')").
      raises(Fog::Orchestration::Rackspace::BadRequest) do
      service.template_validate(:template => test_template + 'junk').body
    end
  end

  tests('stack creation success') do
    @stack_name = 'fogteststack-' << Time.now.to_i.to_s
    @stack_id = nil
    tests("create_stack('#{@stack_name}', :template => test_template, :disable_rollback => true, :parameters => {'Creator' => 'me'})")
      .formats(create_stack_format) do
      result = service.create_stack(@stack_name,
        :template => test_template,
        :disable_rollback => true,
        :parameters => {
          'Creator' => 'me'
        }
      ).body
      @stack_id = result['stack']['id']
      result
    end
  end

  tests('stack data success') do
    tests("data_stack('#{@stack_name}', '#{@stack_id}')").
      formats(stack_data_format) do
      service.data_stack(@stack_name, @stack_id).body
    end
  end

  tests('stack events list success') do
    tests("list_events_stack('#{@stack_name}', '#{@stack_id}')").
      formats(list_events_stack_format) do
      service.list_events_stack(@stack_name, @stack_id).body
    end
  end

  tests('stack resources list success') do
    tests("list_resources_stack('#{@stack_name}', '#{@stack_id}')").
      formats(list_resources_stack_format) do
      service.list_resources_stack(@stack_name, @stack_id).body
    end
  end

  tests('stack template success') do
    tests("template_stack('#{@stack_name}', '#{@stack_id}')").
      formats(template_stack_format) do
      service.template_stack(@stack_name, @stack_id).body
    end
  end

  tests('stack destruction success') do
    tests("delete_stack('#{@stack_name}', '#{@stack_id}')") do
      service.delete_stack(@stack_name, @stack_id)
    end
  end

end
