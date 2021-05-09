defmodule GenReport.Parser do
  @month_by_number %{
    "1" => "janeiro",
    "2" => "fevereiro",
    "3" => "março",
    "4" => "abril",
    "5" => "maio",
    "6" => "junho",
    "7" => "julho",
    "8" => "agosto",
    "9" => "setembro",
    "10" => "outubro",
    "11" => "novembro",
    "12" => "dezembro"
  }

  def parse_file(file_name) do
    file_name
    |> File.stream!()
    |> Stream.map(&parse_line/1)
  end

  defp parse_line(line) do
    line
    |> String.trim()
    |> String.split(",")
    |> format_parsed_line()
  end

  defp format_parsed_line([name, hours, day, month, year]) do
    [
      String.downcase(name),
      String.to_integer(hours),
      String.to_integer(day),
      get_month_by_number(month),
      String.to_integer(year)
    ]
  end

  defp get_month_by_number(month), do: Map.get(@month_by_number, month)
end
