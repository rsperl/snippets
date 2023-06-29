// get size of all cookies
function totalCookieSize() {
  cookieStore.getAll().then((cookies) => {
    total = 0;
    cookies.forEach((c) => {
      console.dir(c);
      c = c.name + "=" + c.value + "; HttpOnly; " + c.path;
      total += c.length;
    });
    console.log("total: ", total);
  });
}

// set a cookie
cookieStore.set({
  domain: "example.com",
  expirationDate: 1707065137000,
  path: "/",
  name: "rms-custom-cookie",
  value: "xxxxxxxxxxxxx",
});
