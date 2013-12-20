require 'grappling'

redis_url "PUT YOUR REDIS URL HERE"

name "Grappling Minimal Working"

grapple do
	p is_trigger?
	p is_resolve?
	p is_acknowledge?
	p description
	p message
end