module.exports = function (wallaby) {
  process.env.NODE_ENV = 'test';
  return {
    // files: ['web/src/**/*.ts', '!web/src/**/*.test.ts'],
    // tests: ['web/src/**/*.test.ts'],

    files: ['src/**/*.ts', '!src/**/*.test.ts'],
    tests: ['src/**/*.test.ts'],

    // compilers: {
    //   '**/*.ts': wallaby.compilers.typeScript({ module: 'esnext' }),
    // },
    env: {
      type: 'node',
    },
    preprocessors: {
      // '**/*.ts': (file) =>
      //   require('babel-core').transform(file.content, {
      //     sourceMap: true,
      //     compact: false,
      //     filename: file.path,
      //     babelrc: true,
      //   }),

      // '**/*.js': (file) =>
      //   require('@babel/core').transform(file.content, {
      //     sourceMap: true,
      //     compact: false,
      //     filename: file.path,
      //     babelrc: true,
      //   }),

      // '**/*.ts': (file) =>
      //   require('@babel/core').transform(file.content, {
      //     // sourceMap: true,
      //     // compact: false,
      //     filename: file.path,
      //     presets: [
      //       [
      //         '@babel/preset-env',
      //         {
      //           targets: {
      //             node: 'current',
      //           },
      //         },
      //       ],
      //       '@babel/preset-typescript',
      //     ],
      //   }),

      '**/*.js': wallaby.compilers.babel({
        presets: [
          [
            '@babel/preset-env',
            {
              targets: {
                node: 'current',
              },
            },
          ],
          '@babel/preset-typescript',
        ],
      }),
    },
  };
};
