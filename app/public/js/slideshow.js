SLIDES_DURATION = 10
function init() {
  $.ajax({
    type: "GET",
    url: '/cache-images',
    beforeSend : function(){
      var clock;
      //10 seconds countdown to let the presenter be ready.. and to cache the slides
      clock = new FlipClock($('.clock'), 10, {
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
    onSlideNext: function(){
      startProgressBar();
    }
  });
}
