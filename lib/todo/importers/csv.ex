defmodule Todo.Importers.Csv do
  def import(file) do
    File.stream!(file)
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(&String.split(&1, ","))
    |> Stream.map(&to_entry/1)
    |> Todo.new()
  end

  defp to_entry([date, title]) do
    %{date: Date.from_iso8601!(date), title: title}
  end
end
