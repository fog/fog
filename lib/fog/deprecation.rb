module Fog
  module Deprecation

    def deprecate(older, newer)
      class_eval <<-EOS, __FILE__, __LINE__
        def #{older}(*args)
          Formatador.display_line("[yellow][WARN] #{self} => ##{older} is deprecated, use ##{newer} instead[/]")
          #{newer}(*args)
        end
      EOS
    end

  end
end
