defimpl Collectable, for: Todo do
  def into(original) do
    {original, &into_callback/2}
  end

  defp into_callback(todo_list, {:cont, entry}) do
    Todo.add_entry(todo_list, entry)
  end

  defp into_callback(todo_list, :done), do: todo_list
  defp into_callback(_todo_list, :halt), do: :ok
end
