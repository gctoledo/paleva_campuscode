document.addEventListener("turbo:load", () => {
  const portionSelects = document.querySelectorAll(".portion-select");
  const totalPriceElement = document.getElementById("total-price");

  function calculateTotalPrice() {
    let total = 0;

    portionSelects.forEach(select => {
      const selectedOption = select.options[select.selectedIndex];
      if (selectedOption && selectedOption.value) {
        const priceText = selectedOption.textContent.match(/R\$\s([\d,]+)/);
        if (priceText) {
          total += parseFloat(priceText[1].replace(",", "."));
        }
      }
    });

    totalPriceElement.textContent = total.toFixed(2);
  }

  portionSelects.forEach(select => {
    select.addEventListener("change", calculateTotalPrice);
  });

  calculateTotalPrice();
});
