defmodule ChessWeb.SessionController do
  use ChessWeb, :controller

  alias Chess.Auth
  alias Chess.Auth.User
  alias Chess.Auth.Guardian

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(
    conn,
    %{"user" => %{"username" => username, "password" => password}}
  ) do
    case Auth.authenticate_user(username, password) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> put_flash(:info, "You are signed in")
        |> redirect(to: game_path(conn, :index))
      {:error, _error} ->
        changeset = User.changeset(%User{})
        conn
        |> put_flash(:error, "Bad username or password")
        |> render("new.html", changeset: changeset)
    end
  end

  def delete(conn, _params) do
    conn
    |> Guardian.Plug.sign_out()
    |> put_flash(:info, "You are logged out")
    |> redirect(to: page_path(conn, :index))
  end
end
