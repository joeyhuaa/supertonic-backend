if Rails.env === 'production' 
  # todo - change the domain!
  Rails.application.config.session_store :cookie_store, key: 'supertonic', domain: 'https://supertonic-frontend.herokuapp.com'
else
  Rails.application.config.session_store :cookie_store, key: 'supertonic' 
end