# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_sdaw-tv_session',
  :secret      => 'c6eb78dc37f5bcc80d99b7863d2f3b4a9148bf3738a472569dce11f2d9944838424acd8eb3ca412881a1be78cc20a334d4813b55291b37ac3e3ba7597472a87a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
