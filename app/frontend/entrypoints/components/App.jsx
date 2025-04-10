import React from "react"
import { createRoot } from "react-dom/client"
import Hero from "./Hero";

const App = () => {
  const userSignedIn = JSON.parse(document.getElementById("react-root").getAttribute("data-user-sign-in"))
  return (
    <Hero
    userSignedIn={userSignedIn}/>
  )
}

export default App