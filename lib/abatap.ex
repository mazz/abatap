defmodule Abatap do
  @moduledoc """
  Generate a basic PNG avatar from first name and last name. Largely based on https://github.com/zhangsoledad/alchemic_avatar and code by Sergio Tapia.
  """

  defp to_rgb(color) do
    [r, g, b] = color
    "rgb(#{r},#{g},#{b})"
  end

  defp rgb_to_hex(r, g, b) when r in 0..255 when g in 0..255 when b in 0..255 do
    "~2.16.0B"
    |> List.duplicate(3)
    |> Enum.join()
    |> :io_lib.format([r, g, b])
    |> to_string
  end

  @doc """
  Generates an image using first name and last name of a user using imagemagick's convert command line tool.

  This function was cribbed from Sergio Tapia (https://sergiotapia.com/)

  https://elixirforum.com/t/generate-images-with-name-initials-using-elixir-and-imagemagick/12668

  options: [palette: :google]

  """

  def create_from_initials(first_name, last_name, options \\ []) when byte_size(first_name) > 0 and byte_size(last_name) > 0 do
    palette =
      case Keyword.get(options, :palette) do
        nil ->
          :google

        value ->
          value
      end

    bg_color =
      case palette do
        :google ->
          rgb_list = Abatap.Color.google_random()
          "#" <> "#{rgb_to_hex(Enum.at(rgb_list, 0), Enum.at(rgb_list, 1), Enum.at(rgb_list, 2))}"
        :iwanthue ->
          rgb_list = Abatap.Color.iwanthue_random()
          "#" <> "#{rgb_to_hex(Enum.at(rgb_list, 0), Enum.at(rgb_list, 1), Enum.at(rgb_list, 2))}"
      end

    dbg(bg_color)

    initials = "#{String.at(first_name, 0)}#{String.at(last_name, 0)}"

    image_path =
      System.tmp_dir!()
      |> Path.join(
        "#{initials}-#{Atom.to_string(palette)}-#{:os.system_time(:milli_seconds)}.png"
      )

    {:ok, avatar} = Image.Text.text!(initials, background_fill_color: bg_color, font_size: 512, padding: 280) |> Image.avatar(shape: :square, size: 512)

    Image.write!(avatar, image_path)
    {:ok, image_path}

  end
end
