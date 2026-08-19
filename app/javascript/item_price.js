const updatePriceDetails = () => {
  const priceInput = document.getElementById("item-price")
  const feeElement = document.getElementById("add-tax-price")
  const profitElement = document.getElementById("profit")

  if (!priceInput || !feeElement || !profitElement) return

  const value = priceInput.value

  if (!/^\d+$/.test(value)) {
    feeElement.textContent = ""
    profitElement.textContent = ""
    return
  }

  const price = Number(value)
  const fee = Math.floor(price * 0.1)

  feeElement.textContent = fee
  profitElement.textContent = price - fee
}

document.addEventListener("input", (event) => {
  if (event.target.id === "item-price") updatePriceDetails()
})

document.addEventListener("turbo:load", updatePriceDetails)
document.addEventListener("turbo:render", updatePriceDetails)
