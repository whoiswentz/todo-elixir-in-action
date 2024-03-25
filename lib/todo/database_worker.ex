defmodule Todo.DatabaseWorker do
  use GenServer

  def start(folder_name) do
    GenServer.start(__MODULE__, folder_name)
  end

  def store(pid, key, data) do
    GenServer.cast(pid, {:store, key, data})
  end

  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end

  def init(folder_name) do
    {:ok, folder_name}
  end

  def handle_cast({:store, key, value}, db_folder) do
    db_folder
    |> file_name(key)
    |> File.write!(:erlang.term_to_binary(value))

    {:noreply, db_folder}
  end

  def handle_call({:get, key}, _from, db_folder) do
    data = case File.read(file_name(db_folder, key)) do
      {:ok, contents} -> :erlang.binary_to_term(contents)
      _ -> nil
    end

    {:reply, data, db_folder}
  end

  defp file_name(bd_folder, key) do
    Path.join(bd_folder, to_string(key))
  end
end
