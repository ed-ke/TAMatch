Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, "488709834553-mn0prb7hjumj2p4g6emf42jcmnsqrgo6.apps.googleusercontent.com", "pna3sAqDgFf3gg6Sis8gmLEB",
  scope: 'profile', image_aspect_ratio: 'square', image_size: 48, access_type: 'online', name: 'google'
end
