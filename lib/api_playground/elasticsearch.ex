defmodule ApiPlayground.Elasticsearch do
  @doc "Return a list of results from an Elasticsearch query."

  def search(opts \\ []) do
    # get options values or use defaults
    {api_key, elasticsearch_domain, elasticsearch_search_path, body} =
      {
        opts[:api_key] || System.fetch_env!("ELASTICSEARCH_API_KEY"),
        opts[:elasticsearch_domain] || System.fetch_env!("ELASTICSEARCH_DOMAIN"),
        opts[:elasticsearch_search_path] || System.fetch_env!("ELASTICSEARCH_SEARCH_PATH"),
        opts[:body] || File.read!(File.cwd!() <> "/data.gitignored/elasticsearch_body.json")
      }

    # make the request and return the search result hits
    Req.get!(
      url: URI.parse(elasticsearch_domain <> elasticsearch_search_path),
      headers: %{"Authorization" => "ApiKey #{api_key}", "Content-Type" => "application/json"},
      body: body
    ).body
    |> then(fn res ->
      # return search results or empty list
      (Map.has_key?(res, "hits") && Map.get(res, "hits") |> Map.get("hits")) || []
    end)
  end
end
