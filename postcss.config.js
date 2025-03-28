module.exports = {
  plugins: [
    function({ addBase }) {
      addBase({
        'body': {
          'text-size-adjust': '100%',
        }
      })
    },
    require('tailwindcss')('./app/javascript/stylesheets/tainwind.config.js'),
    require('postcss-import'),
    require('postcss-flexbugs-fixes'),
    require('postcss-preset-env')({
      autoprefixer: {
        flexbox: 'no-2009'
      },
      stage: 3
    })
  ]
};
