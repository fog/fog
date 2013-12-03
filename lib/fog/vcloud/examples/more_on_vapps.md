# More on vApps

## Checking running or stopped

    selected_vapp = connection.servers.service.vapps.detect { |n| n.name == 'vapp-name' }
    selected_vapp.on?
    selected_vapp.off?

## Wait for app to come up or stop

    selected_vapp.wait_for { selected_vapp.on? }
    selected_vapp.wait_for { selected_vapp.off? }

## Delete vApp

    selected_vapp = connection.servers.service.vapps.detect { |n| n.name == 'vapp-name' }
    vapp = connection.servers.service.get_vapp(selected_vapp.href)
    if vapp.on?
      vapp.service.undeploy selected_vapp.href #undeploy to stop vApp
      vapp.wait_for { vapp.off? }
    end
    vapp.wait_for { vapp.off? } #double check
    vapp.service.delete_vapp selected_vapp.href
