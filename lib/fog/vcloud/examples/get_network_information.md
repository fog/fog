# Get network information

- To see all networks list

        connection.servers.service.networks

- To see details of a particular network

        selected_nw = connection.servers.service.networks.detect { |n| n.name == 'Default' }
        connection.servers.service.get_network(selected_nw.href)
