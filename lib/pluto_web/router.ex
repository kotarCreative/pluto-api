defmodule PlutoWeb.Router do
  use PlutoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Pluto.Auth.Pipeline
  end

  # scope "/", PlutoWeb do
  #   pipe_through :browser # Use the default browser stack
  #
  #   get "/", PageController, :index
  # end

  # Other scopes may use custom stacks.
   scope "/api/v1", PlutoWeb do
     pipe_through :api

     post "/login", SessionController, :login
     post "/logout", SessionController, :logout
     post "/sign_up", UserController, :create
   end

   scope "/api/v1", PlutoWeb do
     pipe_through [:api, :auth]

     resources "/chats", ChatController
     resources "/messages", MessageController
     resources "/users", UserController
     resources "/reports", ReportController
   end
end
