class Rack::Attack
  throttle('req/ip', limit: 100, period: 5.minutes) do |req|
    if req.path.start_with?('/api') && req.get?
      req.ip
    end
  end

  throttle('logins/ip', limit: 5, period: 20.seconds) do |req|
    if req.path == '/api/v1/login' && req.post?
      req.ip
    end
  end

  throttle('logins/email', limit: 5, period: 20.seconds) do |req|
    if req.path == '/api/v1/login' && req.post?
      req.params['email'].to_s.downcase.gsub(/\s+/, "").presence
    end
  end

  self.blocklist('fail2ban login/email') do |req|
    Rack::Attack::Allow2Ban.filter(req.params['email'], maxretry: 20, findtime: 1.hour, bantime: 1.day) do
      req.path == '/api/v1/login' && req.post?
    end
  end

  safelist('allow assets and status checks') do |req|
    req.path.start_with?('/assets') ||
      req.path == '/favicon.ico' ||
      req.path == '/up'
  end

  ActiveSupport::Notifications.subscribe("rack.attack") do |name, start, finish, request_id, req|
    Rails.logger.info "Rack::Attack throttled #{req.env['rack.attack.match_type']} for #{req.ip} on path #{req.path}"
  end
end