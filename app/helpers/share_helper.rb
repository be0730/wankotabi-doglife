module ShareHelper
  def share_on_x_url(text:, url:, hashtags: [], via: nil)
    base = "https://twitter.com/intent/tweet"
    q = { text: text, url: url }
    q[:hashtags] = hashtags.join(",") if hashtags.present?
    q[:via]      = via if via.present?
    "#{base}?#{q.to_query}"
  end

  def add_utm(url, source: "x", medium: "social", campaign: "share")
    uri = URI.parse(url)
    params = Rack::Utils.parse_nested_query(uri.query)
    params.merge!("utm_source" => source, "utm_medium" => medium, "utm_campaign" => campaign)
    uri.query = params.to_query
    uri.to_s
  end
end
