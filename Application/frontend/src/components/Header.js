import React from "react";
import './Header.css'; // Importing the CSS file for styles

const Header = () => {
    return (
        <header className="header-container">
            <h1 className="header-title">Welcome to the TodoList Application!</h1>
            <p className="header-subtitle">Frontend by Upendra</p>
            <p className="header-version">Version <strong>No. 1</strong> 🥳</p>
            <p className="header-note">This one is cooler than ever! 😎</p>
            <a href="https://github.com/gupendrak/" className="header-link" target="_blank" rel="noopener noreferrer">
                Check out the Source Code on GitHub
            </a>
        </header>
    );
};

export default Header;