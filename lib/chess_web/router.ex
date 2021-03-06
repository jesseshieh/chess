defmodule ChessWeb.Router do
  use ChessWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :auth do
    plug Chess.Auth.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ChessWeb do
    pipe_through [:browser, :auth] # Use the default browser stack

    get "/", PageController, :index
    resources "/session", SessionController,
      only: [:new, :create, :delete], singleton: true
    resources "/registration", RegistrationController,
      only: [:new, :create], singleton: true
  end

  scope "/", ChessWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    resources "/games", GameController,
      only: [:index, :create, :show, :delete]
  end

  # Other scopes may use custom stacks.
  scope "/api", ChessWeb do
    pipe_through :api

    resources "/games", Api.GameController, only: [:show, :update]
  end
end
