const buildCardForm = () => {
  const form = document.getElementById("charge-form")
  if (!form || form.dataset.cardReady === "true") return

  const errorMessage = document.getElementById("card-error-message")
  if (!form.dataset.payjpPublicKey) {
    errorMessage.textContent = "PAY.JPの公開鍵が設定されていません"
    return
  }
  if (typeof Payjp === "undefined") {
    errorMessage.textContent = "カード入力機能を読み込めませんでした。ページを再読み込みしてください"
    return
  }

  const payjp = Payjp(form.dataset.payjpPublicKey)
  const elements = payjp.elements()
  const numberElement = elements.create("cardNumber")
  const expiryElement = elements.create("cardExpiry")
  const cvcElement = elements.create("cardCvc")

  numberElement.mount("#number-form")
  expiryElement.mount("#expiry-form")
  cvcElement.mount("#cvc-form")
  form.dataset.cardReady = "true"

  form.addEventListener("submit", (event) => {
    event.preventDefault()
    form.querySelector("button, input[type='submit']").disabled = true

    payjp.createToken(numberElement).then((response) => {
      if (response.error) {
        errorMessage.textContent = response.error.message
        form.querySelector("button, input[type='submit']").disabled = false
        return
      }

      const token = document.createElement("input")
      token.type = "hidden"
      token.name = "order_address[token]"
      token.value = response.id
      form.appendChild(token)
      form.submit()
    })
  })
}

document.addEventListener("turbo:load", buildCardForm)
document.addEventListener("turbo:render", buildCardForm)
