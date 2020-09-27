process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')

// disable HMR & stop disconnected error
environment.config.devServer.inline = false

module.exports = environment.toWebpackConfig()
