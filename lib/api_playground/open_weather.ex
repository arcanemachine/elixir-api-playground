defmodule ApiPlayground.OpenWeather do
  @moduledoc "Functions related to the OpenWeather API."
  alias Req
  @current_weather_endpoint "https://api.openweathermap.org/data/2.5/weather"

  defp _ensure_api_key(api_key) do
    ## Throws an exception if an API key has not been passed to the function.
    if is_nil(api_key),
      do:
        throw(
          "OPENWEATHER_API_KEY not set. You must either set it as an environment variable, or pass the `api_key` option to this function."
        )

    :ok
  end

  @doc """
  Makes a request to the OpenWeather API server for the current weather.

  URL options (appended to the API URL):

    - `appid`: The OpenWeather API key used to make the request (default: nil)
      - If the OPENWEATHER_API_KEY environment variable is present, then that value will be used.
        Otherwise, the `appid` parameter MUST be present.

    - `mode`: The format of the data to be returned (default: "json")
      - Must be one of: "json", "xml"

    - `q`: The location of the weather you are requesting (default: "Grande Prairie")
      - The location name will be URL-encoded to ensure that special characters (e.g. spaces) are
        parsed correctly.

    - `units`: The units of measurement. (default: "standard")

  Non-URL options (stripped before generating the API URL query string):

    - `http_client`: The HTTP client used to make the request. (default: `:req`)
      - Must be one of: `:req`, `:httpoison`
      - This option exists only as a form of documentation in regards to how to use each client.
        - Notes:
          - Req automatically detects JSON responses in the body and decodes them into a map
          - HTTPoison returns a string which must manually be decoded (use `Jason.decode!/2`)
  """
  def current(opts \\ []) do
    # merge default opts with opts passed by user
    default_opts = [
      appid: System.get_env("OPENWEATHER_API_KEY"),
      q: "Grande Prairie",
      units: "metric",
      mode: "json",
      http_client: :req
    ]

    opts = Keyword.merge(default_opts, opts)

    # ensure that we have an API key before continuing
    _ensure_api_key(opts[:appid])

    # strip non-URL options before generating the query string for the API request URL
    {http_client, opts} = opts |> Keyword.pop(:http_client)

    # send a request to the API server and return the response
    url = "#{@current_weather_endpoint}?#{URI.encode_query(opts)}"

    case http_client do
      :req ->
        Req.get!(url)

      :httpoison ->
        HTTPoison.start()
        HTTPoison.get!(url)

      _ ->
        throw(~s|Option 'http_client' must be one of: :req, :httpoison|)
    end
  end

  @doc "Given an OpenWeather API response, returns the current temperature."
  def current_temperature(res) do
    res.body["main"]["temp"]
  end
end
