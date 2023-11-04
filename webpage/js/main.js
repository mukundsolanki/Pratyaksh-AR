(function ($) {
  "use strict";

  var cfg = {
      scrollDuration: 800,
    },
    $WIN = $(window);
  var doc = document.documentElement;
  doc.setAttribute("data-useragent", navigator.userAgent);

  var ssPreloader = function () {
    $WIN.on("load", function () {
      $("html, body").animate({ scrollTop: 0 }, "normal");

      $("#preloader").delay(500).fadeOut("slow");
    });
  };

  var ssMobileMenu = function () {
    var toggleButton = $(".header-menu-toggle"),
      nav = $("#header-nav-wrap");

    toggleButton.on("click", function (event) {
      event.preventDefault();

      toggleButton.toggleClass("is-clicked");
      nav.slideToggle();
    });

    if (toggleButton.is(":visible")) nav.addClass("mobile");

    $(window).resize(function () {
      if (toggleButton.is(":visible")) nav.addClass("mobile");
      else nav.removeClass("mobile");
    });

    $("#header-nav-wrap")
      .find("a")
      .on("click", function () {
        if (nav.hasClass("mobile")) {
          toggleButton.toggleClass("is-clicked");
          nav.slideToggle();
        }
      });
  };

  var ssFitVids = function () {
    $(".fluid-video-wrapper").fitVids();
  };

  var ssOwlCarousel = function () {
    $(".owl-carousel").owlCarousel({
      loop: true,
      nav: false,
      autoHeight: true,
      items: 1,
    });
  };

  var ssWaypoints = function () {
    var sections = $("section"),
      navigation_links = $(".header-main-nav li a");

    sections.waypoint({
      handler: function (direction) {
        var active_section;

        active_section = $("section#" + this.element.id);

        if (direction === "up") active_section = active_section.prev();

        var active_link = $(
          '.header-main-nav li a[href="#' + active_section.attr("id") + '"]'
        );

        navigation_links.parent().removeClass("current");
        active_link.parent().addClass("current");
      },

      offset: "25%",
    });
  };

  var ssSmoothScroll = function () {
    $(".smoothscroll").on("click", function (e) {
      var target = this.hash,
        $target = $(target);

      e.preventDefault();
      e.stopPropagation();

      $("html, body")
        .stop()
        .animate(
          {
            scrollTop: $target.offset().top,
          },
          cfg.scrollDuration,
          "swing",
          function () {
            window.location.hash = target;
          }
        );
    });
  };

  var ssPlaceholder = function () {
    $("input, textarea, select").placeholder();
  };

  var ssAlertBoxes = function () {
    $(".alert-box").on("click", ".close", function () {
      $(this).parent().fadeOut(500);
    });
  };

  var ssAOS = function () {
    AOS.init({
      offset: 200,
      duration: 600,
      easing: "ease-in-sine",
      delay: 300,
      once: true,
      disable: "mobile",
    });
  };

  /* AjaxChimp
   * ------------------------------------------------------ */
  var ssAjaxChimp = function () {
    $("#mc-form").ajaxChimp({
      language: "es",
      url: cfg.mailChimpURL,
    });

    $.ajaxChimp.translations.es = {
      submit: "Submitting...",
      0: '<i class="fa fa-check"></i> We have sent you a confirmation email',
      1: '<i class="fa fa-warning"></i> You must enter a valid e-mail address.',
      2: '<i class="fa fa-warning"></i> E-mail address is not valid.',
      3: '<i class="fa fa-warning"></i> E-mail address is not valid.',
      4: '<i class="fa fa-warning"></i> E-mail address is not valid.',
      5: '<i class="fa fa-warning"></i> E-mail address is not valid.',
    };
  };

  /* Back to Top
   * ------------------------------------------------------ */
  var ssBackToTop = function () {
    var pxShow = 500, // height on which the button will show
      fadeInTime = 400, // how slow/fast you want the button to show
      fadeOutTime = 400, // how slow/fast you want the button to hide
      scrollSpeed = 300, // how slow/fast you want the button to scroll to top. can be a value, 'slow', 'normal' or 'fast'
      goTopButton = $("#go-top");
    $(window).on("scroll", function () {
      if ($(window).scrollTop() >= pxShow) {
        goTopButton.fadeIn(fadeInTime);
      } else {
        goTopButton.fadeOut(fadeOutTime);
      }
    });
  };

  (function ssInit() {
    ssPreloader();
    ssMobileMenu();
    ssFitVids();
    ssOwlCarousel();
    ssWaypoints();
    ssSmoothScroll();
    ssPlaceholder();
    ssAlertBoxes();
    ssAOS();
    ssBackToTop();
  })();
})(jQuery);
