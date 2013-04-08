// Generated by CoffeeScript 1.6.2
(function() {
  $.getJSON("all.json", function(data) {
    var $json, $query, $summary;

    window.jsondata = data;
    $('h3').after("<textarea style=\"width:100%; height:60px;\">\n{ \"geo.Area.total.quantity\": 180 }\n</textarea>\n<button id=\"filter\">Filter</button>\n<span>Your Query:</span>\n<div><pre><code id=\"query\"></code></pre></div>\n<div id=\"resultSummary\"></div>\n<div><pre><code id=\"resultJSON\"></code></pre></div>");
    $summary = $('#resultSummary');
    $query = $('#query');
    $json = $('#resultJSON');
    return $('#filter').click(function() {
      var query, results, start, time;

      query = JSON.parse($('textarea').val());
      $query.html(JSON.stringify(query, null, 4));
      hljs.highlightBlock($query[0]);
      console.log("running query with", query);
      start = +(new Date);
      results = _.query(data, query);
      time = (+(new Date)) - start;
      console.log(time, results.length);
      if (results.length) {
        $summary.html("" + results.length + " Results Found. " + data.length + " countries queried in " + time + "ms. First result below.");
        $json.html(JSON.stringify(results[0], null, 4));
        return hljs.highlightBlock($json[0]);
      } else {
        $summary.html("No Results Found. " + data.length + " countries queried in " + time + "ms");
        return $json.empty();
      }
    });
  });

}).call(this);
