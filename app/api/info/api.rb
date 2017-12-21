module INFO
  class Api < Grape::API
  	mount INFO::V1::Api
  end
end
