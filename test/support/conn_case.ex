defmodule DivisionWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      alias DivisionWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint DivisionWeb.Endpoint

      def session_conn(conn) do
        opts =
          Plug.Session.init(
            store: :cookie,
            key: "foobar",
            encryption_salt: "encrypted cookie salt",
            signing_salt: "signing salt",
            log: false,
            encrypt: false
          )
        conn
        |> Plug.Session.call(opts)
        |> fetch_session()
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Division.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Division.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
