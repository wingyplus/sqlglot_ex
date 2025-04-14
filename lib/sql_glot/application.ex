defmodule SQLGlot.Application do
  @moduledoc false

  use Application

  @pyproject """
  [project]
  name = "sqlglot-ex"
  version = "0.0.0"
  requires-python = "==3.13.*"
  dependencies = [
    "sqlglot[rs]==26.12.1"
  ]
  """

  def start(_, _) do
    Pythonx.uv_init(@pyproject)

    Supervisor.start_link([], strategy: :one_for_one, name: SQLGlot.Supervisor)
  end
end
