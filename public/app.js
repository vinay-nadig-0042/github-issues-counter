// Start after DOM Load

var submitRepoLink = $('#submit-repo');
var resetRepoLink = $('#reset-repo');
var repoInput = $('#input-repo');
var total = $('#total')
var last_day = $('#last_day')
var mt_24h_lt_7d = $('#mt_24h_lt_7d')
var mt_7d = $('#mt_7d')
var error_info = $('#error')

// Clear all fields except the input field
function reset_fields() {
  submitRepoLink.removeClass('disabled');  
  total.html('0');
  last_day.html('0');
  mt_24h_lt_7d.html('0');
  mt_7d.html('0');
  error_info.html('');
}

$(document).ready(function() {

  submitRepoLink.on('click', function() {
    reset_fields();
    submitRepoLink.addClass('disabled');
    $('.progress').show();

    $.ajax({
      type: "POST",
      url: "/github-issues",
      data: {url: repoInput.val()},
    }).done(function(data) {
      $('.progress').hide();
      submitRepoLink.removeClass('disabled');
      if (data.error === undefined) {
        total.html(data.total)
        last_day.html(data.last_day)
        mt_24h_lt_7d.html(data.mt_24h_lt_7d)
        mt_7d.html(data.mt_7d)
      } else {
        error_info.html(data.error)
      }
    })
  });

  // Reset Counters and Fields
  resetRepoLink.on('click', function() {
    repoInput.val('');
    reset_fields();
  });

  // Pressing Enter on Input field should work too
  repoInput.on('keypress', function(event) {
    if(event.keyCode == 13) {
      submitRepoLink.click();
    }
  });
});
