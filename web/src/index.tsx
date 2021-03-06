// OpenTelemetry need to be setup before importing other modules
import './shared/utils/initTracer';
import './index.css';
import * as Sentry from '@sentry/react';
import React from 'react';
import ReactDOM from 'react-dom';
import { Provider } from 'react-redux';
import HmApp from './App/components/App';
import reportWebVitals from './shared/libs/reportWebVitals';
import * as serviceWorkerRegistration from './shared/libs/serviceWorkerRegistration';
import initSentry from './shared/utils/initSentry';
import store from './shared/utils/store';

initSentry();

ReactDOM.render(
  <React.StrictMode>
    <Sentry.ErrorBoundary fallback="An error has occurred">
      <Provider store={store}>
        <HmApp />
      </Provider>
    </Sentry.ErrorBoundary>
  </React.StrictMode>,
  document.getElementById('root'),
);

/*
 * If you want your app to work offline and load faster, you can change
 * unregister() to register() below. Note this comes with some pitfalls.
 * Learn more about service workers: https://cra.link/PWA
 */
serviceWorkerRegistration.unregister();

/*
 * If you want to start measuring performance in your app, pass a function
 * to log results (for example: reportWebVitals(console.log))
 * or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
 */
reportWebVitals();
