class ApiConstraints
  def initialize(options)
    @default = options[:default]
    @version = options[:version]
  end

  def matches?(req)
    @default || req.headers['Accept'].to_s.include?("application/vnd.marketplace.v#{@version}")
  end
end