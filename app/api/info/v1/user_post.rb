module INFO
  module V1
    class UserPost < Grape::API
      include INFO::ExceptionsHandler

      params do
        requires :email, type: String, desc: 'Email'
        requires :authentication_token, type: String, desc: 'Authentication Token'
      end
      
      before do
        authenticate!
      end

      resource :posts do
        desc 'Create a post'
        params do
          requires :title, type: String, desc: 'Title'
          requires :body, type: String, desc: 'Description'
        end
        post do
          if current_user.present?
            Post.create!(
              :user_id => current_user.id,
              :title => params[:title],
              :body => params[:body]
            )
            {:message => "Post created successfully"}
          else
            error!("User not found", 404)
          end 
        end
      end  
    end
  end
end      
