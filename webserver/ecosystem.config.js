module.exports = {
  apps : [{
    name: 'webserver',
    cmd: 'main.py',
    interpreter: 'python3',
    args: '-u',
    // Options reference: https://pm2.keymetrics.io/docs/usage/application-declaration/
    instances: 1,
    exec_mode: 'fork',
    autorestart: true,
    watch: false,
    max_memory_restart: '500M'
  }]
};
