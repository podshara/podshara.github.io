// Autoplay muted looping videos only while they are on screen. Videos are written with
// controls and preload="none", so they stay playable when JavaScript or autoplay is off.
// With prefers-reduced-motion, they keep their poster and controls instead.
(function () {
  var videos = document.querySelectorAll("video[muted][loop]");
  if (!videos.length) return;

  var reduceMotion = window.matchMedia && window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  if (reduceMotion || !("IntersectionObserver" in window)) return;

  var observer = new IntersectionObserver(function (entries) {
    entries.forEach(function (entry) {
      var video = entry.target;
      if (entry.isIntersecting) {
        var playing = video.play();
        if (playing && playing.then) {
          playing.then(function () { video.controls = false; }).catch(function () {});
        }
      } else {
        video.pause();
      }
    });
  }, { rootMargin: "200px 0px" });

  videos.forEach(function (video) {
    observer.observe(video);
  });
})();
