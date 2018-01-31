class PaymentSlipsController < ApplicationController
  def index
    @payment_slip = PaymentSlip.new
    @slip_no = PaymentSlip.select(:id,:slip_no).order(slip_no: :desc).all
    @staff = Staff.select(:id, :staff).order(:staff_no)
    @customer = Customer.select(:id, "name || '／' || kana AS customer").order(:kana)
    @payment_slip.date = Date.current
    @sort = Sort.select(:sort_key, :sort).all
    gon.payment_artwork_id = []
  end

  def show
    id = params[:id]
    @payment_slip = PaymentSlip.find(params[:id])
    @slip_no = PaymentSlip.select(:id,:slip_no).order(slip_no: :desc).all
    @customer = Customer.select(:id, "name || '／' || kana AS customer").order(:kana)
    @staff = Staff.select(:id, :staff).order(:staff_no)
    @sort = Sort.select(:sort_key, :sort).all
    gon.payment_artwork_id = Purchase.includes({artwork: [:artist, :category, :technique, :size, :size_unit, :format]},:payments, :purchase_slip).order(:id)
                                             .where(payments: {id: nil})
                                             .pluck(:id, "artwork_no || '　　' || name || '／' || title AS artwork_no")
    gon.payment_data = Payment.includes(purchase: [artwork: [:artist, :category, :technique, :size, :size_unit, :format]])
                                             .where(payment_slip_id: params[:id])
                                             .pluck_to_hash(:id, :purchase_id,:artwork_id, :artwork_no, :name, :title, :category, "sizes.size", :size_unit, :format, :price,:note)

    render action: :edit

  end

  def new
    @payment_slip = PaymentSlip.new
    @slip_no = PaymentSlip.select(:id,:slip_no).order(slip_no: :desc).all
    @staff = Staff.select(:id, :staff).order(:staff_no)
    @customer = Customer.select("id, name || '／' || kana AS customer").order(:kana)
    @sort = Sort.select(:sort_key, :sort).all
    @payment_slip.date = Date.current
    gon.payment_artwork_id = []
  end

  def create
    @payment_slip = PaymentSlip.new(payment_slip_params)
    @counter = Counter.find_by(year: @payment_slip.date.year,company_id: 1)
    @payment_slip.slip_no = "P" + @payment_slip.date.to_s[2,2] + "-" + sprintf("%04d",@counter.payment)
    if @payment_slip.save
      @counter.payment = @counter.payment + 1
      @counter.save
      redirect_to @payment_slip
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    @payment_slip = PaymentSlip.find(params[:id])
    if @payment_slip.update_attributes payment_slip_params
      redirect_to @payment_slip
    else
      render action: :edit
    end
  end

  def artworkGet
    if params[:purchase_id] != '' and params[:purchase_id] != '0'
      @artwork_data = Purchase.includes({artwork: [:artist, :category, :technique, :size]}).where(id: params[:purchase_id])
                             .pluck_to_hash(:artwork_no, :name, :title, :category , :technique, :price)
      if params[:payment_id] == ''
        @payment = Payment.new
        @payment.payment_slip_id = params[:payment_slip_id]
        @payment.purchase_id = params[:purchase_id]
        @payment.amount = params[:amount]
        @payment.note = params[:note]
        if @payment.save

        end
      else
        @payment = Payment.find(params[:payment_id])
        @payment.purchase_id = params[:purchase_id]
        @payment.amount = params[:amount]
        @payment.note = params[:note]
        if @payment.save

        end
      end
      render json: @artwork_data
    end
  end

  def priceSet
    if params[:payment_id] != ''
      @payment = Payment.find(params[:payment_id])
      @payment.amount = params[:amount]
      @payment.note = params[:note]
      if @payment.save

      end
    end
  end

  private

  def payment_slip_params
    params.require(:payment_slip).permit(:slip_no, :customer_id, :date, :slip_class_id,
                                         :staff_id, :note, :sort1, :sort2, :sort3)
  end

end
