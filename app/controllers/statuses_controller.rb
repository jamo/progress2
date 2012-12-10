class StatusesController < ApplicationController
  before_filter :authenticate_user, :only => [:index, :new, :edit, :create, :update, :add_one_to_tehty, :remove_one_from_tehty]
  # GET /statuses
  # GET /statuses.json
  def index
    return unless @current_user.admin
    @statuses = Status.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @statuses }
    end
  end

  # GET /statuses/1
  # GET /statuses/1.json
  def show
    @status = Status.find(params[:id])
    @pros = (@status.tehty / @status.yhteensa.to_f * 100).ceil 
    
    current_user
    if @current_user 
        @admin = @current_user.admin
      else
        @admin = false
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @status }
    end
  end

  # GET /statuses/new
  # GET /statuses/new.json
  def new
    return unless @current_user.admin
    @status = Status.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @status }
    end
  end

  # GET /statuses/1/edit
  def edit
    return unless @current_user.admin
    @status = Status.find(params[:id])
  end

  # POST /statuses
  # POST /statuses.json
  def create
    return unless @current_user.admin
    @status = Status.new(params[:status])

    respond_to do |format|
      if @status.save
        format.html { redirect_to @status, notice: 'Status was successfully created.' }
        format.json { render json: @status, status: :created, location: @status }
      else
        format.html { render action: "new" }
        format.json { render json: @status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /statuses/1
  # PATCH/PUT /statuses/1.json
  def update
    return unless @current_user.admin
    @status = Status.find(params[:id])

    respond_to do |format|
      if @status.update_attributes(params[:status])
        format.html { redirect_to @status, notice: 'Status was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /statuses/1
  # DELETE /statuses/1.json
  def destroy
    return unless @current_user.admin
    @status = Status.find(params[:id])
    @status.destroy

    respond_to do |format|
      format.html { redirect_to statuses_url }
      format.json { head :no_content }
    end
  end

  def add_one_to_tehty
    return unless @current_user.admin
    @status = Status.find(params[:id])
    @status.tehty +=1
    @status.save
    redirect_to status_path(@status)
  end

  def remove_one_from_tehty
    return unless @current_user.admin
    @status = Status.find(params[:id])
    @status.tehty -=1
    @status.tehty = 0 if @status.tehty < 0
    @status.save
    redirect_to status_path(@status)
  end

  private

    # Use this method to whitelist the permissible parameters. Example: params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
   # def status_params
   #   params.require(:status).permit(:name,:tehty, :yhteensa)
   # end
end
