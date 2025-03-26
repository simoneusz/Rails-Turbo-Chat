import React from "react"

const Hero = ({ userSignedIn }) => {
  const imagesPaths = ["/images/hero-main-img-closed.svg", "/images/hero-main-img.svg"]
  const randomImage = imagesPaths[Math.floor(Math.random() * imagesPaths.length)]

  return (
    <div className="hero overflow-hidden w-100 h-100 user-select-none animated-bg d-flex align-items-center justify-content-center">
      <div className="hero-background rotating-bg"></div>
      <div className="hero-container d-flex flex-column flex-xl-row justify-content-center gap-5 mb-5">
        <div className="hero-main text-white fade-in d-flex flex-column justify-content-center">
          <h1>Welcome to TurboChat</h1>
          <p>Fast, secure, and modern chat for everyone.</p>
          {
            userSignedIn ?
            <a href="/rooms" className="btn btn-hero"> Get Started</a> :
            <a href="users/sign_in" className="btn btn-hero"> Get Started</a>
          }
        </div>
        <div className="hero-image fade-in">
          <img
            src={randomImage}
            alt="Hero Image"
            className="hero-image-img"
            draggable="false"
          />
        </div>
      </div>
    </div>
  )
}

export default Hero