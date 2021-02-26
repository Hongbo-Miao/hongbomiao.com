import { CollectorTraceExporter } from '@opentelemetry/exporter-collector';
import { DocumentLoad } from '@opentelemetry/plugin-document-load';
import { BatchSpanProcessor, ConsoleSpanExporter } from '@opentelemetry/tracing';
import { WebTracerProvider } from '@opentelemetry/web';
import config from '../../config';
import isDevelopment from './isDevelopment';
import isProduction from './isProduction';

const initTracer = (): void => {
  const serviceName = 'hm-web-trace-service';
  const tracerProvider = new WebTracerProvider({
    // https://github.com/open-telemetry/opentelemetry-js-contrib/issues/193
    // eslint-disable-next-line @typescript-eslint/ban-ts-comment
    // @ts-ignore
    plugins: [new DocumentLoad()],
  });

  if (isDevelopment()) {
    tracerProvider.addSpanProcessor(new BatchSpanProcessor(new ConsoleSpanExporter()));
    tracerProvider.addSpanProcessor(
      new BatchSpanProcessor(
        new CollectorTraceExporter({
          serviceName,
        })
      )
    );
  }

  if (isProduction()) {
    const { token, traceURL } = config.lightstep;
    tracerProvider.addSpanProcessor(
      new BatchSpanProcessor(
        new CollectorTraceExporter({
          serviceName,
          url: traceURL,
          headers: {
            'Lightstep-Access-Token': token,
          },
        })
      )
    );
  }

  tracerProvider.register();
};

initTracer();
