class ExhibitSlipsController < ApplicationController

      def index
        @exhibit_slip = ExhibitSlip.new
        @slip_no = ExhibitSlip.select(:id,:slip_no).order(slip_no: :desc).all
        @staff = Staff.select(:id, :staff).where.order(:staff_no)
        @customer = Customer.select(:id, "name || '／' || kana AS customer").order(:kana)
        @exhibit_slip.date = Date.current
        @exhibit_slip.tax_class_id = 0
        @exhibit_slip.tax_rate = 0.08
        @sort = Sort.select(:sort_key, :sort).all
        gon.exhibit_artwork_id = []
      end

      def show
        id = params[:id]
        @exhibit_slip = ExhibitSlip.find(params[:id])
        @slip_no = ExhibitSlip.select(:id,:slip_no).order(slip_no: :desc).all
        @customer = Customer.select(:id, "name || '／' || kana AS customer").order(:kana)
        @staff = Staff.select(:id, :staff).order(:staff_no)
        @sort = Sort.select(:sort_key, :sort).all
        gon.exhibit_artwork_id = Artwork.includes({exhibits: :exhibit_slip},:artist,:category,:size).order(:artwork_no).where(exhibits: {id: nil})
                                         .pluck(:id, "artwork_no || '　　' || name || '／' || title || '／' || category AS artwork_no")
        gon.exhibit_data = Exhibit.includes({artwork: [:artist, :category, :size, :size_unit, :format]})
                                    .where(exhibit_slip_id: params[:id])
                                    .pluck_to_hash(:id, :artwork_id, :artwork_no, :name, :title, :category, "sizes.size", :size_unit, :format, :price,
                                                   :retail_price, :wholesale_price, :note)

        render action: :edit and return

      end

      def new
        @exhibit_slip = ExhibitSlip.new
        @slip_no = ExhibitSlip.select(:id,:slip_no).order(slip_no: :desc).all
        @staff = Staff.select(:id, :staff).where("company_id = 0").order(:staff_no)
        @customer = Customer.select("id, name || '／' || kana AS customer").order(:kana)
        @sort = Sort.select(:sort_key, :sort).all
        @exhibit_slip.date = Date.current
        @exhibit_slip.tax_class_id = 0
        @exhibit_slip.tax_rate = 0.08
        gon.exhibit_artwork_id = []
      end

      def create
        @exhibit_slip = ExhibitSlip.new(exhibit_slip_params)
        @counter = Counter.find_by(year: @exhibit_slip.date.year,company_id: 1)
        @exhibit_slip.slip_no = "E" + @exhibit_slip.date.to_s[2,2] + "-" + sprintf("%04d",@counter.exhibit)
        if @exhibit_slip.save
          @counter.exhibit = @counter.exhibit + 1
          @counter.save
          redirect_to @exhibit_slip
        else
          render 'new'
        end
      end

      def edit

      end

      def update
        @exhibit_slip = ExhibitSlip.find(params[:id])
        if @exhibit_slip.update_attributes exhibit_slip_params
          redirect_to @exhibit_slip
        else
          render action: :edit
        end
      end

      def artworkGet
        if params[:artwork_id] != '' and params[:artwork_id] != '0'
          @artwork_data = Artwork.includes(:artist, :category, :technique, :size).where(id: params[:artwork_id])
                                 .pluck_to_hash(:artwork_no, :name, :title, :category ,:technique)
          if params[:exhibit_id] == ''
            @exhibit = Exhibit.new
            @exhibit.exhibit_slip_id = params[:exhibit_slip_id]
            @exhibit.artwork_id = params[:artwork_id]
            @exhibit.price = params[:price]
            @exhibit.note = params[:note]
            if @exhibit.save

            end
          else
            @exhibit = Exhibit.find(params[:exhibit_id])
            @exhibit.artwork_id = params[:artwork_id]
            @exhibit.price = params[:price]
            @exhibit.note = params[:note]
            if @exhibit.save

            end
          end
          render json: @artwork_data
        end
      end

      def priceSet
        if params[:exhibit_id] != ''
          @exhibit = Exhibit.find(params[:exhibit_id])
          @exhibit.price = params[:price]
          @exhibit.note = params[:note]
          if @exhibit.save

          end
        end
      end

      private
      def exhibit_slip_params
        params.require(:exhibit_slip).permit(:slip_no, :customer_id, :date, :slip_class_id, :scheduled_date,:tax_class_id,
                                              :tax_rate, :staff_id, :note, :sort1, :sort2, :sort3)
      end
end
