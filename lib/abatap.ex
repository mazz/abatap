defmodule Abatap do
  @moduledoc """
  Generate a basic PNG avatar from first name and last name. Largely based on https://github.com/zhangsoledad/alchemic_avatar and code by Sergio Tapia.
  """

  @fill_color_light "rgba(255, 255, 255, 0.75)"
  @fill_color_dark "rgba(0, 0, 0, 0.65)"
  @font_filename Path.join(__DIR__, "data/Roboto-Medium")

  # 300/512
  @font_size_ratio 0.5859375

  defp to_rgb(color) do
    [r, g, b] = color
    "rgb(#{r},#{g},#{b})"
  end

  @doc """
  Generates an image using first name and last name of a user using imagemagick's convert command line tool.

  This function was cribbed from Sergio Tapia (https://sergiotapia.com/)

  https://elixirforum.com/t/generate-images-with-name-initials-using-elixir-and-imagemagick/12668

  options: [palette: :google, appearance: :light, size: 512]

  """
  def create_from_initials(first_name, last_name, options \\ [])
      when byte_size(first_name) > 0 and byte_size(last_name) > 0 do
    resolution = 72
    sampling_factor = 3

    palette =
      case Keyword.get(options, :palette) do
        nil ->
          :google

        value ->
          value
      end

    appearance =
      case Keyword.get(options, :appearance) do
        nil ->
          :light

        value ->
          value
      end

    size =
      case Keyword.get(options, :size) do
        nil ->
          512

        value ->
          value
      end

    font_size = Float.to_string(@font_size_ratio * size)

    bg_color =
      case palette do
        :google ->
          to_rgb(Abatap.Color.google_random())

        :iwanthue ->
          to_rgb(Abatap.Color.iwanthue_random())
      end

    fill_color =
      case appearance do
        :light ->
          @fill_color_light

        :dark ->
          @fill_color_dark
      end

    initials = "#{String.at(first_name, 0)}#{String.at(last_name, 0)}"

    image_path =
      System.tmp_dir!()
      |> Path.join(
        "#{initials}-#{Atom.to_string(palette)}-#{Atom.to_string(appearance)}-#{:os.system_time(:milli_seconds)}.png"
      )

    System.cmd("convert", [
      # sample up
      "-density",
      "#{resolution * sampling_factor}",
      # corrected size
      "-size",
      "#{size * sampling_factor}x#{size * sampling_factor}",
      # background color
      "xc:#{bg_color}",
      # text color
      "-fill",
      fill_color,
      # @fill_color,
      # font location
      "-font",
      "#{@font_filename}",
      # font size
      "-pointsize",
      font_size,
      # center text
      "-gravity",
      "center",
      # render text in the center
      "-annotate",
      "+0+0",
      "#{initials}",
      # sample down to reduce aliasing
      "-resample",
      "#{resolution}",
      image_path
    ])

    {:ok, image_path}
  end
end
