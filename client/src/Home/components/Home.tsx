import React, { useEffect } from 'react';
import { connect } from 'react-redux';
import config from '../../config';
import HmImage from '../../shared/components/Image';
import HmLazyComponent from '../../shared/components/LazyComponent';
import MeActions from '../actions/me.action';
import hatPNG from '../images/hat.png';
import hatWebP from '../images/hat.webp';
import magicPNG from '../images/magic.png';
import magicWebP from '../images/magic.webp';
import styles from './Home.module.css';

interface Props {
  getMe: Function;
}

const Home: React.FC<Props> = (props) => {
  const { getMe } = props;

  useEffect(() => {
    getMe();
  }, [getMe]);

  return (
    <div className={styles.hmHome}>
      <div className={`container ${styles.hmContainer}`}>
        <h1 className={styles.hmTitle}>HONGBO MIAO</h1>
        <a className={styles.hmContent} href={config.githubUrl} target="_blank" rel="noopener noreferrer">
          <HmLazyComponent>
            <HmImage className={styles.hmEmoji} alt="Magical Hat" src={hatPNG} webpSrc={hatWebP} />
          </HmLazyComponent>
          <div className={styles.hmText}>Making magic happen</div>
          <HmLazyComponent>
            <HmImage className={styles.hmEmoji} alt="Magic" src={magicPNG} webpSrc={magicWebP} />
          </HmLazyComponent>
        </a>
      </div>
    </div>
  );
};

export default connect(() => ({}), {
  getMe: MeActions.getMe,
})(Home);
