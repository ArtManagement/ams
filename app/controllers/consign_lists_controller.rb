class ConsignListsController < ApplicationController
  def index
    @sort = Sort.select(:sort_key, :sort).all
    @customer = Customer.select(:id, "name || '／' || kana AS customer").where("company_id = 0").order(:kana)
    @artist = Artist.select(:id, "name || '／' || kana AS artist").all.order(:kana)
    @category = Category.select(:id, :category).all.order(:id)
    @technique = Technique.select(:id, :technique).all.order(:id)
    @format = Format.select(:id, :format).all.order(:id)
    sql =
    "SELECT
  s.id AS id,
  s.consign_slip_id AS consign_slip_id,
  s.artwork_id AS artwork_id,
  ss.date AS consign_date,
  cu.name AS customer,
  a.artwork_no AS artwork_no,
  at.name AS artist,
  a.title AS title,
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
  CASE WHEN (a.technique_id != 0) AND (t.technique IS NOT NULL)
       THEN t.technique
       ELSE c.category
  END AS category,
  f.format AS formats,
  CASE WHEN s.price = 0
       THEN NULL
       ELSE s.price
  END AS consign_price,
  CASE WHEN s.price * ss.tax_rate * ss.tax_class_id = 0
       THEN NULL
       ELSE s.price * ss.tax_rate * ss.tax_class_id
  END AS tax,
  scs.date AS return_date,
  ps.date AS purchase_date,
  ct.name AS supplier,
  CASE WHEN pu.price = 0
       THEN NULL
       ELSE pu.price
  END AS purchase_price,
  s.note AS note
FROM consigns AS s
     LEFT OUTER JOIN consign_returns AS sc ON s.id = sc.consign_id
     LEFT OUTER JOIN consign_return_slips AS scs ON sc.consign_return_slip_id = scs.id,
     consign_slips AS ss,
     customers AS cu,
     artworks AS a
     LEFT OUTER JOIN artists AS at ON a.artist_id = at.id
     LEFT OUTER JOIN categories AS c ON a.category_id = c.id
     LEFT OUTER JOIN techniques AS t ON a.technique_id = t.id
     LEFT OUTER JOIN sizes AS si ON a.size_id = si.id
     LEFT OUTER JOIN size_units AS su ON a.size_unit_id = su.id
     LEFT OUTER JOIN formats AS f ON a.format_id = f.id
     LEFT OUTER JOIN purchases AS pu ON a.id = pu.artwork_id
     LEFT OUTER JOIN purchase_slips AS ps ON pu.purchase_slip_id = ps.id
     LEFT OUTER JOIN customers AS ct ON ps.customer_id = ct.id
WHERE s.artwork_id = a.id
AND   s.consign_slip_id = ss.id
AND   ss.customer_id = cu.id"

gon.consign_list_data =  Consign.find_by_sql([sql])
  end

end
