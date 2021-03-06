class VendorsController < ApplicationController
  def index
    @vendors = Vendor.all.select {|user| user.admin == false}
    p params[:search]
    if params[:search]
        if params[:search] == ""
          return @errors = "Please input a search!"
        end
        if params[:category] == "Center Code"
       return @vendors = Vendor.search(params[:search].to_i, params[:category]).order("created_at DESC").select {|user| user.admin == false}
      end
      @vendors = Vendor.search(params[:search], params[:category]).order("created_at DESC").select {|user| user.admin == false}
      
    else
      @vendors = Vendor.all.select {|user| user.admin == false}
    end
  end

  def new
  end

  def create
    @center_code = user_params[:center_code]
    p @center_code
    
    @user = Vendor.new(user_params)
    if @center_code == ""
        @user.errors.add(:center_code, "is needed")
      @errors = @user.errors.full_messages
      render :new
    else
    if @user.save
      redirect_to home_index_path
    else
      @errors = @user.errors.full_messages
      render :new
    end
  end
  end

  def edit
    @user = Vendor.find_by(id: params[:id])
  end

  def show
    @user = Vendor.find_by(id: params[:id])
  end

  def update
    @user = Vendor.find_by(id: params[:id])
    @center_code = @user.center_code
    
    # if @center_code == nil || @center_code == ""
    #     @user.errors.add(:center_code, "is needed")
    #   @errors = @user.errors.full_messages
    #   render :edit
    # else
      if @user.update_attributes(vendor_params)
        redirect_to root_path
      else
        @errors = @user.errors.full_messages
        render :edit
      end
    #end
  end

  

  private
  def vendor_params
    params.require(:vendor).permit(:first_name, :last_name, :email, :password, :admin, :center_code)
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :admin, :center_code)
  end
end
