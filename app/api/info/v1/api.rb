module INFO
  module V1
    class Api < Grape::API
      version 'v1', using: :path, vendor: 'info'
      format :json
      prefix :api

      helpers do
        def authenticate_user_from_token!
          user = User.find_by_email(params[:email])
          if user.present? && Devise.secure_compare(user.authentication_token, params[:authentication_token])
            user
          end
        end

        def current_user
          @current_user ||= authenticate_user_from_token!
        end

        def authenticate!
          error!('401 Unauthorized', 401) unless current_user
        end
      end

      mount INFO::V1::Auth
      mount INFO::V1::UserPost
    end
  end
end
