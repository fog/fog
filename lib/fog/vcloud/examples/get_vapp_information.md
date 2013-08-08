# Get network information

- To see all vApps list

        connection.servers.service.vapps

- To see details of a particular vApp

        selected_vapp = connection.servers.service.vapps.detect { |n| n.name == 'vapp-name' }
        connection.servers.service.get_vapp(selected_vapp.href)
