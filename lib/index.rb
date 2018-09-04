# frozen_string_literal: true
#!/usr/bin/env ruby -I ../lib -I lib
# coding: utf-8

require 'sinatra'

get '/' do
  erb :customer_details
end
