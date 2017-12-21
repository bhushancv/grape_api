module INFO
  module V1
    class Auth < Grape::API
      include INFO::ExceptionsHandler

      resource :auth do
        desc 'User signup'
        params do
          optional :first_name, type: String, desc: 'First name'
          optional :last_name, type: String, desc: 'Last name'
          requires :email, type: String, desc: 'Email'
          requires :password, type: String, desc: 'Password'
        end
        post :signup do
          user = User.new(
            :first_name => params[:first_name],
            :last_name => params[:last_name],
            :email => params[:email],
            :password => params[:password],
            :password_confirmation => params[:password],
          )
          user.save!
          {:message => "Signed up successfully", :authentication_token => user.authentication_token}
        end

        desc 'User login'
        params do
          requires :email, type: String, desc: 'Email'
          requires :password, type: String, desc: 'Password'
        end
        post :login do
          user = User.find_by_email(params[:email])
          if user.present? && user.valid_password?(params[:password])
            {:message => "Logged in successfully", :authentication_token => user.authentication_token}
          else
            error!("Invalid email or password", 403)
          end 
        end

        desc 'User logout'
        params do
          requires :email, type: String, desc: 'Email'
          requires :authentication_token, type: String, desc: 'Authentication Token'
        end
        get :logout do
          authenticate!
          current_user.authentication_token = nil
          current_user.save!
          {:message => "Logged out successfully"}
        end
			end
    end
  end
end    	
