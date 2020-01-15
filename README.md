# Selling

Selling is an implementation of [riemann.io](http://riemann.io) index and streams using [clojerl](http://clojerl.org).

## Motivation

riemann.io is an amazing project. With a lot plugins to integrate with third-party database, message queues and other systems.

But I've been thinking about extract some of the functionality, that I guess, are very useful in other context. Like processing riemann events using BEAM instead of bringing a complete riemann server.

## Use case

* Allow to build a stream processor using riemann stream functions running on BEAM
* Explore the clojerl implementation

## Colophon

Eduard _Selling_ was a mathematician and inventor of calculating machines. He obtained the doctorate in Munich in 1859, under the supervisor of Bernhard Riemann.

The name of this library is _selling_ because I borrow some ideas and code from riemann project.

## License

The original code from the below files have been borrow from riemann project and are covered by this [LICENSE](LICENSE.riemann).

* common.clje
* folds.clje
* time.clje
* common\_test.clje
* folds\_test.clje

Any other files are coreved by this [LICENSE](LICENSE).
