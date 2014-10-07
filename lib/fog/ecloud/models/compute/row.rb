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
          @groups = self.service.groups(:href => href)
        end

        def edit(options)
          options[:uri] = href
          service.rows_edit(options).body
        end

        def move_up(options)
          options[:uri] = href + "/action/moveup"
          service.rows_moveup(options).body
        end

        def move_down(options)
          options[:uri] = href + "/action/movedown"
          service.rows_movedown(options).body
        end

        def delete
          service.rows_delete(href).body
        end

        def create_group(options = {})
          options[:uri] = "#{service.base_path}/layoutGroups/environments/#{environment_id}/action/createLayoutGroup"
          options[:row_name] = name
          options[:href] = href
          data = service.groups_create(options).body
          group = self.service.groups.new(data)
        end

        def environment_id
          reload if other_links.nil?
          other_links[:Link][:href].scan(/\d+/)[0]
        end

        def id
          href.scan(/\d+/)[0]
        end

        alias_method :destroy, :delete
      end
    end
  end
end
