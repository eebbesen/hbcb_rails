json.array!(@bios) do |bio|
  json.extract! bio, :id, :first_name, :middle_name, :last_name, :name, :parish, :entered_service, :dates, :place_of_birth
  json.url bio_url(bio, format: :json)
end
