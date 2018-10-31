module UsersHelper

	def current_user_is(user)
		(current_user.id == user.id)? true : false
	end


	def show_role
		if (signed_in?)

			case current_user.role

			when "superadmin"
				return content_tag :h2, :class => "red" do
					"Logged in as superadmin!"
				end

			when "moderator"
				return content_tag :h2, :class => "blue" do
					"Logged in as moderator!"
				end
			else
				return ""
			end
	
		else
			return ""
		end
	end

end