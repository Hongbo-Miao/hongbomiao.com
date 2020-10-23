import React, { lazy, useEffect } from 'react';
import { connect, ConnectedProps } from 'react-redux';
import config from '../../config';
import HealthAction from '../../health/actions/Health.action';
import pingSubscription from '../../health/queries/ping.subscription';
import HmLazyComponent from '../../shared/components/LazyComponent';
import RootState from '../../shared/types/RootState.type';
import analytics from '../../shared/utils/analytics';
import MeAction from '../actions/Me.action';
// https://github.com/facebook/create-react-app/pull/9611
// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import hatAVIF from '../images/hat.avif';
import hatPNG from '../images/hat.png';
// https://github.com/facebook/create-react-app/pull/9611
// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import magicAVIF from '../images/magic.avif';
import magicPNG from '../images/magic.png';
import meQuery from '../queries/me.query';
import styles from './Home.module.css';

const HmImage = lazy(() => import('../../shared/components/Image'));
const HmSparkles = lazy(() => import('../../shared/components/Sparkles'));

const connector = connect(
  (state: RootState) => ({
    me: state.me,
  }),
  {
    queryMe: MeAction.queryMe,
    subscribePing: HealthAction.subscribePing,
  }
);

type Props = ConnectedProps<typeof connector>;

const Home: React.FC<Props> = (props) => {
  const { me, queryMe, subscribePing } = props;

  useEffect(() => {
    queryMe(meQuery);
    subscribePing(pingSubscription);

    analytics.page();
  }, [queryMe]);

  const { bio, name } = me;

  return (
    <div className={styles.hmHome}>
      <div className={`container is-max-desktop ${styles.hmContainer}`}>
        <h1 className={styles.hmTitle}>{name}</h1>
        <HmLazyComponent>
          <HmSparkles>
            <a className={styles.hmContent} href={config.githubURL} target="_blank" rel="noopener noreferrer">
              <HmImage
                avifSrc={hatAVIF}
                fallbackSrc={hatPNG}
                style={{ height: '22px', width: '22px' }}
                alt="Magical Hat"
              />
              <div className={styles.hmText}>{bio}</div>
              <HmImage
                avifSrc={magicAVIF}
                fallbackSrc={magicPNG}
                style={{ height: '22px', width: '22px' }}
                alt="Magic"
              />
            </a>
          </HmSparkles>
        </HmLazyComponent>
      </div>
    </div>
  );
};

export default connector(Home);
