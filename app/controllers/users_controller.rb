class UsersController < Clearance::UsersController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(first_name: user_params[:first_name], last_name: user_params[:last_name], email: user_params[:email])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        p @user.errors.full_messages
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user.email = user_params[:email]
    @user.first_name = user_params[:first_name]
    @user.last_name = user_params[:last_name]

    # Avatar updating / creating
    # Destroy the old avatar (if it exists) and make a new one
    if(@user.avatar != nil)
      @user.avatar.destroy
    end
    
    if(user_params[:avatar_image] != nil)
      new_avatar = Avatar.new(avatar_image: user_params[:avatar_image])
      new_avatar.user_id = @user.id
      new_avatar.save
    end


    if(@user.save)
      flash[:success] = "Successfully updated profile!"
      redirect_to user_path(@user.id)
    else
      flash[:error] = "Failed to update profile!"
      redirect_to user_path(@user.id)
    end

  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Account successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :avatar_image)
    end
end