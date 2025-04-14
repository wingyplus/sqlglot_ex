defmodule SQLGlotTest do
  use ExUnit.Case
  use Mneme

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

  test "optimize/3" do
    auto_assert """
                SELECT
                  (
                    "x"."a" OR "x"."b" OR "x"."c"
                  ) AND (
                    "x"."a" OR "x"."b" OR "x"."d"
                  ) AS "_col_0"
                FROM "x" AS "x"
                WHERE
                  "x"."z" = CAST('2021-01-01' AS DATE) + INTERVAL '1' MONTH\
                """ <-
                  SQLGlot.optimize(
                    """
                    SELECT A OR (B OR (C AND D))
                    FROM x
                    WHERE Z = date '2021-01-01' + INTERVAL '1' month OR 1 = 0
                    """,
                    %{x: %{A: "INT", B: "INT", C: "INT", D: "INT", Z: "STRING"}},
                    pretty: true
                  )
  end
end
