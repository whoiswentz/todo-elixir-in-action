defmodule Todo.Cache do
  use GenServer

  def start do
    GenServer.start(__MODULE__, nil)
  end

  def server_process(cache, todo_list_name) do
    GenServer.call(cache, {:server_process, todo_list_name})
  end

  def init(_) do
    {:ok, %{}}
  end

  def handle_call({:server_process, todo_list_name}, _from, state) do
    state
    |> Map.fetch(todo_list_name)
    |> upsert_todo_list(state, todo_list_name)
  end

  defp upsert_todo_list({:ok, todo_list}, state, _todo_list_name) do
    {:reply, todo_list, state}
  end

  defp upsert_todo_list(:error, state, todo_list_name) do
    {:ok, new_server} = Todo.Server.start()
    {:reply, new_server, Map.put(state, todo_list_name, new_server)}
  end
end
