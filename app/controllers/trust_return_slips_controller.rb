class TrustReturnSlipsController < ApplicationController
  def index
    @trust_return_slip = TrustReturnSlip.new
    @slip_no = TrustReturnSlip.select(:id,:slip_no).order(slip_no: :desc).all
    @staff = Staff.select(:id, :staff).where("company_id = 0").order(:staff_no)
    @customer = Customer.select(:id, "name || '／' || kana AS customer").where("company_id = 0").order(:kana)
    @trust_return_slip.date = Date.current
    @sort = Sort.select(:sort_key, :sort).all
    gon.trust_return_artwork_id = Trust.includes({artwork: [:artist, :category, :technique, :size, :size_unit, :format]},:trust_returns).order(:id)
                                             .where(trust_returns: {id: nil}).pluck(:id, "artwork_no || '　　' || name || '／' || title AS artwork_no")
  end

  def show
    id = params[:id]
    @trust_return_slip = TrustReturnSlip.find(params[:id])
    @slip_no = TrustReturnSlip.select(:id,:slip_no).order(slip_no: :desc).all
    @customer = Customer.select(:id, "name || '／' || kana AS customer").where("company_id = 0").order(:kana)
    @staff = Staff.select(:id, :staff).where("company_id = 0").order(:staff_no)
    @sort = Sort.select(:sort_key, :sort).all
    gon.trust_return_artwork_id = Trust.includes({artwork: [:artist, :category, :technique, :size, :size_unit, :format]},:trust_returns, :trust_slip).order(:id)
                                             .where(trust_returns: {id: nil})
                                             .pluck(:id, "artwork_no || '　　' || name || '／' || title AS artwork_no")
    gon.trust_return_data = TrustReturn.includes(trust: [artwork: [:artist, :category, :technique, :size, :size_unit, :format]])
                                             .where(trust_return_slip_id: params[:id])
                                             .pluck_to_hash(:id, :trust_id,:artwork_id, :artwork_no, :name, :title, :category, "sizes.size", :size_unit, :format, :price,:note)

    render action: :edit
  end

  def new
    @trust_return_slip = TrustReturnSlip.new
    @slip_no = TrustReturnSlip.select(:id,:slip_no).order(slip_no: :desc).all
    @staff = Staff.select(:id, :staff).where("company_id = 0").order(:staff_no)
    @customer = Customer.select("id, name || '／' || kana AS customer").where("company_id = 0").order(:kana)
    @sort = Sort.select(:sort_key, :sort).all
    @trust_return_slip.date = Date.current
    gon.trust_return_artwork_id = Trust.includes({artwork: [:artist, :category, :technique, :size, :size_unit, :format]},:trust_returns).order(:id)
                                             .where(trust_returns: {id: nil}).pluck(:id, "artwork_no || '　　' || name || '／' || title AS artwork_no")
  end

  def create
    @trust_return_slip = TrustReturnSlip.new(trust_return_slip_params)
    @counter = Counter.find_by(year: @trust_return_slip.date.year,company_id: 1)
    @trust_return_slip.slip_no = "T" + @trust_return_slip.date.to_s[2,2] + "-" + sprintf("%04d",@counter.trust)
    if @trust_return_slip.save
      @counter.trust = @counter.trust + 1
      @counter.save
      redirect_to @trust_return_slip
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    @trust_return_slip = TrustReturnSlip.find(params[:id])
    if @trust_return_slip.update_attributes trust_return_slip_params
      redirect_to @trust_return_slip
    else
      render action: :edit
    end
  end

  def artworkGet
    if params[:trust_id] != '' and params[:trust_id] != '0'
      @artwork_data = Trust.includes({artwork: [:artist, :category, :technique, :size]}).where(id: params[:trust_id])
                             .pluck_to_hash(:artwork_no, :name, :title, :category , :technique, :price)
      if params[:id] == ''
        @trust_return = TrustReturn.new
        @trust_return.trust_return_slip_id = params[:trust_return_slip_id]
        @trust_return.trust_id = params[:trust_id]
        @trust_return.note = params[:note]
        if @trust_return.save

        end
      else
        @trust_return = TrustReturn.find(params[:id])
        @trust_return.trust_id = params[:trust_id]
        @trust_return.note = params[:note]
        if @trust_return.save

        end
      end
      render json: @artwork_data
    end
  end

  private
  def trust_return_slip_params
    params.require(:trust_return_slip).permit(:slip_no, :customer_id, :date, :staff_id, :note, :sort1, :sort2, :sort3)
  end
end
