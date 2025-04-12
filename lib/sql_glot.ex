defmodule SQLGlot do
  @moduledoc """
  A `sqlglot` wrapper for Elixir.
  """

  @type dialect() :: atom()

  @doc """
  Initialize SQLGlot environment.
  """
  def init() do
    try do
      Pythonx.uv_init(SQLGlot.Pyproject.pyproject())
    rescue
      e in RuntimeError ->
        if Exception.message(e) == "Python interpreter has already been initialized" do
          :ok
        else
          reraise e, __STACKTRACE__
        end
    end
  end

  @doc """
  Transpile the SQL to another dialect.
  """
  @spec transpile(sql :: String.t(), from_dialect :: dialect(), to_dialect :: dialect(), options) ::
          String.t()
        when options: [{:identify, boolean()} | {:pretty, boolean()}]
  def transpile(sql, from_dialect, to_dialect, opts \\ []) do
    script = """
    import sqlglot

    options = options | {
        'read': from_dialect.decode("utf-8"), 
        'write': to_dialect.decode("utf-8")
    }

    sqlglot.transpile(sql.decode("utf-8"), **options)[0]
    """

    bindings = %{
      "sql" => sql,
      "from_dialect" => Atom.to_string(from_dialect),
      "to_dialect" => Atom.to_string(to_dialect),
      "options" => Enum.into(opts, %{})
    }

    {result, _} = Pythonx.eval(script, bindings)
    Pythonx.decode(result)
  end
end
