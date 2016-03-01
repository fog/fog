require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))

Shindo.tests("Compute::VcloudDirector | vapp_templates", ['vclouddirector', 'all']) do

  # unless there is atleast one vapp we cannot run these tests
  pending if vdc.vapp_templates.empty?

  vapp_templates = vdc.vapp_templates
  vapp = vapp_templates.first

  tests("Compute::VcloudDirector | vapp_template") do
    tests("#id").returns(String){ vapp.id.class }
    tests("#name").returns(String){ vapp.name.class }
    tests("#href").returns(String){ vapp.href.class }
    tests("#type").returns("application/vnd.vmware.vcloud.vAppTemplate+xml"){ vapp.type }
  end
  
  tests("Compute::VcloudDirector | vapp_template vms") do
    tests("#vms").returns(Fog::Compute::VcloudDirector::TemplateVms) { vapp.vms.class }
    pending if Fog.mock?
    vm = vapp.vms[0]
    tests("#name").returns(String){ vm.name.class }
    tests("#type").returns("application/vnd.vmware.vcloud.vm+xml"){ vm.type }
    
  end



end
