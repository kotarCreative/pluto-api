defmodule PlutoWeb.PageController do
  use PlutoWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
