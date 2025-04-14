defmodule SQLGlot do
  @moduledoc """
  A `sqlglot` wrapper for Elixir.
  """

  @type dialect() :: atom()
  @type sql() :: String.t()

  @doc """
  Transpile the SQL to another dialect.
  """
  @spec transpile(sql(), from_dialect :: dialect(), to_dialect :: dialect(), options) :: sql()
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

  @doc "Format the SQL code using `dialect` as a reference."
  @spec format(sql(), dialect(), options) :: sql()
        when options: [{:identify, boolean()} | {:pretty, boolean()}]
  def format(sql, dialect, opts \\ []) do
    transpile(sql, dialect, dialect, Keyword.put(opts, :pretty, true))
  end
end
