require 'json'

class PDJSON
	class Webhook
		def initialize(body)
			@body = body
			@json = JSON.parse(body)
		end

		def messages
			@json["messages"].collect{|msg| Message.new(msg.to_json)}
		end
	end

	class Message
		def initialize(body)
			@body = body
			@json = JSON.parse(body)
		end

		def is_trigger?
			type == "incident.trigger"
		end

		def is_acknowledge?
			type == "incident.acknowledge"
		end

		def is_resolve?
			type == "incident.resolve"
		end

		def user
			{:email => user_hash["email"], :name => user_hash["name"], :id => user_hash["id"], :url => user_hash["html_url"]}
		end

		def description
			@json["data"]["incident"]["trigger_summary_data"]["subject"]
		end

		def to_h
			@json
		end

		def to_json
			@body
		end

		private
			def type
				@json["type"]
			end

			def user_hash
				@json["data"]["incident"]["assigned_to_user"] || @json["data"]["incident"]["resolved_by_user"]
			end
	end
end