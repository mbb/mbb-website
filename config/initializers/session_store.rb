# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
	:key         => '_madisonbrass_session',
	:secret      => '72cc14b6029f643dcf4a694e198560d8f34355a292dae00c1f28428e71aa5de805a7f121bf6ea992c7fe43a89607b43ea778be43d808525149af59cf52eb2800'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
