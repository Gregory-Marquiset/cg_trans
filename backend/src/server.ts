import Fastify from 'fastify'

const server = Fastify({ logger: true })

server.get('/', async (request, reply) => {
  return { pong: 'it works!' }
})

// ⚠️ Important pour que Docker accède au serveur
server.listen({ port: 3000, host: '0.0.0.0' }, (err, address) => {
  if (err) {
    server.log.error(err)
    process.exit(1)
  }
  server.log.info(`Server listening at ${address}`)
})
