//= require jquery
//= require jquery_ujs


$(function(){
  $('a.sort_asc').each(function() {
     $(this).parent().addClass('sorting_asc');
  });
  $('a.sort_desc').each(function() {
     $(this).parent().addClass('sorting_desc');
  });
});
