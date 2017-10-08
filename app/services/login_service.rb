class LoginService
  URL = "https://secure.mealpal.com/1/login"

  def initialize(username, password)
    @request = set_request(username, password)
  end

  def perform
    @response = @request.run
  end

  def success?
    @response.success?
  end

  private

  def set_request(username, password)
    Typhoeus::Request.new(
      URL,
      method: :post,
      body: {
        username: username,
        password: password
      },
      cookiejar: "./tmp/cookies"
    )
  end
end
