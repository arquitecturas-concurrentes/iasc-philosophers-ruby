require "spec_helper"

RSpec.describe Concurrency::Philosopher do
  let(:chocksticks) do
    (1..5).map do |number|
      Concurrency::Fork.new(number)
    end
  end

  let(:philosophers) do
    names = %w(Spinoza Kierkegaard Plato Nietzsche Heidegger)
    (0..4).to_a.concat([0]).each_cons(2).zip(names).map do |(left, right), name|
      described_class.new(name, chocksticks[left], chocksticks[right])
    end
  end

  it "5 philosophers and 5 chocksticks" do
    expect(chocksticks.count).to eq 5
    expect(philosophers.count).to eq 5
  end

  let(:lunch_timeout_seconds) { 30 }

  subject do
    Timeout.timeout(lunch_timeout_seconds) do
      philosophers.map do |philosopher|
        Thread.new { philosopher.run_loop }
      end.map(&:join)
    end
  end

  it "successfully lunch before timeout" do
    expect { subject }.to raise_error Timeout::Error
  end
end