# place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
payment_data = gon.payment_data
payment_artwork_id = gon.payment_artwork_id

$ ->
  $('#payment_slip').jqGrid
    styleUI: 'Bootstrap4'
    iconSet: 'fontAwesome'
    datatype: 'local'
    data: payment_data
    editurl: 'clientArray'
    colNames: [ '', '作品No', '作家名', 'タイトル', 'ＥＤ・号数', '分類・技法', '買掛金額', '状況', '出金金額', '仕入金額', '備考', 'id', '作品id']
    colModel: [ { name:'actions', width: 60, formatter: "actions", formatoptions: {keys: false, editbutton: false, delbutton: true, delOptions: {}}}
                { name:'artwork_no', width: 100, editable: true, sortable: false, edittype: "select",
                editoptions: { value: payment_artwork_id , dataInit: (artwork_id) -> $(artwork_id).select2 theme: "bootstrap", dropdownAutoWidth: true,  width: "1080px" } }
                { name:'name', width: 180, sortable: false }
                { name:'title', width: 240, sortable: false }
                { name:'size', width: 100, sortable: false }
                { name:'category', width: 140, sortable: false }
                { name:'payable_amount', width: 100, sortable: false, align : 'right', formatter: 'number', summaryType: 'sum',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalplaces: 0, defaultValue: '' } }
                { name:'status', width: 80, sortable: false }
                { name:'amount', width: 120, editable: true, sortable: false, align : 'right', formatter: 'number', summaryType: 'sum',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalplaces: 0, defaultValue: '' } }
                { name:'purchase_amount', width: 100, sortable: false, align : 'right', formatter: 'number',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalplaces: 0, defaultValue: '' }}
                { name:'note', width: 200, sortable: false, editable: true, edittype: "textarea"}
                { name:'id', width: 0,hidden : true }
                { name:'artwork_id', width: 0,hidden : true } ]
    beforeEditCell: ( rowid, cellname, value, iRow, iCol ) ->
      if cellname == 'artwork_no'
        ret = $("#payment_slip").jqGrid('getRowData',rowid)
        tmp = ret.artwork_no
    afterSaveCell: ( rowid, cellname, value, iRow, iCol ) ->
      if cellname == 'artwork_no'
        ret = $("#payment_slip").jqGrid('getRowData',rowid)
        if ret.artwork_no != ''
          $.ajax
            type: 'GET'
            url: '/payment_slips/artworkGet'
            async: false
            datatype: 'json'
            data: id: ret.id, purchase_id: value, amount: ret.amount, note: ret.note, payment_slip_id: $('#payment_slip_id').val()
            success: (artwork_data) ->
              ret.artwork_no = artwork_data[0].artwork_no
              ret.name = artwork_data[0].name
              ret.title = artwork_data[0].title
              $("#payment_slip").jqGrid('setRowData',rowid,ret)
          if value != 0 and ret.artwork_id == ""
            $('#payment_slip').addRowData undefined,{artwork_id:'',amount:''}
      if cellname == 'amount'
        ret = $("#payment_slip").jqGrid('getRowData',rowid)
        if ret.id != null
          $.ajax
            type: 'GET'
            url: '/payment_slips/amountSet'
            async: false
            datatype: 'json'
            data: payment_id: ret.id, amount: value, note: ret.note
    loadComplete: ->
      $('#payment_slip').addRowData undefined,{artwork_id:'',amount:''}
      artwork_cnt = ($('#payment_slip').jqGrid 'getCol', 'id', false, 'count') - 1
      amount_sum = $('#payment_slip').jqGrid 'getCol', 'amount', false, 'sum'
      tax_sum = parseInt(($('#payment_slip').jqGrid 'getCol', 'amount', false, 'sum' ) * $('#payment_slip_tax_class_id').val() * $('#payment_slip_tax_rate').val())
      amount_total = amount_sum + tax_sum
      t = document.getElementById('payment_sum')
      t.rows[1].cells[0].innerHTML = artwork_cnt.toLocaleString()
      t.rows[1].cells[1].innerHTML = amount_sum.toLocaleString()

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
#    pager: '#payment_slip_pager'

#  $('#payment_slip').navGrid '#payment_slip_pager',{ edit: false, add: false, del: true, search: false, refresh: false, view: false, position: "left", cloneToTop: false }
# 新規伝票ボタン
  $('#payment_slip_new').click ->
    location.href = '/payment_slips/new'

# 作品登録ボタン
  $('#payment_slip_artwork').click ->
    if $("#payment_slip_id").val()
      id = $("#payment_slip").jqGrid('getGridparam','selrow')
      ret = $("#payment_slip").jqGrid('getRowData',id)
      if ret.artwork_id
        window.open('/artworks/' + ret.artwork_id,'', 'height=560, width=1200')

# 伝票No変更
  $('#payment_slip_id').change ->
    location.href = '/payment_slips/' + $('#payment_slip_id').val()
