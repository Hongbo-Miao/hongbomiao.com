import React from 'react';

import Websites from '../fixtures/websites';
import './Footer.css';


function Footer() {
  function renderLogos() {
    return Websites.map(website => {
      const {
        name,
        src,
        url,
      } = website;

        return (
          <p key={name} className="level-item">
            <a
              href={url}
              target="_blank"
              rel="noopener noreferrer"
            >
              <img src={src} className="hm-logo" alt={name} />
            </a>
          </p>
        );
      });
  }

  return (
    <footer className="footer hm-footer">
      <nav className="level">
        <div className="level-left">
          <p className="level-item">
            <div className="hm-copyright">
              © 2019 H.M.
            </div>
          </p>
        </div>

        <div className="level-right">
          {renderLogos()}
        </div>
      </nav>
    </footer>
  );
}

export default Footer;
