# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  purchase_data = gon.purchase_data
  purchase_artwork_id = gon.purchase_artwork_id
  $('#purchase_slip').jqGrid
    styleUI: 'Bootstrap'
    datatype: 'local'
    data: purchase_data
    editurl: 'clientArray'
    colNames: [ '', '作品No', '作家名', 'タイトル', 'ＥＤ・号数', '分類・技法', '体裁', '状況', '仕入価格', '上代', '下代', '', '備考', 'id', '作品ID']
    colModel: [ { name:'actions', width: 40, formatter: "actions", formatoptions: {keys: false,editbutton: false, delbutton: true, delOptions: {}}}
                { name:'artwork_no', width: 100, editable: true, sortable: false, edittype: "select",
                editoptions: { value: purchase_artwork_id , dataInit: (artwork_id) -> $(artwork_id).select2 theme: "bootstrap", dropdownAutoWidth: true,  width: "1080px" } }
                { name:'name', width: 180, sortable: false }
                { name:'title', width: 260, sortable: false }
                { name:'size', width: 100, sortable: false }
                { name:'category', width: 160, sortable: false }
                { name:'format', width: 80, sortable: false }
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
        ret = $("#purchase_slip").jqGrid('getRowData',rowid)
        tmp = ret.artwork_no
    afterSaveCell: ( rowid, cellname, value, iRow, iCol ) ->
      if cellname == 'artwork_no'
        ret = $("#purchase_slip").jqGrid('getRowData',rowid)
        if ret.artwork_no != ''
          $.ajax
            type: 'GET'
            url: '/purchase_slips/artworkGet'
            async: false
            datatype: 'json'
            data: purchase_id: ret.id, artwork_id: value, price: ret.price, note: ret.note, purchase_slip_id: $('#purchase_slip_id').val()
            success: (artwork_data) ->
              ret.artwork_no = artwork_data[0].artwork_no
              ret.name = artwork_data[0].name
              ret.title = artwork_data[0].title
              ret.category = artwork_data[0].category
              $("#purchase_slip").jqGrid('setRowData',rowid,ret)
          if value != 0 and ret.artwork_id == ""
            $('#purchase_slip').addRowData undefined,{artwork_id:'',price:''}
      if cellname == 'price'
        ret = $("#purchase_slip").jqGrid('getRowData',rowid)
        if ret.id != null
          $.ajax
            type: 'GET'
            url: '/purchase_slips/priceSet'
            async: false
            datatype: 'json'
            data: purchase_id: ret.id, price: value, note: ret.note
    loadComplete: ->
      $('#purchase_slip').addRowData undefined,{artwork_id:'',price:''}
      artwork_cnt = ($('#purchase_slip').jqGrid 'getCol', 'id', false, 'count') - 1
      price_sum = $('#purchase_slip').jqGrid 'getCol', 'price', false, 'sum'
      tax_sum = parseInt(($('#purchase_slip').jqGrid 'getCol', 'price', false, 'sum' ) * $('#purchase_slip_tax_class_id').val() * $('#purchase_slip_tax_rate').val())
      price_total = price_sum + tax_sum
      t = document.getElementById('purchase_sum')
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
#    pager: '#purchase_slip_pager'

#  $('#purchase_slip').navGrid '#purchase_slip_pager',{ edit: false, add: false, del: true, search: false, refresh: false, view: false, position: "left", cloneToTop: false }

# 参照ボタン
  $('#purchase_slip_refer').click ->
    if $("#purchase_slip_id").val()
      window.open('/purchase_references/?slip_id=' + $("#purchase_slip_id").val(),'', 'height=640, width=1200')

# 新規伝票ボタン
  $('#purchase_slip_new').click ->
    location.href = '/purchase_slips/new'

# 作品登録ボタン
  $('#purchase_slip_artwork').click ->
    if $("#purchase_slip_id").val()
      id = $("#purchase_slip").jqGrid('getGridParam','selrow')
      ret = $("#purchase_slip").jqGrid('getRowData',id)
      if ret.id
        window.open('/artworks/' + ret.artwork_id,'', 'height=560, width=1200')
      else
        window.open('/purchases/new?slip_id=' + $("#purchase_slip_id").val(),'', 'height=560, width=1200')

# 伝票No変更
  $('#purchase_slip_id').change ->
    location.href = '/purchase_slips/' + $('#purchase_slip_id').val()
