# Dr. Open Source

[![CircleCI](https://circleci.com/gh/madis/dros.svg?style=svg)](https://circleci.com/gh/madis/dros)

<img src="public/images/logo.png" width="30%">

[Dr. Open Source](https://dros.info) tries to determine open source project's health based on different metrics. It can help people choose projects to contribute to, dependencies to use and hopefully improve existing projects.

## About

Dr. Open Source uses different data available through github api which currently includes:

  - contribution activity
  - issue solving speed, open vs closed issues
  - popularity (stars, forks)

It also provides other different and more detailed metrics for those interested.

## Health

Health in this context is quite subjective measurement. As the greenness of a plant or body weight index does not show the full picture, health measurement made by this project can also be quite subjective and might not always fit everybody's goals.

The plan is to improve over time and to provide different types of metrics and health indicators so people with different goals can get the information they need.

In order to have some baseline to improve upon, I set the following properties to be indicators of good health:

1. Duration of sustained commit activity
  - is the project regularly worked on vs bunch of work done years ago and then left to stand
2. Pull request and issue maintenance
  - ratio of abandoned pull requests
  - how do issues & pull requests get feedback
3. Sharing of responsibilities
  - are there other people besides the owner making contributions

So in one sentence, until there is better model for describing *healthy* open source projects here is the current guiding description:

Open source project is healthy when it is actively maintained, easy to contribute and popular.

> This does not say anything about the functionality or usefulness of the project itself. This was left out because I found no good way to measure it. Suggestions are welcome

## Motivation

I created this project to study statistics and machine learning techniques. To get something useful out right away and lay the foundation, I started with some manual metrics. Going forward, this project will start employing more machine learning methods to make classify & assign scores to the projects. Github api provides lots of useful data and allows these techniques to put into use and hopefully become useful for many.

## Similar projects

- https://github.com/dogweather/repo-health-check
- https://github.com/shtirlic/project-health
- https://github.com/chillu/github-dashing
- http://isitmaintained.com/

