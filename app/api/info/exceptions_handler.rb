module INFO
  module ExceptionsHandler
    extend ActiveSupport::Concern
    included do
      rescue_from JSON::ParserError do |e|
        error_response(message: "Wrong JSON format", status: 404)
      end
      
      rescue_from ActiveRecord::RecordNotFound do |e|
        error_response(message: e.message, status: 404)
      end

      rescue_from ActiveRecord::RecordInvalid do |e|
        error_response(message: e.message, status: 422)
      end

      rescue_from NameError do |e|
        error_response(message: e.message, status: 500)
      end

      rescue_from :all do |e|
        error_response(message: 'Internal server error', status: 500)
      end
    end
  end
end
