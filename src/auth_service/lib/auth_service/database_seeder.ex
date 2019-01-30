defmodule AuthService.DatabaseSeeder do
  alias AuthService.{Repo, User}
  import Ecto.Query
  require Logger


  def seed() do
    Logger.info("Starting seeding of database")

    if not Repo.exists?(from u in "users", where: u.username == "admin") do
      Logger.debug("DatabaseSeeder: Admin user not found. Creating default user...")
      User.changeset(%User{}, %{username: "admin", password: "admin"})
      |> Repo.insert!()
    end

    Logger.info("Finished seeding database")
  end

end
