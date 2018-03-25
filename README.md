# Applied functional type theory: A tutorial on functional programming

This is a series of extensive tutorials on functional programming.

The tutorials cover both the theory and the practice of functional programming.

**Applied functional type theory** (AFTT) is what I call the subdomain of computer science that should serve the needs of functional programmers who are working as software engineers.

It is these practitioners, rather than the academic researchers, who need to examine the incredible wealth of functional programming inventions over the last 30 years, -- such as these ["functional pearls" papers](https://wiki.haskell.org/Research_papers/Functional_pearls) -- and to determine which theoretical material has demonstrated its pragmatic usefulness and thus belongs to AFTT, and which material may be tentatively omitted.
This tutorial series is therefore also an attempt to define the proper scope of AFTT.

In the videos, I demonstrate code examples in Scala using the IntelliJ editor because this is what I am most familiar with.
However, most of this material will work equally well in Haskell and some other FP languages.
This is so because AFTT is not specific to Scala or Haskell, -- a serious user of any other functional programming language will have to face the same questions and struggle with the same practical issues.

## Uncopyright

All lecture content is authored by [Sergei Winitzki, Ph.D](https://sites.google.com/site/winitzki).

The lecture materials are released into the public domain under a [CC-0 license, which is an "uncopyright"](https://github.com/winitzki/talks/blob/master/LICENSE).

## Intended audience

The material is presented here at medium to advanced level.
It is not suitable for people unfamiliar with school-level algebra, or for people who are generally allergic to mathematics, or for people unwilling to learn new and difficult concepts through prolonged mental concentration.

The first two chapters are introductory and may be suitable for beginners in programming.
Starting from chapter 4, the material becomes unsuitable for beginners.

## Main features and goals of this tutorial series

- an emphasis on the mathematical principles that guide the practice of functional programming
- the presentation is self-contained -- introduces and explains all required concepts and Scala features
- an emphasis on clarity and understandability of all explanations, derivations, and code
    - some terminology and notations are non-standard -- this is in order to achieve a clearer and more logically coherent presentation of the material
- all mathematical developments are thoroughly motivated by practical programming issues
    - avoid developing abstract theory for theory's sake
    - examples must show how each mathematical construction is used in practice for writing code
    - mathematical generalizations are not pursued beyond either practical usefulness or immediate pedagogical usefulness
- each new concept or technique has sample code and unit tests to illustrate its usage and check correctness
    - currently the libraries `cats` and `scalacheck` are used throughout the sample code
- each new concept or technique is fully explained via "worked examples" and drilled via provided exercises
    - answers to exercises are not provided, but it is verified that the exercises are doable and free of errors

## Current status

The tutorials are currently in development and are being uploaded to [this YouTube playlist](https://www.youtube.com/playlist?list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV) as they become ready.

(This [Russian mirror](https://ruvideos.org/c/UCWpjX-z6_oNZhcHPzAAQy6g) that allows you to download the videos more easily.)

See below for the summaries of the finished chapters.

All sample code is available [on github here](https://github.com/winitzki/scala-examples/tree/master/).

The PDF slides often need minor corrections after recording the YouTube presentation.
Please download the current versions of the PDF slides for your reference.

It is generally advisable to take a look at the slides and the sample code first, before watching the video.
Watch the video when you cannot follow something shown in the slides, or cannot understand the worked examples or solve the exercises.
This can save you time since the videos are quite long and detailed.

# Table of contents

## Chapter 1: Values, types, expressions, functions

[Slides (PDF)](https://github.com/winitzki/talks/blob/master/ftt-fp/01-values-types-expressions.pdf)

[YouTube recording: slides + audio](https://www.youtube.com/watch?v=0Ld79Lnzx_o&index=1&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

Contents in brief:

- Values, types, and functions in Scala
- Named functions and anonymous functions
- Examples of collections, `map`, `filter`, `sum`, etc.
- Higher-order functions
- How to translate mathematical formulas into Scala code
- Examples and exercises

## Chapter 2: The functional approach to collections in Scala

[Slides (PDF)](https://github.com/winitzki/talks/blob/master/ftt-fp/02-functional-collections.pdf)

[YouTube recording: slides + audio](https://www.youtube.com/watch?v=XFrWZ7QIE2s&index=2&t=7s&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

Contents in brief:

- Tuples and pattern matching
- Using tuples with `Map[]` and `Seq[]` collections (`zip`, `map`, `flatMap`, etc.)
- Writing functions with type parameters
- Implementing mathematical induction with recursion
- Tail recursion and the accumulator trick
- Using `foldLeft`, `scan`, `iterate` instead of writing recursion by hand
- Worked examples and exercises

## Chapter 3, part 1: The types of higher-order functions

[Slides (PDF)](https://github.com/winitzki/talks/blob/master/ftt-fp/03-logic-of-types-1.pdf)

[YouTube recording: slides + audio](https://www.youtube.com/watch?v=Z_1s36ba4EY&index=3&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

Contents in brief:

- The types of functions that return functions
- "Curried" functions: their syntax e.g. `f(x)(y)` and how they work
- "Curried" type expressions (`A ⇒ B ⇒ C`)
- Scala type inference: how to give the type annotations
- How to infer the most generic (parametric) types for higher-order functions
- Worked examples and exercises

**Note**: There was an error in the last exercise as shown in the video - it had no solution.
Please use the exercises from the current version of the PDF slides.

## Chapter 3, part 2: Disjunction types

[Slides (PDF)](https://github.com/winitzki/talks/blob/master/ftt-fp/03-logic-of-types-2.pdf)

[YouTube recording: slides + audio](https://www.youtube.com/watch?v=MTViank6L24&index=4&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

Contents in brief:

- Scala's "case classes" understood as tuples with names
- Pattern-matching syntax for case classes
- Motivation for introducing disjunction types
- First example of disjunction type: `Either[A, B]`
- Implementing disjunction types via "sealed traits" and case classes
- Using disjunction types to model complicated domains
- Understanding `Option[T]` as disjunction type and as a collection type
- Worked examples and exercises

## Chapter 3, part 3: The Curry-Howard correspondence

[Slides (PDF)](https://github.com/winitzki/talks/blob/master/ftt-fp/03-logic-of-types-3.pdf)

[YouTube recording: slides + audio](https://www.youtube.com/watch?v=sSDGjdfFQ-Y&index=5&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

Contents in brief:

- How types are interpreted using propositional logic
- How to write type expressions in the shorthand notation
- The four-point correspondence between propositions/proofs and types/code
- How to verify or to refute isomorphism (equivalence) relationships between types
- Identities in logic vs. identities in arithmetic: the two sides of the CH correspondence
- Deriving the code of functions based on types of those functions
- Exponential-polynomial types vs. "algebraic" types
- Recursive polynomial type (`List`) and its type formula
- Worked examples and exercises

## Chapter 3, addendum 1: Generating code with the Curry-Howard correspondence: Type inhabitation at compile time

[Slides (PDF)](https://github.com/winitzki/talks/blob/master/ftt-fp/curryhoward-2017.pdf)

[YouTube recording: slides + audio](https://www.youtube.com/watch?v=cESdgot_ZxY&index=6&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

This optional Addendum to Chapter 3 presents an open-source library `curryhoward` that implements some functions automatically in Scala, given their type signature.

Abstract:

- I implemented a library for compile-time code generation from Scala type signatures. The library uses (compile-time) reflection, the Curry-Howard correspondence, and a theorem prover for the constructive propositional logic. Using this library, I illustrate how the Curry-Howard correspondence maps types into propositions and proofs into code. I will also explain some details of the algorithm I used for automatic code generation from type signatures. As an illustration of using this library for automatic code generation, I demonstrate working examples such as implementing map and flatMap for the Reader and State monads.

Contents in brief:

- How types are interpreted using propositional logic
- Deriving the code of functions by hand, based on types of those functions
- Using the `curryhoward` library to do the same automatically
- The features of the `curryhoward` library
- How the theorem prover works: the calculus LJ of Gentzen and the calculus LJT of Vorobieff-Hudelmaier-Dyckhoff
- How to interpret the derivation rules for sequents
- Building the lambda-calculus proof term from the proof tree
- The "obvious" theorem of Vorobieff

The `curryhoward` library is open-source and available at [this git repository](https://github.com/Chymyst/curryhoward)

## Chapter 3, addendum 2: A pedagogical introduction to Curry-Howard correspondence and its applications, for programmers

[Slides (PDF)](https://github.com/winitzki/talks/blob/master/ftt-fp/curryhoward-2018-tutorial.pdf)

[YouTube recording: slides + audio](https://www.youtube.com/watch?v=KcfD3Iv--UM&index=7&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

This optional addendum to Chapter 3 explains the Curry-Howard correspondence in more detail than it was done in Chapter 3, part 3. There are no exercises in this tutorial; Chapter 3 already contains exercises covering some of this material.

Title:

Introduction to the Curry-Howard correspondence:
The logic of types in functional programming languages

Contents in brief:

- The commonality of type constructions in functional programming languages: Scala, OCaml, Haskell
- Defining the propositions that correspond to types
- What are "sequents" and how they are used to describe logical inference from premises
- How logical derivations correspond to expressions in the programming language; how to convert one to the other and back
- What is the "logic of types" defined by the common type constructions in the functional programming languages: it is the intuitionistic propositional logic (IPL)
- Examples that contrast the IPL with the classical Boolean logic
- Example of using Gentzen's calculus LJ to search for a proof
- The advantage of the Vorobieff-Hudelmaier-Dyckhoff's calculus LJT over Gentzen's calculus LJ, and why people are using LJT for proof search
- Example of what mathematicians mean when they say "it is trivial"
- How to transform proofs back to code: proof transformer functions that correspond to derivation rules in LJ/LJT
- Example of deriving code automatically from a proof of a sequent
- How to use the "arithmetical Curry-Howard correspondence" to decide which types are equivalent
- What are polynomial data types and exponential-polynomial data types
- Summary: What are the practical uses of the CH correspondence
- Limitations of the propositional logic: what it can and cannot do
- Using the CH correspondence as a guide in programming language design

## Chapter 4: Functors: their laws and structure

[Slides (PDF)](https://github.com/winitzki/talks/blob/master/ftt-fp/04-functors.pdf)

[YouTube recording: slides + audio](https://www.youtube.com/watch?v=OGut2iZW0JU&index=8&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

Contents in brief:

- Abstracting the properties of a "data container"
- Motivation for the functor laws
- Examples of functors and non-functors
- Examples of deriving a functor's `fmap` from its type and checking the laws
- Contrafunctors; covariance and contravariance
- How to decide whether a type constructor is a functor, a contrafunctor, or neither
- Building up the structure for exponential-polynomial functor types: functor product, disjunction, implication, composition, recursion
- How to prove the functor laws for each build-up step
- Worked examples and exercises

## Chapter 5: Type-level functions and type classes

[Slides (PDF)](https://github.com/winitzki/talks/blob/master/ftt-fp/05-type-classes.pdf)

[YouTube recording: slides + audio](https://www.youtube.com/watch?v=QhqsBgJ8lm8&index=9&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

Contents in brief:

- Total and partial functions at value level and at type level
- GADTs as partial type-to-type functions
- Using type evidence values to define partial type-to-value functions (PTVFs)
- Type classes understood as PTVFs
- Using Scala's implicit value mechanism to define type classes
- Examples of type classes: `Semigroup`, `Monoid`, `Functor`
- Higher-order type functions; kinds as a "type system for types"
- Using Scala's "implicit method" syntax with type classes
- Using the `cats` library to define type class instances
- Using the `scalacheck` library to verify type class laws
- Worked examples and exercises

## Chapter 6, part 1: Computations in a functor context I. Filterable functors, their laws and structure. Part 1. Examples. Working with filterable functors

[Slides (PDF)](https://github.com/winitzki/talks/blob/master/ftt-fp/06-filterable-functors.pdf) (Part 1 covers only slides 1 to 8.)

[YouTube recording: slides + audio](https://www.youtube.com/watch?v=20PYTn_aUqE&index=10&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

Contents in brief:

- "Functor blocks" (Scala's `for`/`yield` syntax) and filterable functors
- Examples of polynomial filterable functors
- Intuitions behind the notion of "filtering" the data in a container
- Deriving the filterable functor laws from the intuitions
- Examples of functors that are not filterable, and reasons why
- Defining the `Filterable` type class and checking the laws with `scalacheck`
- Example of a filterable contrafunctor
- Worked examples and exercises

## Chapter 6, part 2: Computations in a functor context I. Filterable functors, their laws and structure. Part 2. Filterable functors in depth

[Slides (PDF)](https://github.com/winitzki/talks/blob/master/ftt-fp/06-filterable-functors.pdf) (Part 2 covers only slides 9 to end.)

[YouTube recording: slides + audio](https://www.youtube.com/watch?v=GO4qq5_v1o0&index=11&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

Contents in brief:

- Equivalent definition of `Filterable` type class via `deflate` or `mapOption` instead of `withFilter`
- How to simplify the laws of filterable functors by using a Kleisli category
- Detailed derivations of laws for `mapOption`
- Intuitions behind natural transformations and naturality laws
- What category theory does for us, and what it does not do
- Constructions of filterable functors from other functors
- Intuitions behind filterable contrafunctors vs. filterable functors
- Fiilterable contrafunctors: their laws and structure (in brief)
- Worked examples and exercises

## Chapter 7, part 1: Computations in a functor context II. Monads and semimonads. Part 1: Practical work with monads and semimonads

[Slides (PDF)](https://github.com/winitzki/talks/blob/master/ftt-fp/07-monads-part1.pdf)

[YouTube recording: slides + audio](https://www.youtube.com/watch?v=20PYTn_aUqE&index=12&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

Contents in brief:

- Using "functor blocks" (`for`/`yield` syntax) for nested iteration
- The difference between semimonads and monads
- Visual explanation of how `flatMap` operates on sequences
- Intuitions behind using several generator arrows with sequences
- The different kinds of monads: list-like, pass/fail, tree-like, single-value
- Examples of working with list-like monads: permutations, 8 queens, and other tasks
- Using recursion in a functor block
- Pass/fail monads: `Option`, `Either`, `Try`, `Future`
- Examples of working with pass/fail monads to achieve safety and to sequence computations
- How to make `Future`s parallel even though they are sequenced within a functor block
- Examples of functor-shaped tree constructions
- Visual explanation of how `flatMap` grafts subtrees on trees, and what "flattening" means for trees
- Single-value monads: `Writer`, `Reader`, `Eval`, `Cont`, `State`; representing a "single value with context"
- Using `Writer` as a semimonad, to keep track of elapsed time
- Using the continuation monad to avoid "callback hell"
- A systematic derivation of the `Writer`, `Reader`, `Cont`, `State` type constructors from the type signature of `flatMap`
- Worked examples and exercises

# Roadmap

I plan tentatively to cover the following further material:

- semimonads, monads, zippable / applicative functors, traversable functors, foldable functors -- with full derivations and analysis of the laws
- possibly, contrafunctors with similar properties
- a general way of implementing and using "free" constructions (free monoid, free functor, free monad, free applicative etc.)
- monad transformers, mtl, extensible effects ("types à la carte") - problems and solutions
- various solutions of the "expression problem"
- from the following list of functional programming concepts, those that appear to be useful in practice will be covered, others omitted:
    - catamorphisms and other "something-morphisms" (?)
    - comonads and co-applicative functors (?)
    - rigid functors (need better use cases for those) (?)
    - type-level and functor-level fixpoints; `matryoshka`
    - trampolines in the standard library; monadic tail recursion
    - cofree comonads (?)
    - continuations library and "shift/reset programming" (?)
    - zippers / type derivatives (?)
    - lenses / prisms and other "optics"
    - arrows and their relationship to functions (?)
    - Kahn extensions, "codensity", other second-order tricks (?)
    - initial vs. final representations of data types ("final tagless" interpreters)
    - type-level constructions, basics of dependent types
- interpretation of OO programming from the perspective of AFTT
- design patterns of FP that replace OO design patterns
- functional reactive programming, temporal logic, and UIs
- an example of a full-stack application implemented in Scala with FP patterns
- browse the recent Scala and Haskell FP books to see if I have missed something important
