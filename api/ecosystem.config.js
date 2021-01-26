module.exports = {
  apps: [
    {
      name: 'api',
      script: './build/src/index.js',
      instances: 2, // https://pm2.keymetrics.io/docs/usage/cluster-mode/#usage
      exec_mode: 'cluster',
      env_development: {
        NODE_ENV: 'development',
      },
      env_production: {
        NODE_ENV: 'production',
      },
    },
  ],
};
