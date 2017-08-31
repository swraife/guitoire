$(document).ready(function() {
  $('#routine_feat_feat_id').change(function() {
    if ($(this).val() != '') {
      $('.routine_feat__submit-btn').show();
    } else {
      $('.routine_feat__submit-btn').hide();
    }
  });
});