defmodule PlutoWeb.ReportController do
  use PlutoWeb, :controller

  alias Pluto.Core
  alias Pluto.Core.Report

  action_fallback PlutoWeb.FallbackController

  def index(conn, _params) do
    reports = Core.list_reports()
    render(conn, "index.json", reports: reports)
  end

  def create(conn, %{"report" => report_params}) do
    with {:ok, %Report{} = report} <- Core.create_report(report_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", report_path(conn, :show, report))
      |> render("show.json", report: report)
    end
  end

  def show(conn, %{"id" => id}) do
    report = Core.get_report!(id)
    render(conn, "show.json", report: report)
  end

  def update(conn, %{"id" => id, "report" => report_params}) do
    report = Core.get_report!(id)

    with {:ok, %Report{} = report} <- Core.update_report(report, report_params) do
      render(conn, "show.json", report: report)
    end
  end

  def delete(conn, %{"id" => id}) do
    report = Core.get_report!(id)
    with {:ok, %Report{}} <- Core.delete_report(report) do
      send_resp(conn, :no_content, "")
    end
  end
end
