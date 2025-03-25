import React from 'react'
import App from './components/App'
import { createRoot } from "react-dom/client";


document.addEventListener("turbo:load", (e) => {
  const rootElement = document.getElementById('react-root')
  if (rootElement) {
    const root = createRoot(rootElement)

    root.render(
      <App />
    )
  }
})
