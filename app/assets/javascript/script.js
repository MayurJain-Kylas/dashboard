"use strict";

// helper function
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
    } 
    catch (err) {
      return { code: 400, message: "something went wrong!", err };
    }
  }
  else { return { message: "invalid data", code: 400 } }
}

// load event lister to check if the page is loaded or not
window.addEventListener("load", async (event) => {
  setInterval(async () => {
    const isWonData = await fetchData("/deal/is_latest_deal_won")
    const status = isWonData?.status;
    const data = isWonData?.data;
    if (status && data && data?.won && data?.id) {
      const id = data?.id;
      const baseUrl = location.origin;
      window.location.href = baseUrl + "/deal?id=" + id;
      // const audio = new Audio(baseUrl + '/assets/clapping.mp3')
    } else { }
    // }, 3600000);
  }, 10000);
})
