json.extract! audio, :id, :name, :duration, :file, :created_at, :updated_at
json.url audio_url(audio, format: :json)
