alert "update"

$.getJSON "all.json", (data) ->
  console.log data[0]
  $('h3').after """
  <textarea>
  { "geo.Area.total.quantity": 180 }
  </textarea>
  <button id="filter">Filter</button>

  """

  $('#filter').click ->
    console.log JSON.parse($('textarea').val())
