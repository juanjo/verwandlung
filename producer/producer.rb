require "kafka"
require "oj"
require 'faker'

KAKFA_URLS = ["localhost:9092"]
PRODUCER_NAME = 'producer'
TOPIC = 'verwandlung'

kafka = Kafka.new(["localhost:9092"], client_id: PRODUCER_NAME)
kafka.alter_topic(TOPIC, "max.message.bytes" => 10_000_000)

producer = kafka.async_producer(
  delivery_threshold: 20,           # Delivery once N msg have been buffered.
  delivery_interval: 20,            # Trigger a delivery every N seconds.
  max_buffer_size: 5_000,           # Allow at most 5K messages to be buffered.
  max_buffer_bytesize: 100_000_000, # Allow at most 100MB to be buffered.
  compression_codec: :gzip,
  compression_threshold: 10,
)

# Handling Ctrl-C cleanly in Ruby the ZeroMQ way:
trap("INT") { puts "Shutting down."; producer.shutdown; exit}

puts "Starting up Kafka: #{KAKFA_URLS} :: Topic: #{TOPIC}\n"

loop do
  num_events = rand(1...10)
  print "\rCreated [#{num_events}] events...."

  num_events.times do 

    event = {
      current_user: Faker::Name.first_name,
      item: Faker::Construction.material,
      description: "Item #{Faker::Verb.past_participle}",
      labels: "[:#{Faker::Verb.past_participle}]"
    }

    data = Oj.dump(event)

    producer.produce(data, topic: TOPIC, partition_key: rand(1...10))
  end

  sleep(0.1)
end
