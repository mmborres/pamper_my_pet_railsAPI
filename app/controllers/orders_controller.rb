class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  protect_from_forgery
  skip_before_action :verify_authenticity_token


  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def charge
    logger.info "============== ============ charge ============== ============"
    logger.info params
    logger.info params[:token]
    logger.info params[:user_id]
    logger.info params[:order_id]
    logger.info params[:email]

    order = Order.find params[:order_id]
    if order != nil
      logger.info order
    end
    
    #Stripe.api_key = Rails.configuration.stripe[:secret_key]

    #Stripe.api_key = "sk_test_wHMjQkNK1tkb4hrEJV1uDAFN00QoBprMuU"
    #"sk_test_4eC39HqLyjWDarjtT1zdp7dc" #"pk_test_TYooMQauvdEDq54NiTphI7jx"
    
    
    #Publishable pk_test_ityX5pdAjy1Pafnmggi18tND00HSzcZ6uS
    #Secret sk_test_wHMjQkNK1tkb4hrEJV1uDAFN00QoBprMuU
    
    # Amount in cents
    #@amount = 50

    #customer = Stripe::Customer.create({
      #email: params[:email],
      #source: params[:token],
      #email: params[:stripeEmail],
      #source: params[:stripeToken],
    #})

    #charge = Stripe::Charge.create({
      #customer: customer.id,
      #amount: @amount,
      #description: 'Rails Stripe customer',
      #currency: 'usd',
    #})


    #stripecharge = Stripe::Charge.create(
      #:customer    => params[:email],
      #:source        => params[:token],
      #:amount      => 200, #params[:amount],
      #:description => 'Rails Stripe customer',
      #:currency    => 'usd',
      #:pm_card_bypassPending => true
      #:cvc_check   => fail
    #)

    render json: {status: 'Payment Successful'} #, status: :ok

    # If in test mode, you can stick this here to inspect `charge` 
    # as long as you've imported byebug in your Gemfile
    #byebug

    #respond_to do |format|
    #  format.json  { render :json => charge }
    #  format.html  { render :template => "charges/create"}
    #end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:user_id, :status)
    end
end
