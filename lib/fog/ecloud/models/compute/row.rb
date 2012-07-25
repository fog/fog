module Fog
  module Compute
    class Ecloud
      class Row < Fog::Ecloud::Model
        identity :href

        attribute :name, :aliases => :Name
        attribute :type, :aliases => :Type
        attribute :other_links, :aliases => :Links
        attribute :index, :aliases => :Index

        def groups
          @groups = Fog::Compute::Ecloud::Groups.new(:connection => connection, :href => href)
        end

        def edit(options)
          options[:uri] = href
          connection.rows_edit(options).body
        end

        def move_up(options)
          options[:uri] = href + "/action/moveup"
          connection.rows_moveup(options).body
        end

        def move_down(options)
          options[:uri] = href + "/action/movedown"
          connection.rows_movedown(options).body
        end

        def delete
          connection.rows_delete(href).body
        end

        def create_group(options = {})
          options[:uri] = "/cloudapi/ecloud/layoutGroups/environments/#{environment_id}/action/createLayoutGroup"
          options[:row_name] = name
          options[:href] = href
          data = connection.groups_create(options).body
          group = Fog::Compute::Ecloud::Groups.new(:connection => connection, :href => data[:href])[0]
        end

        def environment_id
          other_links[:Link][:href].scan(/\d+/)[0]
        end

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
