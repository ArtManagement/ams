# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
sale_data = gon.sale_data
sale_artwork_id = gon.sale_artwork_id
$ ->
  $('#sale_slip').jqGrid
    styleUI: 'Bootstrap'
    datatype: 'local'
    data: sale_data
    editurl: 'clientArray'
    colNames: ['id', '作品ID', '作品No', '作家名', 'タイトル', 'ＥＤ・号数', '分類・技法', '体裁', '売上価格', '上代', '下代', '備考']
    colModel: [ { name:'id', width: 0,hidden : true }
                { name:'artwork_id', width: 0,hidden : true }
                { name:'artwork_no', width: 100, editable: true, frozen: true, edittype: "select",
                editoptions: { value: sale_artwork_id , dataInit: (artwork_id) -> $(artwork_id).select2 theme: "bootstrap", dropdownAutoWidth: true,  width: "1120px" } }
                { name:'name', width: 180, frozen: true }
                { name:'title', width: 280, frozen: true }
                { name:'size', width: 140 }
                { name:'category', width: 200 }
                { name:'format', width: 95 }
                { name:'price', width: 120, editable: true, align : 'right', formatter: 'number', summaryType: 'sum',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: 0 } }
                { name:'retail_price', width: 120, align : 'right'}
                { name:'wholesale_price', width: 120, align : 'right'}
                { name:'note', width: 200, editable: true, edittype: "textarea"} ]
    afterSaveCell: ( rowid, cellname, value, iRow, iCol ) ->
      if cellname == 'artwork_no'
        ret = $("#sale_slip").jqGrid('getRowData',rowid)
        if ret.artwork_no != ''
          $.ajax
            type: 'GET'
            url: '/sale_slips/artworkGet'
            async: false
            datatype: 'json'
            data: sale_id: ret.id, artwork_id: value, price: ret.price, note: ret.note, sale_slip_id: $('#sale_slip_id').val()
            success: (artwork_data) ->
              ret.artwork_no = artwork_data[0].artwork_no
              ret.name = artwork_data[0].name
              ret.title = artwork_data[0].title
              ret.category = artwork_data[0].category
              $("#sale_slip").jqGrid('setRowData',rowid,ret)
          if value != 0 and ret.artwork_id == ""
            $('#sale_slip').addRowData undefined,{artwork_id:'',price:''}
      if cellname == 'price'
        ret = $("#sale_slip").jqGrid('getRowData',rowid)
        if ret.artwork_no != ''
          $.ajax
            type: 'POST'
            url: '/sale_slips/priceSet'
            async: false
            datatype: 'json'
            data: sale_id: ret.id, price: value, note: ret.note
    loadComplete: ->
      $('#sale_slip').addRowData undefined,{artwork_id:'',price:''}
      artwork_cnt = ($('#sale_slip').jqGrid 'getCol', 'id', false, 'count') - 1
      price_sum = $('#sale_slip').jqGrid 'getCol', 'price', false, 'sum'
      tax_sum = parseInt(($('#sale_slip').jqGrid 'getCol', 'price', false, 'sum' ) * $('#sale_slip_tax_class_id').val() * $('#sale_slip_tax_rate').val())
      price_total = price_sum + tax_sum
      t = document.getElementById('sale_sum')
      t.rows[1].cells[0].innerHTML = artwork_cnt.toLocaleString()
      t.rows[1].cells[1].innerHTML = price_sum.toLocaleString()
      t.rows[1].cells[2].innerHTML = tax_sum.toLocaleString()
      t.rows[1].cells[3].innerHTML = price_total.toLocaleString()

    multiselect: false
    autoencode: true
    cellEdit: true
    cellsubmit: 'clientArray'
    width: 1135
    height: 385
    shrinkToFit: false
    rowNum: 200
    sortname: 'id'
    loadonce: true
    viewrecords: true
    sortorder: 'asc'
    caption:''

# 新規伝票ボタン
  $('#sale_slip_new').click ->
    location.href = '/sale_slips/new'

# 伝票No変更
  $('#sale_slip_id').change ->
    location.href = '/sale_slips/' + $('#sale_slip_id').val()
