defmodule SchemexTest do
  use ExUnit.Case
  doctest Schemex

  setup do
    bypass = Bypass.open(port: 1111)
    {:ok, bypass: bypass}
  end

  test "config", %{bypass: bypass} do
    Bypass.expect_once bypass, "GET", "/config", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"compatibilityLevel": "BACKWARD"}>)
    end

    {:ok, resp} = Schemex.config("http://localhost:1111")
    assert resp == %{"compatibilityLevel" => "BACKWARD"}
  end

  test "subjects", %{bypass: bypass} do
    Bypass.expect_once bypass, "GET", "/subjects", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<["value", "value2"]>)
    end

    {:ok, resp} = Schemex.subjects("http://localhost:1111")
    assert resp == ["value", "value2"]
  end

  test "versions", %{bypass: bypass} do
    Bypass.expect_once bypass, "GET", "/subjects/value/versions", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<[1]>)
    end

    {:ok, resp} = Schemex.versions("http://localhost:1111", "value")
    assert resp == [1]
  end

  test "version", %{bypass: bypass} do
    Bypass.expect_once bypass, "GET", "/subjects/value/versions/1", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"subject":"value","version":1,"id":1,"schema":"\\"string\\""}>)
    end

    {:ok, resp} = Schemex.version("http://localhost:1111", "value", 1)
    assert resp == %{"id" => 1, "version" => 1, "subject" => "value", "schema" => "\"string\""}
  end

  test "latest", %{bypass: bypass} do
    Bypass.expect_once bypass, "GET", "/subjects/value/versions/latest", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"subject":"value","version":1,"id":1,"schema":"\\"string\\""}>)
    end

    {:ok, resp} = Schemex.latest("http://localhost:1111", "value")
    assert resp == %{"id" => 1, "version" => 1, "subject" => "value", "schema" => "\"string\""}
  end

  test "schema", %{bypass: bypass} do
    Bypass.expect_once bypass, "GET", "/schemas/ids/1", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"subject":"value","version":1,"id":1,"schema":"\\"string\\""}>)
    end

    {:ok, resp} = Schemex.schema("http://localhost:1111", 1)
    assert resp == %{"id" => 1, "version" => 1, "subject" => "value", "schema" => "\"string\""}
  end

  test "delete subject", %{bypass: bypass} do
    Bypass.expect_once bypass, "DELETE", "/subjects/value", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<[1, 2, 3]>)
    end

    {:ok, resp} = Schemex.delete("http://localhost:1111", "value")
    assert resp == [1, 2, 3]
  end

  test "delete version", %{bypass: bypass} do
    Bypass.expect_once bypass, "DELETE", "/subjects/value/versions/1", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<1>)
    end

    {:ok, resp} = Schemex.delete("http://localhost:1111", "value", 1)
    assert resp == 1
  end

  test "register", %{bypass: bypass} do
    Bypass.expect_once bypass, "POST", "/subjects/value/versions", fn conn ->
      ct = Enum.find(conn.req_headers, fn header ->
        header == {"content-type", "application/vnd.schemaregistry.v1+json"}
      end)
      assert ct != nil
      Plug.Conn.resp(conn, 200, ~s<{"id":1}>)
    end

    {:ok, resp} = Schemex.register("http://localhost:1111", "value", %{"type" => "string"})
    assert resp == %{"id" => 1}
  end

  test "check", %{bypass: bypass} do
    Bypass.expect_once bypass, "POST", "/subjects/value", fn conn ->
      ct = Enum.find(conn.req_headers, fn header ->
        header == {"content-type", "application/vnd.schemaregistry.v1+json"}
      end)
      assert ct != nil
      Plug.Conn.resp(conn, 200, ~s<{"subject":"value","version":1,"id":1,"schema":"\\"string\\""}>)
    end

    {:ok, resp} = Schemex.check("http://localhost:1111", "value", %{"type" => "string"})
    assert resp == %{"id" => 1, "schema" => "\"string\"", "subject" => "value", "version" => 1}
  end

  test "test", %{bypass: bypass} do
    Bypass.expect_once bypass, "POST", "/compatibility/subjects/value/versions/latest", fn conn ->
      ct = Enum.find(conn.req_headers, fn header ->
        header == {"content-type", "application/vnd.schemaregistry.v1+json"}
      end)
      assert ct != nil
      Plug.Conn.resp(conn, 200, ~s<{"is_compatible":true}>)
    end

    {:ok, resp} = Schemex.test("http://localhost:1111", "value", %{"type" => "string"})
    assert resp == %{"is_compatible" => true}
  end

  test "update subject compatibility", %{bypass: bypass} do
    Bypass.expect_once bypass, "PUT", "/config", fn conn ->
      ct = Enum.find(conn.req_headers, fn header ->
        header == {"content-type", "application/vnd.schemaregistry.v1+json"}
      end)
      assert ct != nil
      Plug.Conn.resp(conn, 200, ~s<{"compatibility":"NONE"}>)
    end

    {:ok, resp} = Schemex.update_compatibility("http://localhost:1111", "NONE")
    assert resp == %{"compatibility" => "NONE"}
  end

  test "update subject's version compatibility", %{bypass: bypass} do
    Bypass.expect_once bypass, "PUT", "/config/value", fn conn ->
      ct = Enum.find(conn.req_headers, fn header ->
        header == {"content-type", "application/vnd.schemaregistry.v1+json"}
      end)
      assert ct != nil
      Plug.Conn.resp(conn, 200, ~s<{"compatibility":"NONE"}>)
    end

    {:ok, resp} = Schemex.update_compatibility("http://localhost:1111", "value", "NONE")
    assert resp == %{"compatibility" => "NONE"}
  end
end
