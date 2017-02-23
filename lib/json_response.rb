module JsonResponse
  STATUS_CODE = {
    success: 200,
    created: 201,
    error: 400,
    unauthorized: 401,
    not_found: 404
  }.freeze

  def self.template status, message, content
    {status: status, message: message, content: content}
  end

  class << self
    STATUS_CODE.each do |status, code|
      define_method status do |message = "", content = {}|
        template code, message, content
      end
    end
  end
end
