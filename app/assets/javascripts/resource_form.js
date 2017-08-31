$(document).ready(function() {
  $('#new_file_resource').hide();
  $('.add-resource-btn').click(function() {
    $('.feat-show-form').hide();
    $('#new_file_resource').toggle();
  });

  $('#new_url_resource').hide();
  $('.add-link-btn').click(function() {
    $('.feat-show-form').hide();
    $('#new_url_resource').toggle();
  });
  $('input:file').change(function (){
    $('.file_resource-upload-btn').show();
  });
})