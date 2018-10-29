defmodule Pluto.CoreTest do
  use Pluto.DataCase

  alias Pluto.Core

  describe "messages" do
    alias Pluto.Core.Message

    @valid_attrs %{message: "some message"}
    @update_attrs %{message: "some updated message"}
    @invalid_attrs %{message: nil}

    def message_fixture(attrs \\ %{}) do
      {:ok, message} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Core.create_message()

      message
    end

    test "list_messages/0 returns all messages" do
      message = message_fixture()
      assert Core.list_messages() == [message]
    end

    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert Core.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      assert {:ok, %Message{} = message} = Core.create_message(@valid_attrs)
      assert message.message == "some message"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message = message_fixture()
      assert {:ok, message} = Core.update_message(message, @update_attrs)
      assert %Message{} = message
      assert message.message == "some updated message"
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      assert {:error, %Ecto.Changeset{}} = Core.update_message(message, @invalid_attrs)
      assert message == Core.get_message!(message.id)
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = Core.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Core.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = Core.change_message(message)
    end
  end

  describe "chats" do
    alias Pluto.Core.Chat

    @valid_attrs %{expires_at: "2010-04-17 14:00:00.000000Z", is_private: true, name: "some name", password: "some password"}
    @update_attrs %{expires_at: "2011-05-18T15:01:01.000000Z", is_private: false, name: "some updated name", password: "some updated password"}
    @invalid_attrs %{expires_at: nil, is_private: nil, name: nil, password: nil}

    def chat_fixture(attrs \\ %{}) do
      {:ok, chat} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Core.create_chat()

      chat
    end

    test "list_chats/0 returns all chats" do
      chat = chat_fixture()
      assert Core.list_chats() == [chat]
    end

    test "get_chat!/1 returns the chat with given id" do
      chat = chat_fixture()
      assert Core.get_chat!(chat.id) == chat
    end

    test "create_chat/1 with valid data creates a chat" do
      assert {:ok, %Chat{} = chat} = Core.create_chat(@valid_attrs)
      assert chat.expires_at == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert chat.is_private == true
      assert chat.name == "some name"
      assert chat.password == "some password"
    end

    test "create_chat/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.create_chat(@invalid_attrs)
    end

    test "update_chat/2 with valid data updates the chat" do
      chat = chat_fixture()
      assert {:ok, chat} = Core.update_chat(chat, @update_attrs)
      assert %Chat{} = chat
      assert chat.expires_at == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert chat.is_private == false
      assert chat.name == "some updated name"
      assert chat.password == "some updated password"
    end

    test "update_chat/2 with invalid data returns error changeset" do
      chat = chat_fixture()
      assert {:error, %Ecto.Changeset{}} = Core.update_chat(chat, @invalid_attrs)
      assert chat == Core.get_chat!(chat.id)
    end

    test "delete_chat/1 deletes the chat" do
      chat = chat_fixture()
      assert {:ok, %Chat{}} = Core.delete_chat(chat)
      assert_raise Ecto.NoResultsError, fn -> Core.get_chat!(chat.id) end
    end

    test "change_chat/1 returns a chat changeset" do
      chat = chat_fixture()
      assert %Ecto.Changeset{} = Core.change_chat(chat)
    end
  end

  describe "reports" do
    alias Pluto.Core.Report

    @valid_attrs %{message: "some message"}
    @update_attrs %{message: "some updated message"}
    @invalid_attrs %{message: nil}

    def report_fixture(attrs \\ %{}) do
      {:ok, report} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Core.create_report()

      report
    end

    test "list_reports/0 returns all reports" do
      report = report_fixture()
      assert Core.list_reports() == [report]
    end

    test "get_report!/1 returns the report with given id" do
      report = report_fixture()
      assert Core.get_report!(report.id) == report
    end

    test "create_report/1 with valid data creates a report" do
      assert {:ok, %Report{} = report} = Core.create_report(@valid_attrs)
      assert report.message == "some message"
    end

    test "create_report/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.create_report(@invalid_attrs)
    end

    test "update_report/2 with valid data updates the report" do
      report = report_fixture()
      assert {:ok, report} = Core.update_report(report, @update_attrs)
      assert %Report{} = report
      assert report.message == "some updated message"
    end

    test "update_report/2 with invalid data returns error changeset" do
      report = report_fixture()
      assert {:error, %Ecto.Changeset{}} = Core.update_report(report, @invalid_attrs)
      assert report == Core.get_report!(report.id)
    end

    test "delete_report/1 deletes the report" do
      report = report_fixture()
      assert {:ok, %Report{}} = Core.delete_report(report)
      assert_raise Ecto.NoResultsError, fn -> Core.get_report!(report.id) end
    end

    test "change_report/1 returns a report changeset" do
      report = report_fixture()
      assert %Ecto.Changeset{} = Core.change_report(report)
    end
  end
end
