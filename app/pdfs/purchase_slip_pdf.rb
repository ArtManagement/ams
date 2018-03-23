class PurchaseSlipPDF

  # Classメソッドを定義
  def self.create purchase_slip
    respond_to do |format|
          format.html # show.html.erb
          format.pdf do

            # Thin ReportsでPDFを作成
            # 先ほどEditorで作ったtlfファイルを読み込む
            #report = ThinReports::Report.new(layout: "#{Rails.root}/app/pdfs/purchase_slip.tlf")
            report = Thinreports::Report.new layout: File.join(Rails.root, 'app', 'pdfs', 'purchase_slip.tlf')
            # 1ページ目を開始
            report.start_new_page

            ### 追加箇所 開始 ###
            # 注文番号と注文日の値を設定
            # itemメソッドでtlfファイルのIDを指定し、
            # valueメソッドで値を設定します
            report.page.item(:slip_no).value(@purchase_slip.slip_no)
            report.page.item(:customer).value(@purchase_slip.customer_id)
            ### 追加箇所 終了 ###

            # ブラウザでPDFを表示する
            # disposition: "inline" によりダウンロードではなく表示させている
            send_data report.generate,
                  filename:    "#{@purchase_slip.id}.pdf",
                  type:        "application/pdf",
                  disposition: "inline"
          end
    end

    return report
  end
end
