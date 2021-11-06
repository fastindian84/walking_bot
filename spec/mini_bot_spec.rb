require 'spec_helper'

describe MiniBot do
  it 'validate params' do
    expect { MiniBot.new(0, 3, 'f') }.to raise_error(MiniBot::BotError)
  end
end
