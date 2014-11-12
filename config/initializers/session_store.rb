redis_namespace = "identity-enhancement-service:#{Rails.env}:session"
session_store_opts = {
  redis_server: "redis://127.0.0.1:6379/0/#{redis_namespace}",
  expire_in: 3600,
  key: '_identity-enhancement-service_session'
}

Rails.application.config.session_store(:redis_store, session_store_opts)
