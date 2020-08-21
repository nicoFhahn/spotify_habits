 $(window).scroll(function(){
	 inViewport();
 });

 $(window).resize(function(){
	 inViewport();
 });

 function inViewport(){
	 $('.animated').each(function(){
		 var divPos = $(this).offset().top,
             topOfWindow = $(window).scrollTop();
		 
		 if( divPos < topOfWindow+200 ){
			 $(this).addClass('start');
		 }
	 });
 }