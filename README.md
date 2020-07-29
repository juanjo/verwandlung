# Verwandlung

I wanted to play a bit with producers and consumers in Kafka. This repo it is a basic playground, nothing more than that.

## How it works

Let's get Kafka running locally with Docker:

`cd kafka`
`docker-compose up`

Let's start the consumer:

Install Rust:
`curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`

Let's compile and put the consumer up and running. The first time you run it, it will take longer due to compilation.

`cd consumer`
`cargo run`

Let's start the producer:
`cd producer`
`ruby producer.rb`



Producer creates a random number of JSON messages and we write them asynchronously (and compressed) in the Kafka topic 'verwandlung'.

The consumer is async too. It listens to the same topic and just print the message in the console.


