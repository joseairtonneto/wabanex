defmodule WabanexWeb.Resolvers.User do
  def create(%{input: params}, _context), do: Wabanex.Users.Create.call(params)
  def get(%{id: user_id}, _context), do: Wabanex.Users.Get.call(user_id)
  def update(%{id: user_id, input: params}, _context), do: Wabanex.Users.Update.call(user_id, params)
  def delete(%{id: user_id}, _context), do: Wabanex.Users.Delete.call(user_id)
end
