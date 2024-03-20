defmodule Todo.Server do
  use GenServer

  def start do
    GenServer.start(__MODULE__, nil)
  end

  def add_entry(server, entry) do
    GenServer.cast(server, {:add_entry, entry})
  end

  def entries(server, date) do
    GenServer.call(server, {:entries, date})
  end

  @impl GenServer
  def init(_) do
    {:ok, Todo.new()}
  end

  @impl GenServer
  def handle_cast({:add_entry, entry}, state) do
    new_state = Todo.add_entry(state, entry)
    {:noreply, new_state}
  end

  @impl GenServer
  def handle_call({:entries, date}, _from, state) do
    entries = Todo.entries(state, date)
    {:reply, entries, state}
  end
end
