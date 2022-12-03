

const body = document.getElementsByTagName("body")[0]
// const bgColorSlider = document.getElementById("bg-color-slider")
const textColorSlider = document.getElementById("text-color-slider")
const testButton = document.getElementById("test-button")
console.log(testButton)

const computeColor = (value) =>
      Math
      .floor(value * 167772.16)
      .toStrig(16)
      .padStart(6, '0')


const setBackgroundColor = (event) => {
  body.setAttribute('style', `color: red`)
}



testButton.addEventListener("click", setBackgroundColor)
