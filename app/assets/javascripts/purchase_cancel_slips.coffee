# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
purchase_cancel_data = gon.purchase_cancel_data
purchase_cancel_artwork_id = gon.purchase_cancel_artwork_id
$ ->
  $('#purchase_cancel_slip').jqGrid
    styleUI: 'Bootstrap'
    datatype: 'local'
    data: purchase_cancel_data
    editurl: 'clientArray'
    colNames: [ '', '作品No', '作家名', 'タイトル', 'ＥＤ・号数', '分類・技法', '体裁', '状況', '仕入価格', '備考', 'id', '仕入ID','作品ID']
    colModel: [ { name:'actions', width: 40, formatter: "actions", formatoptions: {keys: true, delbutton : true, delOptions: {}}}
                { name:'artwork_no', width: 100, editable: true, sortable: false, edittype: "select",
                editoptions: { value: purchase_cancel_artwork_id , dataInit: (artwork_id) -> $(artwork_id).select2 theme: "bootstrap", dropdownAutoWidth: true,  width: "1080px" } }
                { name:'name', width: 180, sortable: false }
                { name:'title', width: 260, sortable: false }
                { name:'size', width: 100, sortable: false }
                { name:'category', width: 160, sortable: false }
                { name:'format', width: 80, sortable: false }
                { name:'status', width: 80, sortable: false }
                { name:'price', width: 120, sortable: false, align : 'right', formatter: 'number', summaryType: 'sum',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: '' } }
                { name:'note', width: 200, sortable: false, editable: true, edittype: "textarea"}
                { name:'id', width: 0,hidden : true }
                { name:'purchase_id', width: 0,hidden : true }
                { name:'artwork_id', width: 0,hidden : true } ]
    afterSaveCell: ( rowid, cellname, value, iRow, iCol ) ->
      if cellname == 'artwork_no'
        ret = $("#purchase_cancel_slip").jqGrid('getRowData',rowid)
        if ret.artwork_no != ''
          $.ajax
            type: 'GET'
            url: '/purchase_cancel_slips/artworkGet'
            async: false
            datatype: 'json'
            data: id: ret.id, purchase_id: value, note: ret.note, purchase_cancel_slip_id: $('#purchase_cancel_slip_id').val()
            success: (artwork_data) ->
              ret.artwork_no = artwork_data[0].artwork_no
              ret.name = artwork_data[0].name
              ret.title = artwork_data[0].title
              ret.category = artwork_data[0].category
              ret.price = artwork_data[0].price
              $("#purchase_cancel_slip").jqGrid('setRowData',rowid,ret)
          if value != 0 and ret.purchase_id == ""
            $('#purchase_cancel_slip').addRowData undefined,{purchase_id:'',price:''}
    loadComplete: ->
      $('#purchase_cancel_slip').addRowData undefined,{purchase_id:''}
      artwork_cnt = ($('#purchase_cancel_slip').jqGrid 'getCol', 'id', false, 'count') - 1
      price_sum = $('#purchase_cancel_slip').jqGrid 'getCol', 'price', false, 'sum'
      t = document.getElementById('purchase_cancel_sum')
      t.rows[1].cells[0].innerHTML = artwork_cnt.toLocaleString()
      t.rows[1].cells[1].innerHTML = price_sum.toLocaleString()

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
  $('#purchase_cancel_slip_new').click ->
    location.href = '/purchase_cancel_slips/new'

# 作品登録ボタン
  $('#purchase_cancel_slip_artwork').click ->
    if $("#purchase_cancel_slip_id").val()
      id = $("#purchase_cancel_slip").jqGrid('getGridParam','selrow')
      ret = $("#purchase_cancel_slip").jqGrid('getRowData',id)
      if ret.artwork_id
        window.open('/artworks/' + ret.artwork_id,'', 'height=560, width=1200')

# 伝票No変更
  $('#purchase_cancel_slip_id').change ->
    location.href = '/purchase_cancel_slips/' + $('#purchase_cancel_slip_id').val()
