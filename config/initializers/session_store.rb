# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_sdaw_session',
  :secret      => 'd9750fa485f336f24c40fa0c4d806945c3d93796e411f29a8153647f83607ac7fb8b622ca50ddee86e963d91c6dc45f8d2346ea60c254f90c1269ff113aba0c4'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
