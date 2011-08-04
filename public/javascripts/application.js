// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

document.observe("dom:loaded", function() {
  // the element in which we will observe all clicks and capture
  // ones originating from pagination links
  var container = $(document.body)

  if (container) {
    container.observe('click', function(e) {
      var el = e.element()
      if (el.match('.pagination a')) {
        new Ajax.Request(el.href, { method: 'get' })
        e.stop()
      }
    })
  }
})

jQuery(document).ready(function() {
	jQuery('#tracks li').mouseover(function() {
		jQuery(this).fadeTo('fast', 1);
	});
	jQuery('#tracks li').mouseout(function() {
		jQuery(this).fadeTo('fast', .5);
	});
	jQuery('#select-by li').mouseover(function() {
		jQuery('#select-by').css('overflow', 'visible');
		jQuery('#select-by li').css('background-color', 'black');
		jQuery('#select-by').css('background-color', 'black');
	});
	jQuery('#select-by').mouseout(function() {
		jQuery(this).css('overflow', 'hidden');
		jQuery(this).css('background-color', 'transparent');
		jQuery('#select-by li').css('background-color', 'transparent');
	});	
});
