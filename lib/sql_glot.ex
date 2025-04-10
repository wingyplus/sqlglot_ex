defmodule SQLGlot do
  @moduledoc """
  A `sqlglot` wrapper for Elixir.
  """

  import Pythonx, only: [sigil_PY: 2]

  @type dialect() :: atom()

  Pythonx.uv_init(SQLGlot.Pyproject.pyproject())

  @doc """
  Transpile the SQL to another dialect.
  """
  @spec transpile(sql :: String.t(), from_dialect :: dialect(), to_dialect :: dialect(), options) ::
          String.t()
        when options: [{:identify, boolean()} | {:pretty, boolean()}]
  def transpile(sql, from_dialect, to_dialect, opts \\ []) do
    from_dialect = Atom.to_string(from_dialect)
    to_dialect = Atom.to_string(to_dialect)
    options = Enum.into(opts, %{})

    ~PY"""
    import sqlglot

    options = options | {
        'read': from_dialect.decode("utf-8"), 
        'write': to_dialect.decode("utf-8")
    }

    sqlglot.transpile(sql.decode("utf-8"), **options)[0]
    """

    Pythonx.decode(result)
  end
end
