import { graphqlHTTP } from 'express-graphql';
import isDevelopment from '../../shared/utils/isDevelopment';
import planetDataLoader from '../dataLoaders/planet.dataLoader';
import starshipDataLoader from '../dataLoaders/starship.dataLoader';
import userDataLoader from '../dataLoaders/user.dataLoader';
import schema from '../schemas/schema';

const graphQLMiddleware = graphqlHTTP({
  context: {
    dataLoaders: {
      planet: planetDataLoader,
      starship: starshipDataLoader,
      user: userDataLoader,
    },
  },
  customFormatErrorFn: (err) => {
    if (isDevelopment()) {
      return {
        ...err,
        stack: err.stack ? err.stack.split('\n') : [],
      };
    }
    return err;
  },
  schema,
});

export default graphQLMiddleware;
