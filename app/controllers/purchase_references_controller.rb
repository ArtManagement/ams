class PurchaseReferencesController < ApplicationController
  def index
    @sort = Sort.select(:sort_key, :sort).all
    @artist = Artist.select(:id, "name || '／' || kana AS artist").all.order(:kana)
    @category = Category.select(:id, :category).all.order(:id)
    @technique = Technique.select(:id, :technique).all.order(:id)
    @format = Format.select(:id, :format).all.order(:id)
    sql =
    "SELECT
       a.id AS id,
       a.artwork_no AS artwork_no,
       at.name AS artist,
       a.title,
       CASE WHEN (a.size_id != 0) AND (a.size_id IS NOT NULL)
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
       END AS size,
       CASE WHEN (a.technique_id != 0) AND (t.technique IS NOT NULL)
            THEN t.technique
            ELSE c.category
       END AS category,
       f.format AS formats,
       CASE WHEN tr.price = 0
            THEN NULL
            ELSE tr.price
       END AS trust_price,
       CASE WHEN tr.price * ts.tax_rate * ts.tax_class_id = 0
            THEN NULL
            ELSE tr.price * ts.tax_rate * ts.tax_class_id
       END AS trust_tax,
       ps.slip_no AS purchase_slip_no,
       ts.slip_no AS trust_slip_no
     FROM
       artworks AS a
       LEFT OUTER JOIN artists AS at ON a.artist_id = at.id
       LEFT OUTER JOIN categories AS c ON a.category_id = c.id
       LEFT OUTER JOIN techniques AS t ON a.technique_id = t.id
       LEFT OUTER JOIN sizes AS si ON a.size_id = si.id
       LEFT OUTER JOIN size_units AS su ON a.size_unit_id = su.id
       LEFT OUTER JOIN formats AS f ON a.format_id = f.id
       LEFT OUTER JOIN purchases AS p ON a.id = p.artwork_id
         LEFT OUTER JOIN purchase_slips AS ps ON p.purchase_slip_id = ps.id
       LEFT OUTER JOIN trusts AS tr ON a.id = tr.artwork_id
         LEFT OUTER JOIN trust_slips AS ts ON tr.trust_slip_id = ts.id
     WHERE
       p.id IS NULL "
     gon.purchase_reference =  Purchase.find_by_sql([sql])
  end

  def search
    sql =
    "SELECT
       a.id AS id,
       a.artwork_no AS artwork_no,
       at.name AS artist,
       a.title,
       CASE WHEN (a.size_id != 0) AND (a.size_id IS NOT NULL)
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
       END AS size,
       CASE WHEN (a.technique_id != 0) AND (t.technique IS NOT NULL)
            THEN t.technique
            ELSE c.category
       END AS category,
       f.format AS formats,
       CASE WHEN tr.price = 0
            THEN NULL
            ELSE tr.price
       END AS trust_price,
       CASE WHEN tr.price * ts.tax_rate * ts.tax_class_id = 0
            THEN NULL
            ELSE tr.price * ts.tax_rate * ts.tax_class_id
       END AS trust_tax,
       ps.slip_no AS purchase_slip_no,
       ts.slip_no AS trust_slip_no
     FROM
       artworks AS a
       LEFT OUTER JOIN artists AS at ON a.artist_id = at.id
       LEFT OUTER JOIN categories AS c ON a.category_id = c.id
       LEFT OUTER JOIN techniques AS t ON a.technique_id = t.id
       LEFT OUTER JOIN sizes AS si ON a.size_id = si.id
       LEFT OUTER JOIN size_units AS su ON a.size_unit_id = su.id
       LEFT OUTER JOIN formats AS f ON a.format_id = f.id
       LEFT OUTER JOIN purchases AS p ON a.id = p.artwork_id
         LEFT OUTER JOIN purchase_slips AS ps ON p.purchase_slip_id = ps.id
       LEFT OUTER JOIN trusts AS tr ON a.id = tr.artwork_id
         LEFT OUTER JOIN trust_slips AS ts ON tr.trust_slip_id = ts.id
     WHERE
       p.id IS NULL
     AND   COALESCE(a.artist_id,0) between :artist_id_from and :artist_id_to
     AND   a.title like :title
     AND   COALESCE(a.category_id,0) between :category_id_from and :category_id_to
     AND   COALESCE(a.technique_id,0) between :technique_id_from and :technique_id_to
     AND   COALESCE(a.format_id,0) between :format_id_from and :format_id_to"

     if params[:artist_id] == ''
       artist_id_from = 0
       artist_id_to = 999999
     else
       artist_id_from = params[:artist_id]
       artist_id_to = params[:artist_id]
     end

     title = '%' + params[:title] + '%'

     if params[:category_id] == ''
       category_id_from = 0
       category_id_to = 999999
     else
       category_id_from = params[:category_id]
       category_id_to = params[:category_id]
     end

     if params[:technique_id] == ''
       technique_id_from = 0
       technique_id_to = 999999
     else
       technique_id_from = params[:technique_id]
       technique_id_to = params[:technique_id]
     end

     if params[:format_id] == ''
       format_id_from = 0
       format_id_to = 999999
     else
       format_id_from = params[:format_id]
       format_id_to = params[:format_id]
     end

     @purchase_reference_search =  Purchase.find_by_sql([sql,{artist_id_from: artist_id_from, artist_id_to: artist_id_to,
                                                              title: title,
                                                              category_id_from: category_id_from, category_id_to: category_id_to,
                                                              technique_id_from: technique_id_from, technique_id_to: technique_id_to,
                                                              format_id_from: format_id_from, format_id_to: format_id_to}])
     render json: @purchase_reference_search
  end

  def select
    @purchase = Purchase.new
    @purchase.artwork_id = params[:artwork_id]
    @purchase.purchase_slip_id = params[:slip_id]
    @purchase.save
    sql =
    "SELECT
       a.id AS id,
       a.artwork_no AS artwork_no,
       at.name AS artist,
       a.title,
       CASE WHEN (a.size_id != 0) AND (a.size_id IS NOT NULL)
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
       END AS size,
       CASE WHEN (a.technique_id != 0) AND (t.technique IS NOT NULL)
            THEN t.technique
            ELSE c.category
       END AS category,
       f.format AS formats,
       CASE WHEN tr.price = 0
            THEN NULL
            ELSE tr.price
       END AS trust_price,
       CASE WHEN tr.price * ts.tax_rate * ts.tax_class_id = 0
            THEN NULL
            ELSE tr.price * ts.tax_rate * ts.tax_class_id
       END AS trust_tax,
       ps.slip_no AS purchase_slip_no,
       ts.slip_no AS trust_slip_no
     FROM
       artworks AS a
       LEFT OUTER JOIN artists AS at ON a.artist_id = at.id
       LEFT OUTER JOIN categories AS c ON a.category_id = c.id
       LEFT OUTER JOIN techniques AS t ON a.technique_id = t.id
       LEFT OUTER JOIN sizes AS si ON a.size_id = si.id
       LEFT OUTER JOIN size_units AS su ON a.size_unit_id = su.id
       LEFT OUTER JOIN formats AS f ON a.format_id = f.id
       LEFT OUTER JOIN purchases AS p ON a.id = p.artwork_id
         LEFT OUTER JOIN purchase_slips AS ps ON p.purchase_slip_id = ps.id
       LEFT OUTER JOIN trusts AS tr ON a.id = tr.artwork_id
         LEFT OUTER JOIN trust_slips AS ts ON tr.trust_slip_id = ts.id
     WHERE
       p.id IS NULL
     AND   COALESCE(a.artist_id,0) between :artist_id_from and :artist_id_to
     AND   a.title like :title
     AND   COALESCE(a.category_id,0) between :category_id_from and :category_id_to
     AND   COALESCE(a.technique_id,0) between :technique_id_from and :technique_id_to
     AND   COALESCE(a.format_id,0) between :format_id_from and :format_id_to"

     if params[:artist_id] == ''
       artist_id_from = 0
       artist_id_to = 999999
     else
       artist_id_from = params[:artist_id]
       artist_id_to = params[:artist_id]
     end

     title = '%' + params[:title] + '%'

     if params[:category_id] == ''
       category_id_from = 0
       category_id_to = 999999
     else
       category_id_from = params[:category_id]
       category_id_to = params[:category_id]
     end

     if params[:technique_id] == ''
       technique_id_from = 0
       technique_id_to = 999999
     else
       technique_id_from = params[:technique_id]
       technique_id_to = params[:technique_id]
     end

     if params[:format_id] == ''
       format_id_from = 0
       format_id_to = 999999
     else
       format_id_from = params[:format_id]
       format_id_to = params[:format_id]
     end

     @purchase_reference_search =  Purchase.find_by_sql([sql,{artist_id_from: artist_id_from, artist_id_to: artist_id_to,
                                                              title: title,
                                                              category_id_from: category_id_from, category_id_to: category_id_to,
                                                              technique_id_from: technique_id_from, technique_id_to: technique_id_to,
                                                              format_id_from: format_id_from, format_id_to: format_id_to}])
     render json: @purchase_reference_search
  end  
end
