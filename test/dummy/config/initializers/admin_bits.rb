Rails.application.configure do
  config.assets.precompile += %w(admin_bits.css admin_bits.js)
end
