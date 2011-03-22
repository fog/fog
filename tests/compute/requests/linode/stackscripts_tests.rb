Shindo.tests('Linode::Compute | stack_script requests', ['linode']) do

  @stack_scripts_format = Linode::Compute::Formats::BASIC.merge({
    'DATA' => [{ 
      'STACKSCRIPTID'       => Integer,
      'SCRIPT'              => String,
      'DESCRIPTION'         => String,
      'DISTRIBUTIONIDLIST'  => String,
      'LABEL'               => String,
      'DEPLOYMENTSTOTAL'    => Integer,
      'LATESTREV'           => Integer,
      'CREATE_DT'           => String,
      'DEPLOYMENTSACTIVE'   => Integer,
      'REV_NOTE'            => String,
      'REV_DT'              => String,
      'ISPUBLIC'            => Integer,
      'USERID'              => Integer
    }]
  })  

  tests('success') do

    tests('#avail_stackscripts').formats(@stack_scripts_format) do
      pending if Fog.mocking?
      Linode[:compute].avail_stackscripts.body
    end    
    
    tests('#stackscript_list').formats(@stack_scripts_format) do
      pending if Fog.mocking?
      Linode[:compute].stackscript_list.body
    end

  end

end
