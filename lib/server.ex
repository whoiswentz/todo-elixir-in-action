defmodule Todo.Server do
  use GenServer

  def start(_) do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def add_entry(entry) do
    GenServer.cast(__MODULE__, {:add_entry, entry})
  end

  def entries(date) do
    GenServer.call(__MODULE__, {:entries, date})
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
