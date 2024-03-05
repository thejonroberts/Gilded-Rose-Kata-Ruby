# Gilded Rose Kata in Ruby

This is a refactoring exercise available for many languages in [this repo](https://github.com/emilybache/GildedRose-Refactoring-Kata). I had seen it used in talks by [Sandi Metz](https://youtu.be/8bZh5LMaSmE?si=Ax91t5D8v60Z00Hj) and Jim Weirich, and it looked like a fun way to practice some refactoring.

I used only the ruby bits. See [Refactor PR](https://github.com/thejonroberts/Gilded-Rose-Kata-Ruby/pull/1) for comparison to original. I added a gemfile with Ruby LSP, Rubocop, and Reek for IDE support while refactoring.

## Installation


## Run the specs from the Command-Line

Ensure you have RSpec installed

`bundle` OR `gem install rspec`

```
rspec gilded_rose_spec.rb
```

## Run the TextTest fixture from the Command-Line

For e.g. 30 days:

```
ruby texttest_fixture.rb 30
```

The output should match the comment in that file (from original repo that uses TextTest).
