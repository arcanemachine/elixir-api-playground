defmodule HelloApi.Json.Openweather do
  @moduledoc "JSON-related functions for the OpenWeather API."
  alias Req

  @current_weather_endpoint "https://api.openweathermap.org/data/2.5/weather"

  @doc "Throws an exception if an API key has not been passed to the function."
  def ensure_api_key(api_key) do
    if is_nil(api_key),
      do:
        throw(
          "OPENWEATHER_API_KEY not set. You must either set it as an environment variable, or pass the `api_key` option to this function."
        )

    :ok
  end

  @doc """
  Makes a request to the OpenWeather API server for the current weather. Returns a Req response.

  Parameters:

    - api_key: The OpenWeather API key used to make the request
      - If the OPENWEATHER_API_KEY environment variable is present, then that value will be used.
        Otherwise, the `api_key` parameter MUST be present.

    - city: The city whose weather you are requesting. (default: "Grande Prairie")
      - The city name will be URL-encoded to ensure that special characters (e.g. spaces) are
        parsed correctly.

    - units: The units of measurement. (default: "standard")
  """
  def get_weather(opts \\ []) do
    # merge default opts with opts passed by user
    default_opts = [
      api_key: System.get_env("OPENWEATHER_API_KEY"),
      city: "Edmonton",
      units: "metric"
    ]

    opts = Keyword.merge(default_opts, opts)

    # ensure that we have an API key before continuing
    ensure_api_key(opts[:api_key])

    # send a request to the API server and return the response
    url =
      "#{@current_weather_endpoint}?q=#{URI.encode(opts[:city])}&appid=#{opts[:api_key]}&units=#{opts[:units]}"

    Req.get!(url)
  end

  @doc "Returns the current temperature from an OpenWeather API response."
  def get_temperature(res) do
    res.body["main"]["temp"]
  end
end
