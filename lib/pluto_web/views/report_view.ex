defmodule PlutoWeb.ReportView do
  use PlutoWeb, :view
  alias PlutoWeb.ReportView

  def render("index.json", %{reports: reports}) do
    %{data: render_many(reports, ReportView, "report.json")}
  end

  def render("show.json", %{report: report}) do
    %{data: render_one(report, ReportView, "report.json")}
  end

  def render("report.json", %{report: report}) do
    %{id: report.id,
      message: report.message}
  end
end
