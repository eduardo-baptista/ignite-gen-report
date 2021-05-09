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
    all_hours = update_all_hours_report(all_hours, name, hours)
    hours_per_month = update_hours_per_month_report(hours_per_month, name, month, hours)
    hours_per_year = update_hours_per_year_report(hours_per_year, name, year, hours)
    build_report(all_hours, hours_per_month, hours_per_year)
  end

  defp update_all_hours_report(all_hours, name, hours) do
    total_hours = get_safe_value(all_hours, name)
    Map.put(all_hours, name, hours + total_hours)
  end

  defp update_hours_per_month_report(
         hours_per_month,
         name,
         month,
         hours
       ) do
    report = get_safe_map(hours_per_month, name)
    total_hours = get_safe_value(report, month)
    report = Map.put(report, month, hours + total_hours)
    Map.put(hours_per_month, name, report)
  end

  defp update_hours_per_year_report(
         hours_per_year,
         name,
         year,
         hours
       ) do
    report = get_safe_map(hours_per_year, name)
    total_hours = get_safe_value(report, year)
    report = Map.put(report, year, hours + total_hours)
    Map.put(hours_per_year, name, report)
  end

  defp get_safe_map(map, key), do: Map.get(map, key, %{})

  defp get_safe_value(map, key), do: Map.get(map, key, 0)

  defp create_empty_report do
    %{
      "all_hours" => %{},
      "hours_per_month" => %{},
      "hours_per_year" => %{}
    }
  end

  defp build_report(all_hours, hours_per_month, hours_per_year) do
    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end
end
