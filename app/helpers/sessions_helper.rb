module SessionsHelper
	def sign_in user
		cookies.permanent.signed[:remember_token] = [user.id, user.salt]
		current_user = user
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user
		@current_user ||= user_from_token
	end

	def user_from_token
		User.authenticate_with_salt(*remember_token)
	end

	def remember_token
		cookies.signed[:remember_token] || [nil, nil]
	end

	def signed_in?
		!current_user.nil?
	end

	def sign_out
		cookies.delete(:remember_token)
		current_user = nil
	end

	def deny_access
		store_location
		redirect_to signin_path, :notice => "Please signin to access this page"
	end

	def current_user?(user)
		current_user == user
	end

	def redirect_back_to(default)
		redirect_to(session[:return_to] || default)
		clear_location
	end

	def authenticate
    	deny_access unless signed_in?
  	end


	private

	def store_location
		session[:return_to] = request.fullpath 
	end

	def clear_location
		session[:return_to] = nil
	end
end
