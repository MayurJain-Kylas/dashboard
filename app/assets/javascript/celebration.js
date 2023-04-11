"use strict";

// confetti code
const Confettiful = function (el) {
  this.el = el;
  this.containerEl = null;

  this.confettiFrequency = 3;
  this.confettiColors = ['#EF2964', '#00C09D', '#2D87B0', '#48485E', '#EFFF1D'];
  this.confettiAnimations = ['slow', 'medium', 'fast'];

  this._setupElements();
  this._renderConfetti();
};

Confettiful.prototype._setupElements = function () {
  const containerEl = document.createElement('div');
  const elPosition = this.el.style.position;

  if (elPosition !== 'relative' || elPosition !== 'absolute') {
    this.el.style.position = 'relative';
  }

  containerEl.classList.add('confetti-container');

  this.el.appendChild(containerEl);

  this.containerEl = containerEl;
};

Confettiful.prototype._renderConfetti = function () {
  this.confettiInterval = setInterval(() => {
    const confettiEl = document.createElement('div');
    const confettiSize = Math.floor(Math.random() * 3) + 7 + 'px';
    const confettiBackground = this.confettiColors[Math.floor(Math.random() * this.confettiColors.length)];
    const confettiLeft = Math.floor(Math.random() * this.el.offsetWidth) + 'px';
    const confettiAnimation = this.confettiAnimations[Math.floor(Math.random() * this.confettiAnimations.length)];

    confettiEl.classList.add('confetti', 'confetti--animation-' + confettiAnimation);
    confettiEl.style.left = confettiLeft;
    confettiEl.style.width = confettiSize;
    confettiEl.style.height = confettiSize;
    confettiEl.style.backgroundColor = confettiBackground;

    confettiEl.removeTimeout = setTimeout(function () {
      confettiEl.parentNode.removeChild(confettiEl);
    }, 3000);

    this.containerEl.appendChild(confettiEl);
  }, 10);
};

// helper function
const enterFullScreen = (element) => {
  if (element.requestFullscreen) {
    element.requestFullscreen();
  } else if (element.mozRequestFullScreen) {
    // firefox
    element.mozRequestFullScreen();
  } else if (element.webkitRequestFullscreen) {
    // safari
    element.webkitRequestFullscreen();
  } else if (element.msRequestFullscreen) {
    // edge
    element.msRequestFullscreen();
  }
};

const fetchData = async (url = "", data = {}, method = "GET") => {
  if (url !== "") {
    try {
      const response = await fetch(url, {
        method: method,
        mode: "cors",
        cache: "no-cache",
        credentials: "same-origin",
        headers: {
          "Content-Type": "application/json"
        },
        redirect: "follow",
        referrerPolicy: "no-referrer",
        body: method == "GET" ? null : JSON.stringify(data),
      });
      return await response.json();
    } catch (err) {
      return { code: 400, message: "something went wrong!", err };
    }
  } else { return { message: "invalid data", code: 400 } }
}

const redirect_to_homepage = () => {
  const baseUrl = location.origin;
  location.href = baseUrl;
}


window.addEventListener("load", async (event) => {
  const queryString = window.location.search;
  const urlParams = new URLSearchParams(queryString);
  const id = urlParams.get('id')
  if (id) {
    const query = { id: id };
    const data = await fetchData(`/deal/details?id=${id}`);
    // if the server response with valid code
    if (data && data?.status == 200 && data?.data) {
      window.confettiful = new Confettiful(document.querySelector('.celebration-container'));
      const response = data?.data;
      const name = response?.name;
      const createdAt = response?.createdAt;
      const deal_name_container = document.querySelector("#deal_name")
      const company_name_container = document.querySelector("#company_name")
      deal_name_container.innerHTML = name;
      setTimeout(redirect_to_homepage, 5000)
    }
    else { redirect_to_homepage() }
  }
  // redirect to root_page if the id not provided
  else {
    const baseUrl = location.origin;
    location.href = baseUrl;
  }
});
