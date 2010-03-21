class LoggerCheck
  def initialize(app, &block)
    @app, @block = app, block
  end

  def call(env)
    logger = env['rack.logger']

    @app.call(env)
  ensure
    @block.call(logger)
  end
end

class ETagFixed < Rack::ETag
  def call(env)
    status, headers, body = @app.call(env)

    if !headers.has_key?('ETag')
      digest, body = digest_body(body)
      headers['ETag'] = %("#{digest}")
    end

    [status, headers, body]
  end

  private
  def digest_body(body)
    digest = Digest::MD5.new
    parts = []
    body.each do |part|
      digest << part
      parts << part
    end
    [digest.hexdigest, parts]
  end
end
