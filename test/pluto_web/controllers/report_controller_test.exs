defmodule PlutoWeb.ReportControllerTest do
  use PlutoWeb.ConnCase

  alias Pluto.Auth.UserManager
  alias Pluto.Auth.Guardian
  alias Pluto.Core
  alias Pluto.Core.Report

  @create_attrs %{message: "some message"}
  @update_attrs %{message: "some updated message"}
  @invalid_attrs %{message: nil}

  @user_attrs %{
    email: "someemail@pluto.com",
    email_token: "some email_token",
    name: "some name",
    password: "some password",
    password_confirmation: "some password"
  }

  def fixture(:report) do
    {:ok, report} = Core.create_report(@create_attrs)
    report
  end

  setup %{conn: conn} do
    {:ok, user} = UserManager.create_user(@user_attrs)
    {:ok, token, _claims} = Guardian.encode_and_sign(user)

    conn = conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer " <> token)

    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all reports", %{conn: conn} do
      conn = get conn, report_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create report" do
    test "renders report when data is valid", %{conn: conn} do
      conn_1 = post conn, report_path(conn, :create), report: @create_attrs
      assert %{"id" => id} = json_response(conn_1, 201)["data"]

      conn_2 = get conn, report_path(conn, :show, id)
      assert json_response(conn_2, 200)["data"] == %{
        "id" => id,
        "message" => "some message"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, report_path(conn, :create), report: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update report" do
    setup [:create_report]

    test "renders report when data is valid", %{conn: conn, report: %Report{id: id} = report} do
      conn_1 = put conn, report_path(conn, :update, report), report: @update_attrs
      assert %{"id" => ^id} = json_response(conn_1, 200)["data"]

      conn_2 = get conn, report_path(conn, :show, id)
      assert json_response(conn_2, 200)["data"] == %{
        "id" => id,
        "message" => "some updated message"}
    end

    test "renders errors when data is invalid", %{conn: conn, report: report} do
      conn = put conn, report_path(conn, :update, report), report: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete report" do
    setup [:create_report]

    test "deletes chosen report", %{conn: conn, report: report} do
      conn_1 = delete conn, report_path(conn, :delete, report)
      assert response(conn_1, 204)
      assert_error_sent 404, fn ->
        get conn, report_path(conn, :show, report)
      end
    end
  end

  defp create_report(_) do
    report = fixture(:report)
    {:ok, report: report}
  end
end
