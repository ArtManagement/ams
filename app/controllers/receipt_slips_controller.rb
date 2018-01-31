class ReceiptSlipsController < ApplicationController
  def index
    @receipt_slip = ReceiptSlip.new
    @slip_no = ReceiptSlip.select(:id,:slip_no).order(slip_no: :desc).all
    @staff = Staff.select(:id, :staff).order(:staff_no)
    @customer = Customer.select(:id, "name || '／' || kana AS customer").order(:kana)
    @receipt_slip.date = Date.current
    @sort = Sort.select(:sort_key, :sort).all
    gon.receipt_artwork_id = []
  end

  def show
    id = params[:id]
    @receipt_slip = ReceiptSlip.find(params[:id])
    @slip_no = ReceiptSlip.select(:id,:slip_no).order(slip_no: :desc).all
    @customer = Customer.select(:id, "name || '／' || kana AS customer").order(:kana)
    @staff = Staff.select(:id, :staff).order(:staff_no)
    @sort = Sort.select(:sort_key, :sort).all
    gon.receipt_artwork_id = Purchase.includes({artwork: [:artist, :category, :technique, :size, :size_unit, :format]},:receipts, :sale_slip).order(:id)
                                             .where(receipts: {id: nil})
                                             .pluck(:id, "artwork_no || '　　' || name || '／' || title AS artwork_no")
    gon.receipt_data = Receipt.includes(sale: [artwork: [:artist, :category, :technique, :size, :size_unit, :format]])
                                             .where(receipt_slip_id: params[:id])
                                             .pluck_to_hash(:id, :sale_id,:artwork_id, :artwork_no, :name, :title, :category, "sizes.size", :size_unit, :format, :price,:note)

    render action: :edit

  end

  def new
    @receipt_slip = ReceiptSlip.new
    @slip_no = ReceiptSlip.select(:id,:slip_no).order(slip_no: :desc).all
    @staff = Staff.select(:id, :staff).order(:staff_no)
    @customer = Customer.select("id, name || '／' || kana AS customer").order(:kana)
    @sort = Sort.select(:sort_key, :sort).all
    @receipt_slip.date = Date.current
    gon.receipt_artwork_id = []
  end

  def create
    @receipt_slip = ReceiptSlip.new(receipt_slip_params)
    @counter = Counter.find_by(year: @receipt_slip.date.year,company_id: 1)
    @receipt_slip.slip_no = "R" + @receipt_slip.date.to_s[2,2] + "-" + sprintf("%04d",@counter.receipt)
    if @receipt_slip.save
      @counter.receipt = @counter.receipt + 1
      @counter.save
      redirect_to @receipt_slip
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    @receipt_slip = ReceiptSlip.find(params[:id])
    if @receipt_slip.update_attributes receipt_slip_params
      redirect_to @receipt_slip
    else
      render action: :edit
    end
  end

  def artworkGet
    if params[:sale_id] != '' and params[:sale_id] != '0'
      @artwork_data = Purchase.includes({artwork: [:artist, :category, :technique, :size]}).where(id: params[:sale_id])
                             .pluck_to_hash(:artwork_no, :name, :title, :category , :technique, :price)
      if params[:receipt_id] == ''
        @receipt = Receipt.new
        @receipt.receipt_slip_id = params[:receipt_slip_id]
        @receipt.sale_id = params[:sale_id]
        @receipt.amount = params[:amount]
        @receipt.note = params[:note]
        if @receipt.save

        end
      else
        @receipt = Receipt.find(params[:receipt_id])
        @receipt.sale_id = params[:sale_id]
        @receipt.amount = params[:amount]
        @receipt.note = params[:note]
        if @receipt.save

        end
      end
      render json: @artwork_data
    end
  end

  def priceSet
    if params[:receipt_id] != ''
      @receipt = Receipt.find(params[:receipt_id])
      @receipt.amount = params[:amount]
      @receipt.note = params[:note]
      if @receipt.save

      end
    end
  end

  private

  def receipt_slip_params
    params.require(:receipt_slip).permit(:slip_no, :customer_id, :date, :slip_class_id,
                                         :staff_id, :note, :sort1, :sort2, :sort3)
  end

end
