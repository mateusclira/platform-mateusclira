// https://www.bytewebster.com/
// https://www.bytewebster.com/
// https://www.bytewebster.com/
const checkbox = document.getElementById("checkbox");
const premium = document.getElementById("premium");
const master = document.getElementById("master");
const free = document.getElementById("free");

checkbox.addEventListener("click", () => {
  free.textContent = free.textContent === "R$0.0" ? "R$0.0" : "R$0.0";
  premium.textContent =
    premium.textContent === "R$349.99" ? "R$39.99 " : "R$349.99";
  master.textContent = master.textContent === "R$3499.99" ? "R$399.99" : "R$3499.99";
});
