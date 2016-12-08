//Pecha Kucha rule says it's a 20 seconds per slide
SLIDES_DURATION = 20
function init() {
  $("#restart").hide()
  $.ajax({
    type: "GET",
    url: '/cache-images',
    beforeSend : function(){
      var clock;
      //10 seconds countdown to let the presenter be ready.. and to cache the slides
      clock = new FlipClock($('.clock'), 1, {
                clockFace: 'Counter',
                autoStart: true,
                countdown: true,
                callbacks: {
                  stop: function() {
                    $("#clock").hide();
                    $("#slides").show();
                    loadSlides();
                  }
                }
              });
      clock.start();
    }
  })
}

function startProgressBar(){
  $("#progressTimer").progressTimer({
    timeLimit: SLIDES_DURATION - 1,  //seconds
    baseStyle: 'progress-bar-info',
    warningStyle: 'progress-bar-warning',
    completeStyle: 'progress-bar-danger'
  });
}

function loadSlides() {
  startProgressBar();
  slider = $('.bxslider').bxSlider({
    auto: true,
    infiniteLoop: false,
    autoControls: false,
    pager: false,
    pause: SLIDES_DURATION * 1000, //milliseconds
    onSlideNext: function($slideElement, oldIndex, newIndex){
      startProgressBar();
      slideCount = slider.getSlideCount()
      if(newIndex+1 == slideCount)
      {
        $("#restart").show()
      }
    }
  });
}
