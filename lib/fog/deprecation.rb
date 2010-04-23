module Fog
  module Deprecation

    def deprecate(older, newer)
      class_eval <<-EOS, __FILE__, __LINE__
        def #{older}
          Formatador.display_line("[yellow][WARN] fog: #{older} is deprecated, use #{newer} instead[/]")
          #{newer}
        end
      EOS
    end

  end
end
