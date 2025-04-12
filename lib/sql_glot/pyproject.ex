defmodule SQLGlot.Pyproject do
  def pyproject() do
    """
    [project]
    name = "sqlglot-ex"
    version = "0.0.0"
    requires-python = "==3.13.*"
    dependencies = [
      "sqlglot[rs]==26.12.1"
    ]
    """
  end
end
