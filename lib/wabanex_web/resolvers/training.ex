defmodule WabanexWeb.Resolvers.Training do
  def create(%{input: params}, _context), do: Wabanex.Trainings.Create.call(params)
  def update(%{id: user_id, input: params}, _context), do: Wabanex.Trainings.Update.call(user_id, params)
  def delete(%{id: user_id}, _context), do: Wabanex.Trainings.Delete.call(user_id)
end
