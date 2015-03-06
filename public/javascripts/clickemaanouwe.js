$(document).ready(function() {

	$('#menulink').click(function(event) {
		event.preventDefault();
		if($('.navigation-wrapper').hasClass('show-menu')) {
			$('.navigation-wrapper').removeClass('show-menu');
			$('.navigation').hide();
			$('.navigation li').removeClass('small-padding');
		} else {
			$('.navigation-wrapper').addClass('show-menu');
			$('.navigation').fadeIn();
			$('.navigation li').addClass('small-padding');
	   }
	});
  
});