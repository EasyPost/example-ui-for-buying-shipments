$(document).ready(function() {
  $('#hide-input').hide(); //Initially form wil be hidden.
  $('#custom-form').click(function() {
    $('#hide-input').toggle();//Form toggles on button click
  });
});