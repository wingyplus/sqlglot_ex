defmodule SQLGlotTest do
  use ExUnit.Case
  use Mneme

  setup do
    SQLGlot.init()
  end

  test "transpile/4" do
    auto_assert "SELECT FROM_UNIXTIME(1618088028295 / POW(10, 3))" <-
                  SQLGlot.transpile("SELECT EPOCH_MS(1618088028295)", :duckdb, :hive)
  end

  test "format/3" do
    auto_assert """
                SELECT
                  *
                FROM table_a AS a
                WHERE
                  a.b = 'c'\
                """ <-
                  SQLGlot.format(
                    """
                    SELECT *   FROM
                          table_a a
                        WHERE a.b   =     'c'
                    """,
                    :spark
                  )
  end
end
