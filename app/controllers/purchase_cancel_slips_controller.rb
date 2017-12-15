class PurchaseCancelSlipsController < ApplicationController
  def index
    @purchase_cancel_slip = PurchaseCancelSlip.new
    @slip_no = PurchaseCancelSlip.select(:id,:slip_no).order(slip_no: :desc).all
    @staff = Staff.select(:id, :staff).where("company_id = 0").order(:staff_no)
    @customer = Customer.select(:id, "name || '／' || kana AS customer").where("company_id = 0").order(:kana)
    @purchase_cancel_slip.date = Date.current
    @sort = Sort.select(:sort_key, :sort).all
    gon.purchase_cancel_artwork_id = Purchase.includes({artwork: [:artist, :category, :technique, :size, :size_unit, :format]},:purchase_cancels).order(:id)
                                             .where(purchase_cancels: {id: nil}).pluck(:id, "artwork_no || '　　' || name || '／' || title AS artwork_no")
  end

  def show
    id = params[:id]
    @purchase_cancel_slip = PurchaseCancelSlip.find(params[:id])
    @slip_no = PurchaseCancelSlip.select(:id,:slip_no).order(slip_no: :desc).all
    @customer = Customer.select(:id, "name || '／' || kana AS customer").where("company_id = 0").order(:kana)
    @staff = Staff.select(:id, :staff).where("company_id = 0").order(:staff_no)
    @sort = Sort.select(:sort_key, :sort).all
    gon.purchase_cancel_artwork_id = Purchase.includes({artwork: [:artist, :category, :technique, :size, :size_unit, :format]},:purchase_cancels, :purchase_slip).order(:id)
                                             .where(purchase_cancels: {id: nil})
                                             .pluck(:id, "artwork_no || '　　' || name || '／' || title AS artwork_no")
    gon.purchase_cancel_data = PurchaseCancel.includes(purchase: [artwork: [:artist, :category, :technique, :size, :size_unit, :format]])
                                             .where(purchase_cancel_slip_id: params[:id])
                                             .pluck_to_hash(:id, :purchase_id,:artwork_id, :artwork_no, :name, :title, :category, "sizes.size", :size_unit, :format, :price,:note)

    render action: :edit
  end

  def new
    @purchase_cancel_slip = PurchaseCancelSlip.new
    @slip_no = PurchaseCancelSlip.select(:id,:slip_no).order(slip_no: :desc).all
    @staff = Staff.select(:id, :staff).where("company_id = 0").order(:staff_no)
    @customer = Customer.select("id, name || '／' || kana AS customer").where("company_id = 0").order(:kana)
    @sort = Sort.select(:sort_key, :sort).all
    @purchase_cancel_slip.date = Date.current
    gon.purchase_cancel_artwork_id = Purchase.includes({artwork: [:artist, :category, :technique, :size, :size_unit, :format]},:purchase_cancels).order(:id)
                                             .where(purchase_cancels: {id: nil}).pluck(:id, "artwork_no || '　　' || name || '／' || title AS artwork_no")
  end

  def create
    @purchase_cancel_slip = PurchaseCancelSlip.new(purchase_cancel_slip_params)
    @counter = Counter.find_by(year: @purchase_cancel_slip.date.year,company_id: 1)
    @purchase_cancel_slip.slip_no = "S" + @purchase_cancel_slip.date.to_s[2,2] + "-" + sprintf("%04d",@counter.purchase)
    if @purchase_cancel_slip.save
      @counter.purchase = @counter.purchase + 1
      @counter.save
      redirect_to @purchase_cancel_slip
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    @purchase_cancel_slip = PurchaseCancelSlip.find(params[:id])
    if @purchase_cancel_slip.update_attributes purchase_cancel_slip_params
      redirect_to @purchase_cancel_slip
    else
      render action: :edit
    end
  end

  def artworkGet
    if params[:purchase_id] != '' and params[:purchase_id] != '0'
      @artwork_data = Purchase.includes({artwork: [:artist, :category, :technique, :size]}).where(id: params[:purchase_id])
                             .pluck_to_hash(:artwork_no, :name, :title, :category , :technique, :price)
      if params[:id] == ''
        @purchase_cancel = PurchaseCancel.new
        @purchase_cancel.purchase_cancel_slip_id = params[:purchase_cancel_slip_id]
        @purchase_cancel.purchase_id = params[:purchase_id]
        @purchase_cancel.note = params[:note]
        if @purchase_cancel.save

        end
      else
        @purchase_cancel = PurchaseCancel.find(params[:id])
        @purchase_cancel.purchase_id = params[:purchase_id]
        @purchase_cancel.note = params[:note]
        if @purchase_cancel.save

        end
      end
      render json: @artwork_data
    end
  end

  private
  def purchase_cancel_slip_params
    params.require(:purchase_cancel_slip).permit(:slip_no, :customer_id, :date, :staff_id, :note, :sort1, :sort2, :sort3)
  end
end
