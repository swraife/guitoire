$(document).ready(function() {
  $('.add-select2').select2({
    theme: 'bootstrap',
    tags: true
  });

  $('#tag_search').select2({
    theme: 'bootstrap',
    tags: true,
    placeholder: 'Search by song tags'
  });
});
