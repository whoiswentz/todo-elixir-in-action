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
  def init(name) do
  {:ok, {name, nil}, {:continue, :init}}
  end

  @impl GenServer
  def handle_continue(:init, {name, nil}) do
    todo_list = Todo.Database.get(name) || Todo.new()
    {:noreply, {name, todo_list}}
  end

  @impl GenServer
  def handle_cast({:add_entry, entry}, {name, todo_list}) do
    new_state = Todo.add_entry(todo_list, entry)
    Todo.Database.store(name, new_state)
    {:noreply, {name, new_state}}
  end

  @impl GenServer
  def handle_call({:entries, date}, _from, {_, todo} = state) do
    entries = Todo.entries(todo, date)
    {:reply, entries, state}
  end
end
