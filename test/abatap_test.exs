defmodule AbatapTest do
  use ExUnit.Case
  doctest Abatap

  describe "generates_an_avatar/1" do
    test "returns_google_light_avatar" do
      {:ok, filename} = Abatap.create_from_initials("john", "doe")

      assert File.exists?(filename)
    end

    test "returns_iwanthue_dark_avatar" do
      {:ok, filename} =
        Abatap.create_from_initials("john", "doe", [palette: :iwanthue, appearance: :dark])

      assert File.exists?(filename)
    end

    test "returns_google_dark_avatar" do
      {:ok, filename} =
        Abatap.create_from_initials("john", "doe", [palette: :google, appearance: :dark])

      assert File.exists?(filename)
    end

    test "returns_google_dark_avatar_size_1024" do
      {:ok, filename} =
        Abatap.create_from_initials("john", "doe", [palette: :google, appearance: :dark, size: 1024])

      assert File.exists?(filename)
    end

    test "returns_google_light_avatar_capitals" do
      {:ok, filename} = Abatap.create_from_initials("John", "Doe")

      assert File.exists?(filename)
    end

    test "returns_iwanthue_dark_avatar_capitals" do
      {:ok, filename} =
        Abatap.create_from_initials("John", "Doe", [palette: :iwanthue, appearance: :dark])

      assert File.exists?(filename)
    end

    test "returns_google_dark_avatar_capitals" do
      {:ok, filename} =
        Abatap.create_from_initials("John", "Doe", [palette: :google, appearance: :dark])

      assert File.exists?(filename)
    end

    test "returns_google_dark_avatar_size_1024_capitals" do
      {:ok, filename} =
        Abatap.create_from_initials("John", "Doe", [palette: :google, appearance: :dark, size: 1024])

      assert File.exists?(filename)
    end
  end
end
