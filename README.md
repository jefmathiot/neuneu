# Neuneu : a modest Deep Learning framework for Ruby

![Ruby Build](https://github.com/jefmathiot/neuneu/actions/workflows/main.yml/badge.svg)

## Installation

Install the gem and add to the application's Gemfile by executing:

  $ bundle add neuneu

If bundler is not being used to manage dependencies, install the gem by executing:

  $ gem install neuneu

## Usage

### Training a (very) basic model

The first step is to create a dataset to handle our _training examples_. Here, we use the `Memory`
implementation which wraps an array of examples.

Each of the training examples is composed of a _vector_ (i.e. an array) of inputs and a vector of outputs.
Here, each example consists in a value of temperature in Celsius degrees as the input, and a value in
Fahrenheit degrees as the output:

```ruby
require "neuneu"

data = [
  [[-40.0], [-40.0]],
  [[-10.0], [14.0]],
  [[0.0], [32.0]],
  [[8.0], [46.4]],
  [[15.0], [59.0]],
  [[22.0], [71.6]],
  [[38.0], [100.4]]
]
```

We normalize the inputs and outputs so that their values are shifted to the 0-1 range. We also
tell Neuneu to shuffle values at each training _epoch_ so that there's no influence of the order of the examples on the training process:

```ruby
dataset = Neuneu::Dataset::Memory.new(data, transpose: true)
                                 .normalize!
                                 .shuffle!
```

Now we create a single-layer, single-neuron perceptron _model_, and train it on all examples during 50
_epochs_. We use the _mean squared error_ (MSE) _loss function_ and _"leaky" rectified linear unit_ (LeakyReLU) as the
transfer function:

```ruby
model = Neuneu::Model.new.append(:input, 1)
                         .append(:dense, 1, transfer: :leaky_relu)
model.fit(dataset, epochs: 50, loss: :mean_squared_error)
```

We can show the evolution of the training loss across epochs in the terminal:

```ruby
model.plot(width: 100)
```

Now that our model is trained we can make a prediction on novel/unknown input:

```ruby
model.predict([[100]])
# => 211.7616137915528
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jefmathiot/neuneu.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
