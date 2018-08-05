# Applied functional type theory: The science of functional programming

This is a series of in-depth tutorials on functional programming.

The tutorials cover both the theory and the practice of functional programming,
with the goal of building theoretical foundations that are valuable to practitioners.

## Scope of this tutorial series

**Applied functional type theory** (AFTT) is what I call the area of computer science that should serve the needs of functional programmers who are working as software engineers.

It is for these practitioners (I am one myself), rather than for academic researchers,
that I set out to examine the incredible wealth of functional programming inventions over the last 30 years,
-- such as these ["functional pearls" papers](https://wiki.haskell.org/Research_papers/Functional_pearls)
-- and to determine the scope of theoretical material that has demonstrated its pragmatic usefulness and thus belongs to AFTT,
as opposed to material that is purely academic and may be tentatively omitted.

What exactly is the extent of "theory" that a practicing functional programmer should know in order to be effective at writing code?
In my view, this question is not yet resolved.
Once it is resolved, AFTT will be that theory.

Traditional courses of theoretical computer science (algorithms, formal languages, semantics, compilers, etc.) are largely not relevant to AFTT.

Here is an example: To an academic computer scientist, the "theory behind Haskell" is lambda-calculus and formal semantics.
These theories guided the design the Haskell language itself, and also define rigorously what a Haskell program does.
However, a practicing programmer is normally concerned with _using_ a chosen programming language, not with designing it or with proving general theoretical properties of that language.
For this reason, neither the theory of lambda-calculus nor theories of formal semantics will help a programmer to write programs.
So these theories are not within the scope of AFTT.

As an example of theoretical matherial that _is_ within the scope of AFTT, consider the equational laws imposed on applicative functors.
If a programmer wants to use an applicative functor to, say, specify declaratively a set of operations that do not depend on each other and combine these operations,
the programmer can begin by designing a data structure that satisfies the laws of applicative functors.
The programmer first writes down the types of data in that data structure and then checks whether the laws hold.
The data structure may need to be adjusted in order to fit the definition of an applicative functor or its laws.
Once this is verified, the programmer proceeds to write code.
In this way, theory directly informs the programmer about how to write code.

Applicative functors arose from practical usage of Haskell in applications such as parser combinators or domain-specific languages for parallel computations.
It is important for a practicing functional programmer to be able to recognize and use applicative functors.
And yet, no standard computer science textbook would explain applicative functors,
motivates their definition and laws, gives important examples and explores their structure.

So far it appears that AFTT should be a mixture of certain areas of category theory, formal logic, and type theory.
However, software engineers would not derive much benefit from following traditional academic courses in these subjects,
because their choice of material is too theoretical and lacks specific results necessary for practical software engineering.
In other words, the traditional academic courses answer questions that academic computer scientists have, not questions that software engineers have.

Existing literature on these theoretical topics tends to be too abstract.
For example, there are now several books intended as presentations of category theory "for computer science" or even "for programmers".
However, all these books without exception will fail to give examples vitally relevant to everyday programming, but instead emphasize purely theoretical topics such as limits, co-limits, or toposes, with no applications in sight.
At the same time, a software engineer hoping to understand the foundations of functional programming will find no mention of the concepts of foldable, filterable, applicative, or traversable functors in any books on category theory, including books intended for programmers.
And yet, these concepts are necessary to formalize such foundationally important operations as `fold`, `filter`, `zip`, and `traverse` -- operations that functional programmers use every day in their code.

To compensate for the lack of AFTT textbooks, programmers have written many online tutorials for each other, trying to explain the theoretical concepts necessary for practical work.
There are the infamous "monad tutorials", but also tutorials about applicative functors, traversable functors, free monads, and so on.
These tutorials tend to be very hands-on and narrow in scope, limited to one or two specific questions and specific applications.
Such tutorials usually do not present a sufficiently broad picture and do not illustrate deeper connections between these mathematical constructions.

Perhpas the best selection of AFTT tutorial material can be found in the [Haskell wikibooks](https://en.wikibooks.org/wiki/Haskell).
However, those tutorials are incomplete and limited to explaining the use of Haskell.
Many of them are suitable neither as a first introduction nor as a reference on AFTT.

Existing textbooks on type theory and formal logic present quite a few intricacies of domain theory and proof theory
-- which is a lot of information that practicing programmers will have difficulty assimilating and yet will have no hope of ever applying in their daily work.
At the same time, these books never mention practical techniques used in many functional programming libraries today,
such as quantified types, types parameterized by type constructors, or partial type-level functions (known as "type classes").

These books also do not give practical criteria for deciding type isomorphisms or for detecting valid and invalid recursive values, and do not give algorithms for deriving code from logic proofs.
I mention these practical tasks as examples because they are perhaps the only real-world-coding applications of domain theory and the Curry-Howard correspondence theory, besides programming language design.

On the other hand, books such as ["Scala with Cats"](https://underscore.io/books/scala-with-cats/) and ["Functional programming, simplified"](https://alvinalexander.com/scala/functional-programming-simplified-book) are focused on explaining the practical aspects
of programming and do not explain the algebraic laws that support the mathematical structures (such as applicative or monadic functors).

The only existing Scala-based AFTT textbook aiming at the proper scope is the [Bjarnason-Chiusano book](https://www.manning.com/books/functional-programming-in-scala), which balances practical considerations with theoretical developments such as algebraic laws.
I intend to continue at about the same level but dig deeper into the foundations and at the same time give a wider range of examples.

This tutorial series is therefore my attempt to delineate the proper scope of AFTT and to develop a rigorous yet clear and approachable presentation of the chosen material.
Eventually I will convert this tutorial into a new AFTT textbook aimed at practicing functional programmers.

### Choice of the programming language

In the videos, I demonstrate code examples in Scala using the IntelliJ editor because this is what I am most familiar with.
However, most of this material will work equally well in Haskell, OCaml, and other FP languages.
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

- the presentation is self-contained -- introduces and explains all required concepts and Scala language features
- an emphasis on clarity and understandability of all explanations, derivations, and code
    - some terminology and notations are non-standard -- this is in order to achieve a clearer and more logically coherent presentation of the material
- an emphasis on the mathematical principles that guide the practice of functional programming
- all mathematical developments are thoroughly motivated by practical programming issues:
    - theory is developed only in order to answer specific questions that arise in programming
    - examples show how each mathematical construction is used for writing code
    - no developing of abstract theory for theory's sake, without having code written as a result, and without answering a question arising from practical coding
    - mathematical generalizations are not pursued beyond either practical usefulness or immediate pedagogical usefulness
- each new concept or technique has sample code and passing unit tests to illustrate its usage and check correctness
    - currently the libraries `curryhoward`, `cats`, and `scalacheck` are used throughout the sample code
- each new concept or technique is fully explained via "worked examples" and drilled via provided exercises
    - answers to exercises are not provided, but it is verified that the exercises are doable and free of errors

## Current status

The tutorials are currently in development and are being uploaded to [this YouTube playlist](https://www.youtube.com/playlist?list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV) as they become ready.

See also this [Russian mirror](https://ruvideos.org/c/UCWpjX-z6_oNZhcHPzAAQy6g) and [Bitchute mirror](https://www.bitchute.com/channel/fttfp/).

The table of contents and summaries of the finished chapters are given below.

All sample code is available [on github here](https://github.com/winitzki/scala-examples/).

The PDF slides sometimes need minor corrections after recording the YouTube presentations.
Please download the current versions of the PDF slides for your reference.

It is generally advisable to take a look at the slides and the sample code first, before watching the video.
Watch the video when you cannot follow something shown in the slides, or cannot understand the worked examples or solve the exercises.
This can save you time since the videos are quite long and detailed.
If you do watch the videos, consider adjusting the video speed to 1.5x since I am a slow speaker.

# Table of contents

## Chapter 1: Values, types, expressions, functions

[Slides (PDF)](https://github.com/winitzki/talks/blob/master/ftt-fp/01-values-types-expressions.pdf)

[Code examples](https://github.com/winitzki/scala-examples/tree/master/chapter01/src)

[YouTube recording: slides + audio](https://www.youtube.com/watch?v=0Ld79Lnzx_o&index=1&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

Contents in brief:

- Values, types, and functions in Scala
- Named functions and anonymous functions
- Examples of collections, `map`, `filter`, `sum`, etc.
- Higher-order functions
- How to translate mathematical formulas into Scala code
- Worked examples and exercises

## Chapter 2: The functional approach to collections in Scala

[Slides (PDF)](https://github.com/winitzki/talks/blob/master/ftt-fp/02-functional-collections.pdf)

[Code examples](https://github.com/winitzki/scala-examples/tree/master/chapter02/src)

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

[Code examples](https://github.com/winitzki/scala-examples/tree/master/chapter03/src)

[YouTube recording: slides + audio](https://www.youtube.com/watch?v=Z_1s36ba4EY&index=3&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

Contents in brief:

- The types of functions that return functions
- "Curried" functions: their syntax e.g. `f(x)(y)` and how they work
- "Curried" type expressions (`A ⇒ B ⇒ C`)
- Scala type inference: how to give the type annotations
- How to infer the most generic (parametric) types for higher-order functions
- Worked examples and exercises

**Note**: There was an error in the last exercise as shown in the video -- it had no solution.
Please use the exercises from the current version of the PDF slides.

## Chapter 3, part 2: Disjunction types

[Slides (PDF)](https://github.com/winitzki/talks/blob/master/ftt-fp/03-logic-of-types-2.pdf)

[Code examples](https://github.com/winitzki/scala-examples/tree/master/chapter03/src)

[YouTube recording: slides + audio](https://www.youtube.com/watch?v=MTViank6L24&index=4&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

Contents in brief:

- Scala's "case classes" understood as tuples with names
- Pattern-matching syntax for case classes
- Motivation for introducing disjunction types
- First example of disjunction type: `Either[A, B]`
- Implementing disjunction types in Scala via "sealed traits" and case classes
- Using disjunction types to model complicated domains
- Understanding `Option[T]` as disjunction type and as a collection type
- Worked examples and exercises

## Chapter 3, part 3: The Curry-Howard correspondence

[Slides (PDF)](https://github.com/winitzki/talks/blob/master/ftt-fp/03-logic-of-types-3.pdf)

[Code examples](https://github.com/winitzki/scala-examples/tree/master/chapter03/src)

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

- I implemented a library for compile-time code generation from Scala type signatures. The library uses (compile-time) reflection, the Curry-Howard correspondence, and a theorem prover for the constructive propositional logic. Using this library, I illustrate how the Curry-Howard correspondence maps types into propositions and proofs into code. I will also explain some details of the algorithm I used for automatic code generation from type signatures. As an illustration of using this library for automatic code generation, I demonstrate working examples such as implementing `map` and `flatMap` for the Reader and State monads.

Contents in brief:

- How types are interpreted using propositional logic
- Deriving the code of functions by hand, based on types of those functions
- Using the `curryhoward` library to do the same automatically
- The features of the `curryhoward` library
- How the theorem prover works: the calculus LJ of Gentzen and the calculus LJT of Vorobieff-Hudelmaier-Dyckhoff
- How to interpret the derivation rules for sequents
- Building the lambda-calculus proof term from the proof tree
- The "obvious" lemma of Vorobieff

The `curryhoward` library is open-source and available at [this git repository](https://github.com/Chymyst/curryhoward).

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
- Example of what mathematicians mean when they say "it is trivial": Vorobieff's lemma
- How to transform proofs back to code: proof transformer functions that correspond to derivation rules in LJ/LJT
- Example of deriving code automatically from a proof of a sequent
- How to use the "arithmetical Curry-Howard correspondence" to decide which types are equivalent
- What are polynomial data types and exponential-polynomial data types
- Summary: What are the practical uses of the CH correspondence
- Limitations of the propositional logic: what it can and cannot do
- Using the CH correspondence as a guide in programming language design

## Chapter 4: Functors: their laws and structure

[Slides (PDF)](https://github.com/winitzki/talks/blob/master/ftt-fp/04-functors.pdf)

[Code examples](https://github.com/winitzki/scala-examples/tree/master/chapter04/src)

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

[Code examples](https://github.com/winitzki/scala-examples/tree/master/chapter05/src)

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

## Chapter 6: Computations in a functor context I. Filterable functors, their laws and structure. Part 1: Examples. Working with filterable functors

[Slides (PDF)](https://github.com/winitzki/talks/blob/master/ftt-fp/06-filterable-functors.pdf) (Part 1 covers slides 1 to 8.)

[Code examples](https://github.com/winitzki/scala-examples/tree/master/chapter06/src)

[YouTube recording: slides + audio](https://www.youtube.com/watch?v=20PYTn_aUqE&index=10&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

Contents in brief:

- "Functor block" (Scala's `for`/`yield` block syntax) and filterable functors
- Examples of polynomial filterable functors
- Intuitions behind the notion of "filtering" the data in a container
- Deriving the filterable functor laws from the intuitions
- Examples of functors that are not filterable, and reasons why
- Defining the `Filterable` type class and checking the laws with `scalacheck`
- Example of a filterable contrafunctor
- Worked examples and exercises

## Chapter 6: Computations in a functor context I. Filterable functors, their laws and structure. Part 2: Filterable functors in depth

[Slides (PDF)](https://github.com/winitzki/talks/blob/master/ftt-fp/06-filterable-functors.pdf) (Part 2 covers slides 9 to end.)

[Code examples](https://github.com/winitzki/scala-examples/tree/master/chapter06/src)

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

## Chapter 7: Computations in a functor context II. Monads and semimonads. Part 1: Intuitions, examples, use cases

[Slides (PDF)](https://github.com/winitzki/talks/blob/master/ftt-fp/07-monads-part1.pdf)

[Code examples](https://github.com/winitzki/scala-examples/tree/master/chapter07/src)

[YouTube recording: slides + audio](https://www.youtube.com/watch?v=3hzb0frNI48&index=12&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

Contents in brief:

- Using "functor blocks" (Scala's `for`/`yield` syntax) for nested iteration
- The difference between semimonads and monads
- Visual explanation of how `flatMap` operates on sequences
- Intuitions behind using several generator arrows with sequences
- Overview of the different kinds of monads: list-like, pass/fail, tree-like, single-value
- Examples of working with list-like monads: permutations, 8 queens, Boolean algebra calculations
- Using (non-tail) recursion in a functor block
- Overview of pass/fail monads: `Option`, `Either`, `Try`, `Future`
- Examples of working with pass/fail monads to achieve safety and to sequence computations
- How to make `Future`s parallel even though they are sequenced within a functor block
- Examples of functor-shaped tree constructions
- Visual explanation of how `flatMap` grafts subtrees on trees, and what "flattening" means for trees
- Single-value monads: `Writer`, `Reader`, `Eval`, `Cont`, `State`, understood as representing a "single value with context"
- Practical example: Using `Writer` as a semimonad, based on a semigroup
- Using the continuation monad to avoid "callback hell"
- A systematic derivation of the `Writer`, `Reader`, `Cont`, `State` type constructors from the type signature of `flatMap`
- Worked examples and exercises

There was an error in the presentation: The power-of-2 tree _can_ be represented as a recursive type constructor, contrary to what I said in the video.
(But it is not naturally monadic in the way other tree-like monads are.) Download the latest slides for the corrected text.

## Chapter 7: Computations in a functor context II. Monads and semimonads. Part 2: Laws and structure of monads

[Slides (PDF)](https://github.com/winitzki/talks/blob/master/ftt-fp/07-monads-part2.pdf)

[Code examples](https://github.com/winitzki/scala-examples/tree/master/chapter07/src)

[YouTube recording: slides + audio](https://www.youtube.com/watch?v=p0fH_adTCnQ&index=13&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

The recording was too long for YouTube to produce subtitles. For convenience, I split the recording into two halves, each now with subtitles.

- [YouTube recording, slides + audio: Part 1 of 2](https://www.youtube.com/watch?v=u_XH7XkvFWM&index=14&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)
- [YouTube recording, slides + audio: Part 2 of 2](https://www.youtube.com/watch?v=rKQqdAF9ecA&index=15&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)


Contents in brief:

- How to derive the laws for `flatMap` from our intuitions about functor block computations
- Deriving the laws for `flatten` from the laws for `flatMap`
- Why `flatten` is equivalent to `flatMap`, and what it means to be "equivalent" here
- Why `flatten` has one law fewer than `flatMap`
- How parametricity assures naturality laws
- Worked examples showing how to verify the associativity law for all standard monads
- Examples of incorrect implementation of `flatten` that violates the associativity law
- Motivation for full monads and laws for the `pure` method
- Deriving the laws for `pure` in terms of `flatten`
- Reformulating the monad laws in terms of Kleisli functions
- A simplified definition of "category" and "morphism"
- How category theory provides a conceptual generalization of "lifting"
- Deriving the laws of `pure`, `flatten`, and `flatMap` from the laws of Kleisli category
- Structure of semigroups and monoids: how to build up semigroups and monoids from parts
- Structure of semimonads and monads: building up new monads from previously given monads, functors, and contrafunctors
- Worked examples with full derivations of laws for most of the constructions
- Why certain constructions can be only semimonads but not full monads
- Why there cannot be a contravariant monad
- Exercises, with examples and counter-examples of semimonads and monads

## Chapter 8: Applicative functors and profunctors. Part 1: Practical examples

[Slides (PDF)](https://github.com/winitzki/talks/blob/master/ftt-fp/08-applicatives-part1.pdf)

[Code examples](https://github.com/winitzki/scala-examples/tree/master/chapter08/src)

[YouTube recording: slides + audio](https://www.youtube.com/watch?v=NVlFZYxgXDw&index=16&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

Contents in brief:

- Why monads do not usually describe effects that are independent or commutative
- Intuitions behind the `map2` function, coming from monads
- Generalize `map`, `map2`, to `map3` and `mapN`
- How to implement `map2` and `map3` for `Either` to collect multiple errors from computations
- Why the Future and the Reader monads already have commutative and independent effects
- How to transpose a matrix by using `map2` with `List`
- Profunctors and their distinction from functors and contrafunctors
- How to use profunctors to combine several `fold` passes into one
- The distinction between applicative `fold` combinator and the monadic combinator: running average of running average
- The distinction between applicative parser combinator and the monadic parser combinator: stopping at errors
- Exercises

## Chapter 8, part 1, addendum: Combining `fold` operations

[YouTube recording: live coding session](https://www.youtube.com/watch?v=oVxCJ3h_Wqs&index=17&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

[Code examples](https://github.com/winitzki/scala-examples/blob/master/chapter08/src/test/scala/example/FoldsPresentation.scala)

The main topic is to illustrate how several `fold` operations can be combined automatically into a single traversal. In Chapter 8, part 1, the central pieces of code were implemented automatically using the `curryhoward` library. This live coding session shows the implementation and explains how it works in more detail.

- Defining a `fold` operation as a data structure and running it afterwards
- Combining several `fold` operations into one
- Implementing the applicative `zip` operation is possible on `fold`s despite `fold` not being a functor
- Adding a final transformation to a `fold`, to make it into a functor
- Implementing a DSL for `fold`s so that running average and standard deviation can be expressed concisely
- Illustrating the difference between applicative and monadic combinators for `fold`s

## Chapter 8: Applicative functors and profunctors. Part 2: Laws and structure

[Slides (PDF)](https://github.com/winitzki/talks/blob/master/ftt-fp/08-applicatives-part2.pdf)

[Code examples](https://github.com/winitzki/scala-examples/tree/master/chapter08/src)

The video for part 2 is very long and will be recorded in 3 portions.

[YouTube recording: slides + audio, portion 1 of 3](https://www.youtube.com/watch?v=xBDkBriX7Uk&index=18&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

Portion 1 of 3 covers slides 1 to 15.

Contents in brief:

How to generalize `map2`, `map3`, `map4` to `mapN` in a systematic way
Motivation behind introducing the `ap` and `zip` methods for applicative functors
Computational equivalence of `map2`, `ap`, and `zip`
Motivation for the applicative laws: rewrite the monad laws in terms of `map2`
Deriving the laws for `zip` to uncover the monoidal structure of the laws
Defining `pure` through "wrapped unit"
Recovering the 3rd naturality law for `map2`
Deriving the laws for the applicative category
Deriving the laws for `ap` as functor "lifting" laws from category laws
Overview of applicative functor constructions



# Roadmap

0. Cut the scope
1. Finish all videos
2. Write the book

I plan to cover the following further material:

- traversable functors, foldable functors
- a general way of implementing and using "free" constructions (free monoid, free functor, free monad, free applicative etc.)
- monad transformers, mtl (?), extensible effects ("types à la carte") - problems and solutions
- various solutions for the "expression problem"
- the following list of functional programming concepts needs to be revisited to exclude concepts that appear to be not very useful in practice:
    - catamorphisms and other "something-morphisms" (?)
    - comonads and co-applicative functors (?)
    - rigid functors (need better use cases for those) (?)
    - recursive types, row polymorphism / column polymorphism; type-level and functor-level fixpoints; `matryoshka` library, recursion schemes; when is a recursive type well-defined, lazy / eager evaluation
    - trampolines in the standard Scala library; monadic tail recursion and stack safety
    - cofree comonads (?)
    - coroutines, continuations library and "shift/reset programming" (?)
    - zippers / type derivatives (?)
    - lenses / prisms and other "optics"
    - arrows and their relationship to functions (?)
    - Kan extensions, "codensity", other second-order tricks (?)
    - initial vs. final representations of data types ("final tagless" vs. "initial tagful" interpreters)
    - type-level constructions, type-level programming à la `shapeless`, basic usage of dependent types
    - interpretation of OO programming from the perspective of AFTT
    - design patterns of FP that replace OO design patterns
    - functional reactive programming, temporal logic, and UIs
    - an example of a full-stack application implemented in Scala with FP patterns
- browse the recent Scala and Haskell FP books to see if I have missed something important
