class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  #skip_before_action :verify_authenticity_token
  rescue_from Stripe::CardError, with: :catch_exception
  protect_from_forgery
  require 'stripe'


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

=begin
  def getOrderItemsGivenOrderID (orid) #, userid)
    #products = Product.where(:pet_type => pet_type, :classification => classification).order(:name)
    #order = Order.find_by(order_d: orid, user_id: userid, status: 'Open')
    orderitems = OrderItem.where(:order_id => orid)
    logger.info orderitems
    return orderitems
  end
=end

  #API Endpoint
  def getOrderItemQuantity #input is user_id, product_id
    logger.info "===================== getOrderItemQuantity =========="
    logger.info params
    quantity = 0
    orderitems = getItems params[:user_id]
    if orderitems.length > 0 
      product = Product.find params[:product_id]
      logger.info ("HERE =====  ===== ==== ======= ====== = = =  =" + product)
      i = 0;
      until i == orderitems.length
        if (orderitems[i].product_id == product.id)
          quantity = orderitems[i].quantity
          #return 
        end
        i += 1
      end
    end
    logger.info "quantity = " + quantity
    render json: {data: quantity}
  end

  #API Endpoint
  def getOpenOrder 
    order = Order.find_by(user_id: params[:user_id], status: 'Open')
    render json: {data: order}
  end

  def getItems (userid)
    orderitems = []
    order = Order.find_by(user_id: userid, status: 'Open')
    if (order != nil)
      orderitems = OrderItem.where(:order_id => order.id)
    end
    return orderitems
  end

  #API Endpoint
  def getOrderItems #input is user_id
    orderitems = getItems params[:user_id]
    render json: {data: orderitems}
  end

  #API Endpoint
  def getCart #input is user_id
    logger.info "getCart"
    cart = []
    orderitems = getItems params[:user_id]
    logger.info orderitems
    if (orderitems.length > 0)
      logger.info "here"
      i = 0;
      until i == orderitems.length
        product = Product.find orderitems[i].product_id
        logger.info "her2"

        cartitem = {
          :id => product.id,
          :name => product.name,
          :image => product.image,
          :price => product.price,
          :quantity => orderitems[i].quantity,
          :order_item_id => orderitems[i].id
        }

        logger.info "her3"
        cart.append cartitem

        i += 1
      end
    end
    logger.info cart
    render json: {data: cart}
  end

  #API Endpoint
  def getCartItemCount #input is user_id
    orderitems = getItems params[:user_id]
    render json: {data: orderitems.length}
  end

  #  stock          :integer
  def updateStocks #input is user_id
    logger.info "============ updateStocks ============"
    orderitems = getItems params[:user_id]
    logger.info orderitems
    if (orderitems.length > 0)
      i = 0;
      until i == orderitems.length
        product = Product.find orderitems[i].product_id
        newstock = product.stock - orderitems[i].quantity
        product.update(:stock => newstock);

        i += 1
      end
    end

    order = Order.find_by(user_id: userid, status: 'Open')
    order.update(:status => 'Completed');

    render json: {data: 'Update Stocks Completed. Order Completed'}
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
    logger.info params[:stripeToken]
    logger.info params[:user_id]
    #logger.info params[:order_id]
    logger.info params[:stripeEmail]

    current_user = User.find params[:user_id]
    order = Order.find_by(user_id: current_user.id, status: 'Open')

    #order = Order.find params[:order_id]
    if order != nil
      logger.info order
    end

    customer = nil

    begin
      customer = Stripe::Customer.create(
        email: params[:stripeEmail],
        source: params[:stripeToken]
      )

      logger.info customer
    rescue Stripe::StripeError 
    end

    #begin
    #  StripeChargesServices.new( charges_params, current_user).call
    #rescue Stripe::StripeError 
    #end

    begin
      if (customer != nil)
        charge = Stripe::Charge.create({
          customer: customer.id,
          amount: 10,
          description: 'Rails Stripe customer',
          currency: 'usd',
        })

        logger.info charge
      end
    rescue Stripe::StripeError 
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
      #format.json  { render :json => charge }
      #format.html  { render :template => "charges/create"}
    #end

    def charges_params
      params.permit(:stripeEmail, :stripeToken, :order_id)
    end
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
