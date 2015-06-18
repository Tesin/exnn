defmodule EXNN.DSL do

  defmacro extend_struct struct_mod, keyword do
    quote do
      defstruct Keyword.merge(  Map.to_list(Map.from_struct(unquote(struct_mod).__struct__)), unquote(keyword))
    end
  end

  defmacro set_initial_pattern(pattern) do
    quote do
      # Module.put_attribute(__MODULE__, :init_pattern, unquote(pattern))
      @initial_pattern unquote(pattern)
    end
  end

  defmacro sensor(name, mod, options\\[]) do
    quote do
      @nodes {:sensor, unquote(name), unquote(mod), unquote(options)}
    end
  end

  defmacro actuator(name, mod, options\\[]) do
    quote do
      @nodes {:actuator, unquote(name), unquote(mod), unquote(options)}
    end
  end

  defmacro fitness(mod, options\\[]) do
    quote do
      @fitness {unquote(mod), unquote(options)}
    end
  end

  defmacro __before_compile__(env) do
    _nodes = Module.get_attribute(env.module, :nodes)
    _nodes = Macro.escape _nodes
    _pattern = Module.get_attribute(env.module, :initial_pattern)
    _fitness = Module.get_attribute(env.module, :fitness)

    quote do
      def initial_pattern do
        unquote _pattern
      end

      def nodes do
        unquote _nodes
      end

      def fitness do
        unquote _fitness
      end
    end
  end

end