# frozen_string_literal: true

require "test_helper"

describe Neuneu::Model do
  it "creates the backend on initalization" do
    _(Neuneu::Model.new(backend: :ruby).instance_variable_get(:@backend))
      .must_be_instance_of Neuneu::Ruby::Backend
  end

  describe "with a backend mock" do
    %i[backend dataset].each do |object|
      let(object) { Minitest::Mock.new }
    end
    let(:model) { Neuneu::Model.new }

    before do
      model.instance_variable_set(:@backend, backend)
    end

    it "forwards calls to the backend on appending layers" do
      backend.expect(:append, nil, [:type, 1])
      _(model.append(:type, 1)).must_equal model
      backend.verify
    end

    it "forwards calls to the backend on training and stores normalizers" do
      dataset.expect(:inputs_normalizer, i = Object.new)
      dataset.expect(:outputs_normalizer, o = Object.new)
      backend.expect(:fit, nil, [dataset, 1])
      model.fit(dataset, 1)
      _(model.instance_variable_get(:@inputs_normalizer)).must_equal i
      _(model.instance_variable_get(:@outputs_normalizer)).must_equal o
      backend.verify
      dataset.verify
    end

    it "use normalizers on calling predict" do
      model.instance_variable_set(:@inputs_normalizer, i = Minitest::Mock.new)
      model.instance_variable_set(:@outputs_normalizer, o = Minitest::Mock.new)
      i.expect(:convert, [0.5], [[2.0]])
      o.expect(:revert, [2.0], [[1.0]])
      backend.expect(:predict, [[1.0]], [[[0.5]]])
      _(model.predict([[2.0]])).must_equal [[2.0]]
    end

    it "plots history" do
      history = Neuneu::Ruby::History.new
      10.times { |i| history.append(:training, i) }
      backend.expect(:history, history)
      _(model.plot).must_be_instance_of UnicodePlot::Lineplot
      backend.verify
    end
  end

  it "provides history" do
    _(Neuneu::Model.new.history.get(:training)).must_equal []
  end
end
