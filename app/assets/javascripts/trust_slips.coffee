# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
trust_data = gon.trust_data
trust_artwork_id = gon.trust_artwork_id
$ ->
  $('#trust_slip').jqGrid
    styleUI: 'Bootstrap'
    datatype: 'local'
    data: trust_data
    editurl: 'clientArray'
    colNames: [ '', '作品No', '作家名', 'タイトル', 'ＥＤ・号数', '分類・技法', '体裁', '状況', '受託価格', '上代', '下代', '', '備考', 'id', '作品ID']
    colModel: [ { name:'actions', width: 40, formatter: "actions", formatoptions: {keys: true, delbutton : true, delOptions: {}}}
                { name:'artwork_no', width: 100, editable: true, sortable: false, edittype: "select",
                editoptions: { value: trust_artwork_id , dataInit: (artwork_id) -> $(artwork_id).select2 theme: "bootstrap", dropdownAutoWidth: true,  width: "1120px" } }
                { name:'name', width: 160, sortable: false }
                { name:'title', width: 240, sortable: false }
                { name:'size', width: 120, sortable: false }
                { name:'category', width: 160, sortable: false }
                { name:'format', width: 100, sortable: false }
                { name:'status', width: 80, sortable: false }
                { name:'price', width: 120, editable: true, sortable: false, align : 'right', formatter: 'number', summaryType: 'sum',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: '' } }
                { name:'retail_price', width: 100, sortable: false, align : 'right', formatter: 'number',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: '' }}
                { name:'wholesale_price', width: 100, sortable: false, align : 'right', formatter: 'number',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: '' }}
                { name:'cost', width: 100, sortable: false, align : 'right', formatter: 'number',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: '' }}
                { name:'note', width: 200, sortable: false, editable: true, edittype: "textarea"}
                { name:'id', width: 0,hidden : true }
                { name:'artwork_id', width: 0,hidden : true } ]
    beforeEditCell: ( rowid, cellname, value, iRow, iCol ) ->
      if cellname == 'artwork_no'
        ret = $("#trust_slip").jqGrid('getRowData',rowid)
        tmp = ret.artwork_no
    afterSaveCell: ( rowid, cellname, value, iRow, iCol ) ->
      if cellname == 'artwork_no'
        ret = $("#trust_slip").jqGrid('getRowData',rowid)
        if ret.artwork_no != ''
          $.ajax
            type: 'GET'
            url: '/trust_slips/artworkGet'
            async: false
            datatype: 'json'
            data: trust_id: ret.id, artwork_id: value, price: ret.price, note: ret.note, trust_slip_id: $('#trust_slip_id').val()
            success: (artwork_data) ->
              ret.artwork_no = artwork_data[0].artwork_no
              ret.name = artwork_data[0].name
              ret.title = artwork_data[0].title
              ret.category = artwork_data[0].category
              $("#trust_slip").jqGrid('setRowData',rowid,ret)
          if value != 0 and ret.artwork_id == ""
            $('#trust_slip').addRowData undefined,{artwork_id:'',price:''}
      if cellname == 'price'
        ret = $("#trust_slip").jqGrid('getRowData',rowid)
        if ret.id != null
          $.ajax
            type: 'GET'
            url: '/trust_slips/priceSet'
            async: false
            datatype: 'json'
            data: trust_id: ret.id, price: value, note: ret.note
    loadComplete: ->
      $('#trust_slip').addRowData undefined,{artwork_id:'',price:''}
      artwork_cnt = ($('#trust_slip').jqGrid 'getCol', 'id', false, 'count') - 1
      price_sum = $('#trust_slip').jqGrid 'getCol', 'price', false, 'sum'
      tax_sum = parseInt(($('#trust_slip').jqGrid 'getCol', 'price', false, 'sum' ) * $('#trust_slip_tax_class_id').val() * $('#trust_slip_tax_rate').val())
      price_total = price_sum + tax_sum
      t = document.getElementById('trust_sum')
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
  $('#trust_slip_new').click ->
    location.href = '/trust_slips/new'

# 伝票No変更
  $('#trust_slip_id').change ->
    location.href = '/trust_slips/' + $('#trust_slip_id').val()
