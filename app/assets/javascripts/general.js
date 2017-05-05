$(document).ready(function() {
  $('.add-select2').select2({
    theme: 'bootstrap',
    tags: true
  });

  $('#tag_search').select2({
    theme: 'bootstrap',
    tags: true,
    placeholder: 'Search by tags'
  });

  $('#actor_ids').select2({
    theme: 'bootstrap',
    tags: true,
    placeholder: 'Select Your Workspaces and Groups'
  });


  $(window).scroll(function() {
    if ($('.pagination').length > 0) {
      if($(window).scrollTop() + $(window).height() == $(document).height()) {
        var page = $('.pagination').find('a').attr('href').slice(7);
        $.ajax({
          dataType: 'script',
          method: 'GET',
          url: '/',
          data: { page: page }
        });
      }
    };
  });

  $('.disable-on-submit').on('submit', function() {
    $(this).find('button[type=submit] .fa').addClass('fa-spinner fa-pulse');
    $(this).find('button[type=submit]').prop('disabled',true);
  });
});
