class StockListsController < ApplicationController
  def index
    @sort = Sort.select(:sort_key, :sort).all
    @customer = Customer.select(:id, "name || '／' || kana AS customer").where("company_id = 0").order(:kana)
    @artist = Artist.select(:id, "name || '／' || kana AS artist").all.order(:kana)
    @category = Category.select(:id, :category).all.order(:id)
    @technique = Technique.select(:id, :technique).all.order(:id)
    @format = Format.select(:id, :format).all.order(:id)
    sql =
    "SELECT p.id AS id,
       p.purchase_slip_id AS purchase_slip_id,
       p.artwork_id AS artwork_id,
       ps.date AS purchase_date,
       s.name AS supplier,
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
       CASE WHEN p.price = 0
            THEN NULL
            ELSE p.price
       END AS purchase_price,
       CASE WHEN p.price * ps.tax_rate * ps.tax_class_id = 0
            THEN NULL
            ELSE p.price * ps.tax_rate * ps.tax_class_id
       END AS tax,
       ss.date AS sale_date,
       ct.name AS customer,
       CASE WHEN sa.price = 0
            THEN NULL
            ELSE sa.price
       END AS sale_price,
       a.retail_price,
       a.wholesale_price,
       p.note AS note
FROM   purchases AS p,
       purchase_slips AS ps,
       customers AS s,
       artworks AS a
LEFT OUTER JOIN artists AS at ON a.artist_id = at.id
LEFT OUTER JOIN categories AS c ON a.category_id = c.id
LEFT OUTER JOIN techniques AS t ON a.technique_id = t.id
LEFT OUTER JOIN sizes AS si ON a.size_id = si.id
LEFT OUTER JOIN size_units AS su ON a.size_unit_id = su.id
LEFT OUTER JOIN formats AS f ON a.format_id = f.id
LEFT OUTER JOIN sales AS sa ON a.id = sa.artwork_id
LEFT OUTER JOIN sale_slips AS ss ON sa.sale_slip_id = ss.id
LEFT OUTER JOIN customers AS ct ON ss.customer_id = ct.id
WHERE p.artwork_id = a.id
AND   p.purchase_slip_id = ps.id
AND   ps.customer_id = s.id"

gon.stock_list_data =  Purchase.find_by_sql([sql])
  end
end
