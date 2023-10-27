# elixir-api-playground

An Elixir library for me to explore the usage of JSON- and XML-powered APIs.

Also a dumping ground for notes related to the basic usage of various API-related libraries.

## OpenWeather API

- To retrieve the current weather:
  - JSON: `ApiPlayground.Openweather.current()`
  - XML: `ApiPlayground.Openweather.current(mode: "xml")`
- See the `ApiPlayground.Openweather` module/function documentation for more info.
- Example response body as pretty-printed JSON:

```json
{
  "coord": {
    "lon": -113.4687,
    "lat": 53.5501
  },
  "weather": [
    {
      "id": 600,
      "main": "Snow",
      "description": "light snow",
      "icon": "13n"
    }
  ],
  "base": "stations",
  "main": {
    "temp": -3.08,
    "feels_like": -7.75,
    "temp_min": -4.55,
    "temp_max": -1.39,
    "pressure": 1019,
    "humidity": 90
  },
  "visibility": 2503,
  "wind": {
    "speed": 3.6,
    "deg": 10
  },
  "snow": {
    "1h": 0.11
  },
  "clouds": {
    "all": 100
  },
  "dt": 1698043875,
  "sys": {
    "type": 2,
    "id": 2074442,
    "country": "CA",
    "sunrise": 1698070532,
    "sunset": 1698106835
  },
  "timezone": -21600,
  "id": 5946768,
  "name": "Edmonton",
  "cod": 200
}
```

## Jason Cheatsheet

- If you are using Req as your HTTP client, JSON responses will automatically be decoded to a map.

- If you are using HTTPoison as your HTTP client, you will need to decode the response manually:

  - `res.body |> Jason.decode(~s|{"hello": "world"}|)`

- Once the object has been decoded, you can interact with it like any other map:
  - `json = res.body |> Jsson.decode!(); IO.inspect(json["main"]["temp"])`

## Timex Cheatsheet

> TLDR: https://hexdocs.pm/timex/Timex.html#module-quickfast-introduction

- To use Timex: `use Timex`

- Erlang date format: e.g. `date = {{2023, 10, 22}, {22, 23, 07}}`

- To get the current date/time as an Erlang-formatted datetime tuple:

  - `date = :calendar.universal_time` or `date = :calendar.local_time`

- Convert an Erlang date tuple to a `%DateTime{}`: `date |> Timex.to_datetime()`

  - If no timezone is specified, the `%DateTime{}` will use UTC (`"Etc/UTC"`)
  - To specify a custom timezone:
    - `date |> Timex.to_datetime("America/Chicago")`

- Convert a string to a `%DateTime{}`:

  - Timex.parse("2023-10-22T22:23:07Z", "{ISO:Extended}")

- Convert a naive datetime to a timezone-aware datetime:

  - `Timex.to_datetime(naive_datetime)` (Will convert to UTC by default)
  - `Timex.to_datetime(naive_datetime, "America/Chicago")`

- Shift a date or time:

  - `Timex.shift(date, days: 1, minutes: -5)`

- Convert a datetime to a different timezone:

  - `Timezone.convert(datetime, timezone)`

- Specify the date in a given format:

  - Using the `:default` formatter: `Timex.format(datetime, "{YYYY}-{M}-{D}")`
  - Using the `:strftime` formatter: `Timex.format(datetime, "%Y-%m-%d", :strftime)`

- Get the diff between 2 dates: `Timex.diff(first_datetime, second_datetime)`

## SweetXml Cheatsheet

> DevHints XPath cheatsheet: https://devhints.io/xpath
> XPath Diner (CSS Diner clone): https://topswagcode.com/xpath/

- Import the module: `import SweetXml`

- Get an XML string to work with.

  - e.g. `xml_string = ApiPlayground.Openweather.current(mode: "xml").body`

- Parse the XML: `parsed_xml = SweetXml.parse(xml_string)`

- Query the parsed XML (or XML string): `SweetXml.parse(your_xml)`

Example XML data:

```xml
<?xml version="1.05" encoding="UTF-8"?>
<game>
  <matchups>
    <matchup winner-id="1">
      <name>Match One</name>
      <teams>
        <team>
          <id>1</id>
          <name>Team One</name>
        </team>
        <team>
          <id>2</id>
          <name>Team Two</name>
        </team>
      </teams>
    </matchup>
    <matchup winner-id="2">
      <name>Match Two</name>
      <teams>
        <team>
          <id>2</id>
          <name>Team Two</name>
        </team>
        <team>
          <id>3</id>
          <name>Team Three</name>
        </team>
      </teams>
    </matchup>
    <matchup winner-id="1">
      <name>Match Three</name>
      <teams>
        <team>
          <id>1</id>
          <name>Team One</name>
        </team>
        <team>
          <id>3</id>
          <name>Team Three</name>
        </team>
      </teams>
    </matchup>
  </matchups>
</game>
```

-
- Get the root element:

  - `xpath(xml, ~x"//*")` or `xpath(xml, ~x"//game")`

- Get the first matchup:

  - `xpath(xml, ~x"//matchups/matchup")` or `xpath(xml, ~x"//matchup")`
    - selectors can be skipped for brevity if needed

- Get the second matchup:

  - `xpath(xml, ~x"//matchup[2]")`
    - Note that the array indexing is 1-indexed, not 0-based

- Get the last matchup:

  - `xpath(xml, ~x"//matchup[last()]")`

- Get a list of all matchups:

  - `xpath(xml, ~x"//matchup"l)`

- Get the value of the `winner-id` attribute in the first matchup:

  - `xpath(xml, ~x"//matchup/@winner-id")`

- Get the text content of the name of the first matchup:

  - `xpath(xml, ~x"//matchup[2]/@winner-id")`

- Get a list of all `name` elements that contain the phrase `Match`:

  - `xpath(xml, ~x|//*[contains(text(),"Match")]|l)`

- Get all elements inside the first matchup:
  - `xpath(xml, ~x|//matchup/*|l)`
