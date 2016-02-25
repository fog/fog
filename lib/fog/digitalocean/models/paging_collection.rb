module Fog
  module Compute
    class DigitalOceanV2
      class PagingCollection < Fog::Collection

        attribute :next
        attribute :last

        def next_page
          all(page: @next) if @next != @last
        end

        def previous_page
          if @next.to_i > 2
            all(page: @next.to_i - 2)
          end
        end

        private
        def deep_fetch(hash, *path)
          path.inject(hash) do |acc, key|
            acc.respond_to?(:keys) ? acc[key] : nil
          end
        end

        def get_page(link)
          if match = link.match(/page=(?<page>\d+)/)
            match.captures.last
          end
        end

        def get_paged_links(links)
          next_link = deep_fetch(links, "pages", "next").to_s
          last_link = deep_fetch(links, "pages", "last").to_s
          @next = get_page(next_link) || @next
          @last = get_page(last_link) || @last
        end
      end
    end
  end
end
