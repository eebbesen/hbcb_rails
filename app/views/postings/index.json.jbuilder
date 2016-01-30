json.array!(@postings) do |posting|
  json.extract! posting, :id, :years, :position, :post, :district, :ship
  json.url posting_url(posting, format: :json)
end
