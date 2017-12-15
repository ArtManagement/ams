class ConsignSlipsController < ApplicationController
  def index
    @consign_slip = ConsignSlip.new
    @slip_no = ConsignSlip.select(:id,:slip_no).order(slip_no: :desc).all
    @staff = Staff.select(:id, :staff).where("company_id = 0").order(:staff_no)
    @customer = Customer.select(:id, "name || '／' || kana AS customer").where("company_id = 0").order(:kana)
    @consign_slip.date = Date.current
    @consign_slip.tax_class_id = 0
    @consign_slip.tax_rate = 0.08
    @sort = Sort.select(:sort_key, :sort).all
    gon.consign_artwork_id= []
  end

  def show
    id = params[:id]
    @consign_slip = ConsignSlip.find(params[:id])
    @slip_no = ConsignSlip.select(:id,:slip_no).order(slip_no: :desc).all
    @customer = Customer.select(:id, "name || '／' || kana AS customer").where("company_id = 0").order(:kana)
    @staff = Staff.select(:id, :staff).where("company_id = 0").order(:staff_no)
    @sort = Sort.select(:sort_key, :sort).all
    artwork_sql =
    " SELECT
        a.id AS id,
        a.artwork_no || '　　' ||
        coalesce(at.name,'') ||
        CASE WHEN a.title = ''
             THEN ''
             ELSE '／'
        END ||
        a.title ||
        CASE WHEN coalesce(si.size,'') = '' AND a.edition = '' AND coalesce(to_char(a.edition_no,'9999'),'') = '' AND coalesce(to_char(a.edition_limit,'9999'),'') = ''
             THEN ''
             ELSE '／'
        END ||
        CASE WHEN coalesce(si.size,'') != ''
             THEN coalesce(su.size_unit,'') || coalesce(si.size,'')
             ELSE a.edition || CASE WHEN a.edition = ''
                                    THEN ''
                                    ELSE ':'
                               END
                            || coalesce(to_char(a.edition_no,'9999'),'')
                            || CASE WHEN a.edition_limit IS NULL
                                    THEN ''
                                    ELSE '/'
                               END
                            || coalesce(to_char(a.edition_limit,'9999'),'')
        END ||
        CASE WHEN coalesce(te.technique,'') = '' AND coalesce(ca.category,'') = ''
             THEN ''
             ELSE '／'
        END ||
        CASE WHEN te.technique IS NOT NULL
             THEN coalesce(te.technique,'')
             ELSE coalesce(ca.category,'')
        END ||
        CASE WHEN coalesce(fo.format,'') = ''
             THEN ''
            ELSE '／'
        END ||
        coalesce(fo.format,'') AS artwork
      FROM
        artworks AS a
        LEFT OUTER JOIN artists AS at ON a.artist_id = at.id
        LEFT OUTER JOIN sizes AS si ON a.size_id = si.id
        LEFT OUTER JOIN size_units AS su ON a.size_unit_id = su.id
        LEFT OUTER JOIN categories AS ca ON a.category_id = ca.id
        LEFT OUTER JOIN techniques AS te ON a.technique_id = te.id
        LEFT OUTER JOIN formats AS fo ON a.format_id = fo.id
        LEFT OUTER JOIN purchases AS p ON p.artwork_id = a.id
          AND NOT EXISTS ( SELECT * FROM purchase_cancels AS pc WHERE p.id = pc.purchase_id )
        LEFT OUTER JOIN trusts AS t ON t.artwork_id = a.id
          AND NOT EXISTS ( SELECT * FROM trust_returns AS tr WHERE t.id = tr.trust_id )
        LEFT OUTER JOIN sales AS s ON s.artwork_id = a.id
          AND NOT EXISTS ( SELECT * FROM sale_cancels AS sc WHERE s.id = sc.sale_id )
        LEFT OUTER JOIN consigns AS c ON c.artwork_id = a.id
          AND NOT EXISTS ( SELECT * FROM consign_returns AS cr WHERE c.id = cr.consign_id )
      WHERE (p.id IS NOT NULL OR t.id IS NOT NULL)
      AND   c.id IS NULL AND s.id IS NULL
      UNION SELECT
        0 AS id ,
        '' AS artwork_no
      ORDER BY id "

    consign_sql =
    " SELECT
        c.id AS id,
        c.artwork_id AS artwork_id,
        a.artwork_no AS artwork_no,
        at.name AS name,
        a.title,
        CASE WHEN (a.size_id != 0) AND (a.size_id IS NOT NULL)
             THEN coalesce(si.size,'') || coalesce(su.size_unit,'')
             ELSE a.edition || CASE WHEN a.edition = ''
                                    THEN ''
                                    ELSE ':'
                               END
                            || coalesce(to_char(a.edition_no,'9999'),'')
                            || CASE WHEN a.edition_limit IS NULL
                                    THEN ''
                                    ELSE '/'
                               END
                            || coalesce(to_char(a.edition_limit,'9999'),'')
        END AS size,
        CASE WHEN (a.technique_id != 0) AND (te.technique IS NOT NULL)
             THEN te.technique
             ELSE ca.category
        END AS category,
        fo.format AS formats,
        CASE WHEN p.id IS NULL AND t.id IS NOT NULL
             THEN '受託'
             ELSE ''
        END AS status,
        CASE WHEN c.price = 0
             THEN NULL
             ELSE c.price
        END AS price,
        a.retail_price AS retail_price,
        a.wholesale_price AS wholesale_price,
        p.price * ps.tax_rate * ps.tax_class_id AS tax,
        p.price + (p.price * ps.tax_rate * ps.tax_class_id) AS cost,
        c.note AS note
      FROM
        consigns AS c,
        consign_slips AS cs,
        artworks AS a
        LEFT OUTER JOIN artists AS at ON a.artist_id = at.id
        LEFT OUTER JOIN sizes AS si ON a.size_id = si.id
        LEFT OUTER JOIN size_units AS su ON a.size_unit_id = su.id
        LEFT OUTER JOIN categories AS ca ON a.category_id = ca.id
        LEFT OUTER JOIN techniques AS te ON a.technique_id = te.id
        LEFT OUTER JOIN formats AS fo ON a.format_id = fo.id
        LEFT OUTER JOIN purchases AS p ON p.artwork_id = a.id
        AND NOT EXISTS ( SELECT * FROM purchase_cancels AS pc WHERE p.id = pc.purchase_id )
          LEFT OUTER JOIN purchase_slips AS ps ON p.purchase_slip_id = ps.id
        LEFT OUTER JOIN trusts AS t ON t.artwork_id = a.id
        AND NOT EXISTS ( SELECT * FROM trust_returns AS tr WHERE t.id = tr.trust_id )
          LEFT OUTER JOIN trust_slips AS ts ON t.trust_slip_id = ts.id
      WHERE c.consign_slip_id = cs.id
      AND   c.artwork_id = a.id
      AND   cs.id = ? "
    gon.consign_artwork_id = Artwork.find_by_sql([artwork_sql]).pluck(:id,:artwork)
    gon.consign_data = Consign.find_by_sql([consign_sql,params[:id]])
    render action: :edit
  end

  def new
    @consign_slip = ConsignSlip.new
    @slip_no = ConsignSlip.select(:id,:slip_no).order(slip_no: :desc).all
    @staff = Staff.select(:id, :staff).where("company_id = 0").order(:staff_no)
    @customer = Customer.select("id, name || '／' || kana AS customer").where("company_id = 0").order(:kana)
    @sort = Sort.select(:sort_key, :sort).all
    @consign_slip.date = Date.current
    @consign_slip.tax_class_id = 0
    @consign_slip.tax_rate = 0.08
    gon.consign_artwork_id = []
  end

  def create
    @consign_slip = ConsignSlip.new(consign_slip_params)
    @counter = Counter.find_by(year: @consign_slip.date.year,company_id: 1)
    @consign_slip.slip_no = "C" + @consign_slip.date.to_s[2,2] + "-" + sprintf("%04d",@counter.consign)
    if @consign_slip.save
      @counter.consign = @counter.consign + 1
      @counter.save
      redirect_to @consign_slip
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    @consign_slip = ConsignSlip.find(params[:id])
    if @consign_slip.update_attributes consign_slip_params
      redirect_to @consign_slip
    else
      render action: :edit
    end
  end

  def artworkGet
    if params[:artwork_id] != '' and params[:artwork_id] != '0'
       @artwork_data = Artwork.includes(:artist, :category, :technique, :size, :size_unit).where(id: params[:artwork_id])
                       .pluck_to_hash(:artwork_no, :name, :title, 'CASE WHEN technique IS NOT NULL THEN technique ELSE category END AS category')

      if params[:consign_id] == ''
        @consign = Consign.new
        @consign.consign_slip_id = params[:consign_slip_id]
        @consign.artwork_id = params[:artwork_id]
        @consign.price = params[:price]
        @consign.note = params[:note]
        if @consign.save

        end
      else
        @consign = Consign.find(params[:consign_id])
        @consign.artwork_id = params[:artwork_id]
        @consign.price = params[:price]
        @consign.note = params[:note]
        if @consign.save

        end
      end
      render json: @artwork_data
    end
  end

  def priceSet
    if params[:consign_id] != ''
      @consign = Consign.find(params[:consign_id])
      @consign.price = params[:price]
      @consign.note = params[:note]
      if @consign.save

      end
    end
  end

  private
  def consign_slip_params
    params.require(:consign_slip).permit(:slip_no, :customer_id, :date, :slip_class_id, :scheduled_date,:tax_class_id,
                                          :tax_rate, :staff_id, :note, :sort1, :sort2, :sort3)
  end
end
