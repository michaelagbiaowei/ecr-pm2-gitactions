module.exports = {
  apps: [
    {
      name: 'myapp',
      script: 'build/index.html',
      watch: false,
      env: {
        NODE_ENV: 'production'
      }
    }
  ]
};
