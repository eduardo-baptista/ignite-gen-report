defmodule GenReport do
  alias GenReport.Parser

  def build(file_name) do
    file_name
    |> Parser.parse_file()
    |> Enum.reduce(create_empty_report(), &calculate_values/2)
  end

  def build, do: {:error, "Insira o nome de um arquivo"}

  defp calculate_values(
         [name, hours, _day, month, year],
         %{
           "all_hours" => all_hours,
           "hours_per_month" => hours_per_month,
           "hours_per_year" => hours_per_year
         }
       ) do
    all_hours = update_total_value(all_hours, name, hours)
    hours_per_month = update_map(hours_per_month, name, month, hours)
    hours_per_year = update_map(hours_per_year, name, year, hours)
    build_report(all_hours, hours_per_month, hours_per_year)
  end

  defp update_total_value(map, key, hours) do
    total_hours = Map.get(map, key, 0)
    Map.put(map, key, hours + total_hours)
  end

  defp update_map(map, name, key, hours) do
    report =
      map
      |> Map.get(name, %{})
      |> update_total_value(key, hours)

    Map.put(map, name, report)
  end

  defp create_empty_report do
    %{"all_hours" => %{}, "hours_per_month" => %{}, "hours_per_year" => %{}}
  end

  defp build_report(all_hours, hours_per_month, hours_per_year) do
    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end
end
