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

Traditional courses of theoretical computer science (algorithms, traditional data structures, complexity theory, formal languages, formal semantics, compiler techniques, databases, networking, operating systems, etc.) are largely not relevant to AFTT.

Here is an example:
To an academic computer scientist, the "science behind Haskell" is the theory of lambda-calculus, the type-theoretic "System Fω", and formal semantics.
These theories guided the design of the Haskell language and define rigorously what a Haskell program "means" in a mathematical sense.

However, a practicing programmer is concerned with _using_ a chosen programming language to _write code_.
A practicing Haskell or Scala programmer is not concerned with designing Haskell or Scala, or with proving general theoretical properties of those languages.

For this reason, neither the theory of lambda-calculus, nor the proofs of type-theoretical properties of "System Fω",
nor theories of formal semantics will actually help a programmer to write code.

So all these theories are not within the scope of AFTT.

As an example of theoretical material that _is_ within the scope of AFTT, consider the equational laws imposed on applicative functors.

An applicative functor is a data structure can specify declaratively a set of operations that do not depend on each other's effects.
Programs can then easily combine these operations, for example, in order to execute them in parallel, or to refactor the program for better maintainability.

To use this functionality, the programmer can begin by designing a data structure that satisfies the laws of applicative functors.
The programmer first writes down the type of that data structure and the code implementing the required methods, and then checks that the laws hold.
The data structure may need to be adjusted in order to fit the definition of an applicative functor or its laws.

This work is done using pen and paper, in a mathematical notation.
Once the applicative laws are verified, the programmer proceeds to write code using that data structure.

Because of the proofs, it is assured that the data structure satisfies the known properties of applicative functors, no matter how the rest of the program is written.
So, for example, it is assured that the relevant effects can be automatically parallelized, as is usual with applicative functors.

In this way, AFTT directly guides the programmer and helps to write correct code.

Applicative functors were discovered by people who were using Haskell for writing code,
in applications such as parser combinators, compilers, or domain-specific languages for parallel computations.

It is important for a practicing functional programmer to be able to recognize and use applicative functors.

Applicative functors are not a feature of Haskell: they are the same in Scala, OCaml, or any other functional programming language.
And yet, no standard computer science textbook explains applicative functors,
motivates their definition and laws, gives important examples and explores their structure,
or gives examples of a data structure that is not an applicative functor and explains why.
(Neither does any book on category theory or type theory mention applicative functors.)

So far it appears that AFTT should be a mixture of certain areas of category theory, formal logic, and type theory.
However, software engineers would not derive much benefit from following traditional academic courses in these subjects,
because their choice of material is too theoretical and lacks specific results necessary for practical software engineering.
In other words, the traditional academic courses answer questions that academic computer scientists have, not questions that software engineers have.

Existing literature on these theoretical topics tends to be too abstract.

For example, there are now several books intended as presentations of category theory "for computer science" or even "for programmers".
However, all these books fail to give examples vitally relevant to everyday programming, such as applicative or traversable functors.
Instead, these books contain purely theoretical topics such as limits, adjunctions, or toposes, - concepts that have no applications in practical functional programming today.

At the same time, a software engineer hoping to understand the foundations of functional programming will find no mention of the concepts of foldable, filterable, applicative, or traversable functors in any books on category theory, including books intended for programmers.
And yet, these concepts are necessary to obtain a mathematically correct implementation of
such foundationally important operations as `fold`, `filter`, `zip`, and `traverse` -- operations that functional programmers use every day in their code.

To compensate for the lack of AFTT textbooks, programmers have written many online tutorials for each other, trying to explain the theoretical concepts necessary for practical work.
There are the infamous "monad tutorials", but also tutorials about applicative functors, traversable functors, free monads, and so on.
These tutorials tend to be very hands-on and narrow in scope, limited to one or two specific questions and specific applications.
Such tutorials usually do not present a sufficiently broad picture and do not illustrate deeper connections between these mathematical constructions.

For example, "free monads" became popular in the Scala community around 2015.
Many talks about free monads were presented at Scala engineering conferences,
each giving their own slightly different implementation
but never formulating rigorously the required properties for a piece of code to be a valid implementation of the free monad.

Without knowledge of mathematical principles behind free monads, a programmer cannot make sure that a given implementation is correct.
However, books on category theory present free monads in a way that is unsuitable for programming applications (a free monad is an adjoint functor to a forgetful functor into the category of sets).
This definition is too abstract and cannot be used to verify whether a given implementation of the free monad in Scala is correct.

Perhaps the best selection of AFTT tutorial material can be found in the [Haskell wikibooks](https://en.wikibooks.org/wiki/Haskell).
However, those tutorials are incomplete and limited to explaining the use of Haskell.
Many of them are suitable neither as a first introduction nor as a reference on AFTT.

Existing textbooks on type theory and formal logic present quite a few intricacies of domain theory and proof theory
-- which is a lot of information that practicing programmers will have difficulty assimilating and yet will have no hope of ever applying in their daily work.
At the same time, these books never mention practical techniques used in many functional programming libraries today,
such as quantified types, types parameterized by type constructors, or partial type-level functions (known as "typeclasses").

These books also do not give practical criteria for deciding type isomorphisms or for detecting valid and invalid recursive values, and do not give algorithms for deriving code from logic proofs.
I mention these practical tasks as examples because they are perhaps the only real-world-coding applications of domain theory and the Curry-Howard correspondence theory, besides programming language design.

On the other hand, books such as ["Scala with Cats"](https://underscore.io/books/scala-with-cats/) and ["Functional programming, simplified"](https://alvinalexander.com/scala/functional-programming-simplified-book) are focused on explaining the practical aspects
of programming and do not explain the algebraic laws that the mathematical structures require (such as the laws for applicative or monadic functors).

The only existing Scala-based AFTT textbook aiming at the proper scope is the [Bjarnason-Chiusano book](https://www.manning.com/books/functional-programming-in-scala), which balances practical considerations with theoretical developments such as algebraic laws.
I intend to continue at about the same level but dig deeper into the foundations and at the same time give a wider range of examples.

This series of tutorial videos is my attempt to delineate the proper scope of AFTT and to develop a rigorous yet clear and approachable presentation of the chosen material.
Eventually I will convert these videos into a new AFTT textbook aimed at practicing functional programmers.
The book will teach programmers how to reason mathematically about types and code, in a way that is directly relevant to practical programming.

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
Starting from the middle of chapter 3, the material becomes unsuitable for beginners.

## Main features and goals of this tutorial series

- the presentation is self-contained -- introduces and explains all required notations, concepts, and Scala language features
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

If you do watch the videos, consider adjusting the video speed up to 1.5x; I am a slow speaker.

# Table of contents

## Chapter 1: Values, types, expressions, functions

[Slides (PDF)](https://github.com/winitzki/talks/blob/master/ftt-fp/01-values-types-expressions.pdf)

[Code examples](https://github.com/winitzki/scala-examples/tree/master/chapter01/src)

[YouTube recording: slides + audio](https://www.youtube.com/watch?v=0Ld79Lnzx_o&index=2&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

Contents in brief:

- Values, types, and functions in Scala
- Named functions and anonymous functions
- Examples of collections, `map`, `filter`, `sum`, etc.
- Higher-order functions
- How to translate mathematical formulas into Scala code
- Worked examples and exercises

[Summary for Chapter 1](https://www.youtube.com/watch?v=rZfAljJdKmI&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV&index=3)

## Chapter 2: The functional approach to collections in Scala

[Slides (PDF)](https://github.com/winitzki/talks/blob/master/ftt-fp/02-functional-collections.pdf)

[Code examples](https://github.com/winitzki/scala-examples/tree/master/chapter02/src)

[YouTube recording: slides + audio](https://www.youtube.com/watch?v=XFrWZ7QIE2s&index=4&t=7s&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

Contents in brief:

- Tuples and pattern matching
- Using tuples with `Map[]` and `Seq[]` collections (`zip`, `map`, `flatMap`, etc.)
- Writing functions with type parameters
- Implementing mathematical induction with recursion
- Tail recursion and the accumulator trick
- Using `foldLeft`, `scan`, `iterate` instead of writing recursion by hand
- Worked examples and exercises

[Summary for Chapter 2](https://www.youtube.com/watch?v=qrvmxdBletE&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV&index=5)

## Chapter 3, part 1: The types of higher-order functions

[Slides (PDF)](https://github.com/winitzki/talks/blob/master/ftt-fp/03-logic-of-types-1.pdf)

[Code examples](https://github.com/winitzki/scala-examples/tree/master/chapter03/src)

[YouTube recording: slides + audio](https://www.youtube.com/watch?v=Z_1s36ba4EY&index=6&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

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

[YouTube recording: slides + audio](https://www.youtube.com/watch?v=MTViank6L24&index=7&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

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

[YouTube recording: slides + audio](https://www.youtube.com/watch?v=sSDGjdfFQ-Y&index=8&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

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

[Summary for Chapter 3, parts 1 to 3](https://www.youtube.com/watch?v=RbT3K1Km2NQ&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV&index=9)

## Chapter 3, addendum 1: Generating code with the Curry-Howard correspondence: Type inhabitation at compile time

[Slides (PDF)](https://github.com/winitzki/talks/blob/master/ftt-fp/curryhoward-2017.pdf)

[YouTube recording: slides + audio](https://www.youtube.com/watch?v=cESdgot_ZxY&index=10&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

This optional Addendum to Chapter 3 presents the open-source library `curryhoward` that implements some functions automatically in Scala, given their type signature.

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

[YouTube recording: slides + audio](https://www.youtube.com/watch?v=KcfD3Iv--UM&index=11&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

This optional addendum to Chapter 3 explains the Curry-Howard correspondence in more detail than it was done in Chapter 3, part 3. There are no exercises in this tutorial; Chapter 3 already contains exercises covering some of this material.

Title:

_Introduction to the Curry-Howard correspondence: The logic of types in functional programming languages_

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

[Summary for Chapter 3, Addenda 1 and 2](https://www.youtube.com/watch?v=ozjWYoqPt4s&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV&index=12)

## Chapter 4: Functors: their laws and structure

[Slides (PDF)](https://github.com/winitzki/talks/blob/master/ftt-fp/04-functors.pdf)

[Code examples](https://github.com/winitzki/scala-examples/tree/master/chapter04/src)

[YouTube recording: slides + audio](https://www.youtube.com/watch?v=OGut2iZW0JU&index=13&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

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

[Summary for Chapter 4](https://www.youtube.com/watch?v=enRrmLVzf4k&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV&index=14)

## Chapter 5: Type-level functions and typeclasses

[Slides (PDF)](https://github.com/winitzki/talks/blob/master/ftt-fp/05-type-classes.pdf)

[Code examples](https://github.com/winitzki/scala-examples/tree/master/chapter05/src)

[YouTube recording: slides + audio](https://www.youtube.com/watch?v=QhqsBgJ8lm8&index=15&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

Contents in brief:

- Total and partial functions at value level and at type level
- GADTs as partial type-to-type functions
- Using type evidence values to define partial type-to-value functions (PTVFs)
- typeclasses understood as PTVFs
- Using Scala's implicit value mechanism to define typeclasses
- Examples of typeclasses: `Semigroup`, `Monoid`, `Functor`
- Higher-order type functions; kinds as a "type system for types"
- Using Scala's "implicit method" syntax with typeclasses
- Using the `cats` library to define typeclass instances
- Using the `scalacheck` library to verify typeclass laws
- Worked examples and exercises

[Summary for Chapter 5](https://www.youtube.com/watch?v=Nyc1A_8fC1M&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV&index=16)

## Chapter 6: Computations in a functor context I. Filterable functors, their laws and structure. Part 1: Examples. Working with filterable functors

[Slides (PDF)](https://github.com/winitzki/talks/blob/master/ftt-fp/06-filterable-functors.pdf) (Part 1 covers slides 1 to 8.)

[Code examples](https://github.com/winitzki/scala-examples/tree/master/chapter06/src)

[YouTube recording: slides + audio](https://www.youtube.com/watch?v=20PYTn_aUqE&index=17&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

Contents in brief:

- "Functor block" (Scala's `for`/`yield` block syntax) and filterable functors
- Examples of polynomial filterable functors
- Intuitions behind the notion of "filtering" the data in a container
- Deriving the filterable functor laws from the intuitions
- Examples of functors that are not filterable, and reasons why
- Defining the `Filterable` typeclass and checking the laws with `scalacheck`
- Example of a filterable contrafunctor
- Worked examples and exercises

## Chapter 6: Computations in a functor context I. Filterable functors, their laws and structure. Part 2: Filterable functors in depth

[Slides (PDF)](https://github.com/winitzki/talks/blob/master/ftt-fp/06-filterable-functors.pdf) (Part 2 covers slides 9 to end.)

[Code examples](https://github.com/winitzki/scala-examples/tree/master/chapter06/src)

[YouTube recording: slides + audio](https://www.youtube.com/watch?v=GO4qq5_v1o0&index=18&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

Contents in brief:

- Equivalent definition of `Filterable` typeclass via `deflate` or `mapOption` instead of `withFilter`
- How to simplify the laws of filterable functors by using a Kleisli category
- Detailed derivations of laws for `mapOption`
- Intuitions behind natural transformations and naturality laws
- What category theory does for us, and what it does not do
- Constructions of filterable functors from other functors
- Intuitions behind filterable contrafunctors vs. filterable functors
- Fiilterable contrafunctors: their laws and structure (in brief)
- Worked examples and exercises

[Summary for Chapter 6, parts 1 and 2](https://www.youtube.com/watch?v=jateYf0rYZs&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV&index=19)

## Chapter 7: Computations in a functor context II. Monads and semimonads. Part 1: Intuitions, examples, use cases

[Slides (PDF)](https://github.com/winitzki/talks/blob/master/ftt-fp/07-monads-part1.pdf)

[Code examples](https://github.com/winitzki/scala-examples/tree/master/chapter07/src)

[YouTube recording: slides + audio](https://www.youtube.com/watch?v=3hzb0frNI48&index=20&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

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

[Summary for Chapter 7, part 1](https://www.youtube.com/watch?v=HW0Y513yaVM&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV&index=21&)

There was an error in the presentation: The power-of-2 tree _can_ be represented as a recursive type constructor, contrary to what I said in the video.
(But it is not naturally monadic in the way other tree-like monads are.) Download the latest slides for the corrected text.

## Chapter 7: Computations in a functor context II. Monads and semimonads. Part 2: Laws and structure of monads

[Slides (PDF)](https://github.com/winitzki/talks/blob/master/ftt-fp/07-monads-part2.pdf)

[Code examples](https://github.com/winitzki/scala-examples/tree/master/chapter07/src)

[YouTube recording: slides + audio](https://www.youtube.com/watch?v=p0fH_adTCnQ&index=22&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

The recording was too long for YouTube to produce subtitles. For convenience, I split the recording in two parts, each part has subtitles.

- [YouTube recording, slides + audio: Part 1 of 2](https://www.youtube.com/watch?v=u_XH7XkvFWM&index=23&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)
- [YouTube recording, slides + audio: Part 2 of 2](https://www.youtube.com/watch?v=rKQqdAF9ecA&index=24&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)


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

[Summary for Chapter 7, part 2](https://www.youtube.com/watch?v=kfggeipFg3g&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV&index=25)

## Chapter 8: Applicative functors and profunctors. Part 1: Practical examples

[Slides (PDF)](https://github.com/winitzki/talks/blob/master/ftt-fp/08-applicatives-part1.pdf)

[Code examples](https://github.com/winitzki/scala-examples/tree/master/chapter08/src)

[YouTube recording: slides + audio](https://www.youtube.com/watch?v=NVlFZYxgXDw&index=26&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

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

[YouTube recording: live coding session](https://www.youtube.com/watch?v=oVxCJ3h_Wqs&index=27&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

[Code examples](https://github.com/winitzki/scala-examples/blob/master/chapter08/src/test/scala/example/FoldsPresentation.scala)

The main topic is to illustrate how several `fold` operations can be combined automatically into a single traversal. In Chapter 8, part 1, the central pieces of code were implemented automatically using the `curryhoward` library. This live coding session shows the implementation and explains how it works in more detail.

- Defining a `fold` operation as a data structure and running it afterwards
- Combining several `fold` operations into one
- Implementing the applicative `zip` operation is possible on `fold`s despite `fold` not being a functor
- Adding a final transformation to a `fold`, to make it into a functor
- Implementing a DSL for `fold`s so that running average and standard deviation can be expressed concisely
- Illustrating the difference between applicative and monadic combinators for `fold`s

[Summary for Chapter 8, part 1](https://www.youtube.com/watch?v=YYi1beb4yiw&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV&index=28)

## Chapter 8: Applicative functors and profunctors. Part 2: Laws and structure

[Slides (PDF)](https://github.com/winitzki/talks/blob/master/ftt-fp/08-applicatives-part2.pdf)

[Code examples](https://github.com/winitzki/scala-examples/tree/master/chapter08/src)

The video for part 2 is very long and was recorded in 3 portions.

[YouTube recording: slides + audio, portion 1 of 3](https://www.youtube.com/watch?v=xBDkBriX7Uk&index=29&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

Portion 1 of 3 covers slides 1 to 15.

Contents in brief:

- How to generalize `map2`, `map3`, `map4` to `mapN` in a systematic way
- Motivation behind introducing the `ap` and `zip` methods for applicative functors
- Computational equivalence of `map2`, `ap`, and `zip`
- Motivation for the applicative laws: rewrite the monad laws in terms of `map2`
- Deriving the laws for `zip` to uncover the monoidal structure of the laws
- Defining `pure` through "wrapped unit"
- Recovering the 3rd naturality law for `map2`
- Deriving the laws for the applicative category
- Deriving the laws for `ap` as functor "lifting" laws from category laws
- Overview of applicative functor constructions

[YouTube recording: slides + audio, portion 2 of 3](https://www.youtube.com/watch?v=sEaT0vbTnx8&index=30&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

Portion 2 of 3 covers slides 15 to 17.

Contents in brief:

- Implementing and checking the laws for applicative functor constructions
- Examples of applicative functors that disagree with their monad instances
- Examples of non-applicative functors
- Monoid constructions: why all non-parameterized types are monoids
- Why all polynomial functors with monoid coefficients are applicative
- Definition and laws of applicative contrafunctors
- How applicative contrafunctors are different from applicative functors

[YouTube recording: slides + audio, portion 3 of 3](https://www.youtube.com/watch?v=G5Y7sqydEXo&index=31&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

Portion 3 of 3 covers slides 17 to 22.

Contents in brief:

- Implementing and checking the laws for applicative contrafunctor constructions
- Why all exponential-polynomial contrafunctors with monoid coefficients are applicative
- Definition and properties of profunctors
- Why all exponential-polynomial type constructors are profunctors
- Example of a non-profunctor type constructor: a partial type function
- Definition and laws of applicative profunctors
- Constructions of applicative profunctors; verifying the laws
- Commutative applicative functors, their interpretation, and examples
- A unified category theory-based picture of "standard" functor classes (functor, contrafunctor, filterable, monad, applicative)
- How to use this picture to find laws and to discover new typeclasses, such as the comonads
- Exercises

[Summary for Chapter 8, part 2](https://www.youtube.com/watch?v=9fjJAc4wOTQ&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV&index=32)

## CHapter 9: Traversable functors

[Slides (PDF)](https://github.com/winitzki/talks/blob/master/ftt-fp/10-free-constructions.pdf)

[Code examples](https://github.com/winitzki/scala-examples/tree/master/chapter10/src)

[YouTube recording: slides + audio](https://www.youtube.com/watch?v=OnaHcVBbCGQ&index=33&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

Contents in brief:

- Motivation for the `traverse` operation
- Deriving the `sequence` operation to simplify `traverse`
- How to implement `sequence` for any polynomial functor
- Examples of non-traversable functors: infinite list, and non-polynomial functors
- Motivation for laws of `traverse` from category theory
- Deriving the laws for `sequence`
- Constructions for traversable functors and bitraversable bifunctors, with proofs of laws
- Why infinite lists fail to satisfy traversable laws
- Deriving `foldMap` by specializing to a constant applicative functor
- Reasons to introduce the `Foldable` typeclass
- Implementing `foldLeft` via `foldMap`
- Traversable contrafunctors and profunctors exist, but are not useful
- Examples of using traversable and foldable: decorating trees
- Implementing `scanLeft` as a traversal with respect to a `State` monad
- Why breadth-first tree traversal or depth level computation cannot be represented via a traversal with a `State` monad
- Naturality with respect to an applicative functor
- Exercises

[Summary for Chapter 9](https://www.youtube.com/watch?v=unGUTDXymMI&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV&index=34)

## Chapter 10: Free type constructions

[Slides (PDF)](https://github.com/winitzki/talks/blob/master/ftt-fp/10-free-constructions.pdf)

[Code examples](https://github.com/winitzki/scala-examples/tree/master/chapter10/src)

The video for chapter 10 is very long and was recorded in 4 parts.

### Part 1 of 4

[YouTube recording: slides + audio, part 1 of 4](https://www.youtube.com/watch?v=32Rs0xCHiqc&index=35&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

Part 1 of 4 covers slides 1 to 15.

Contents in brief:

- The interpreter pattern as translation from program operations in a domain-specific language (DSL) into data structures
- Using case classes to implement a DSL program as an unevaluated expression tree
- Why using type parameters makes a DSL type-safe
- When is it necessary for a DSL to have monadic properties?
- Free monad obtained as a refactoring a DSL to separate custom code from common (application-independent) code
- Interpreting ("running") the same DSL program into a different type constructor, to provide error handling
- Proof that the monad laws hold after running the DSL program (but not necessarily before)
- Free constructions in mathematics: what it means to have a "free product" or a "free semigroup"
- Tree encoding vs. reduced encoding of a free construction
- Examples: free semigroup and free monoid; proofs of the laws
- Some properties and laws of the free constructions

### Part 2 of 4

[YouTube recording: slides + audio, part 2 of 4](https://www.youtube.com/watch?v=zNx-DORLfNY&index=36&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

Part 2 of 4 covers slides 16 to 19.

Contents in brief:

- Motivation for Church encoding
- How to use the Church encoding for disjunction types
- Church encoding of a free semigroup as a refactoring of the "interpreter" method `run()`
- Properties of the universally quantified types
- Why the Church encoding `∀X.(A ⇒ X) ⇒ X` is equivalent to the underlying type, `A`
- Tree encoding of the free functor
- Why a "hidden" type parameter in a disjunction translates into an existential type quantifier

### Part 3 of 4

[YouTube recording: slides + audio, part 3 of 4](https://www.youtube.com/watch?v=m8oNzlbsAjI&index=37&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

Part 3 of 4 covers slides 20 to 26.

Contents in brief:

- Properties of existential types; why `∃Z.Z × (Z ⇒ A)` is observationally equivalent to `A`, and why do we need "observational equivalence" of these values
- Free functor in tree encoding
- Free functor: Derivation of the reduced encoding from tree encoding
- Preparation for Church encoding of a free functor
- Church encoding of types and type constructors, in depth
- How Church encoding makes recursive types apparently non-recursive
- What needs to be done for Church encoding of a parameterized type
- Examples: Church encoding of `List[Int]`, `Option[A]`, and `List[A]`
- How the Church encoding of typeclasses such as Semigroup gives rise to the notion of "inductive typeclass" 
- A few general formulas for free typeclass instances in Church encoding
- What properties we expect from free type constructions
- Recipes for encoding arbitrary inductive typeclasses
- Why the product type and the function type are compatible with inductive typeclasses (e.g. product of two monads is a monad), but disjunction type is not (e.g. disjunction of two monads is not a monad)
- Examples of typeclasses that do not have tree-encoded free instances: non-inductive typeclasses (e.g. traversables)
- The difference between inductive and co-inductive typeclasses
- Stack-safe implementations of a free functor in tree and reduced encodings
- Why the standard Scala library method `andThen` is not stack-safe, and how to fix that

### Part 4 of 4

[YouTube recording: slides + audio, part 4 of 4](https://www.youtube.com/watch?v=BXBv3wOHi1Q&index=38&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

Part 4 of 4 covers slides 27 to 35.

Contents in brief:

- Free functor implemented as the Church encoding of the tree encoding is not stack safe
- Free functor implemented as the Church encoding of the reduced encoding is stack safe, but slower
- Further examples of free type constructions: free contrafunctor, free pointed functor, free monad, free applicative functor
- "Final tagless" in plain English (as Church encoding of a free monad)
- How to simplify a reduced encoding when the generating type constructor is already a functor, in all the above cases
- Proofs of the laws for the free type constructions, in the tree encoding
- The identity law, the naturality law, the universal property, and the functor property
- Definition of a typeclass-preserving map
- Why the disjunction of generating types yields the solution for a free typeclass instance generated by several types
- Why the disjunction of typeclass method functors yields the solution for a free typeclass instance when combining typeclasses
- The universal formula for Church encoding of a free typeclass instance for a combination of any number of typeclasses and any number of generating types at once
- Why functor composition is not a good solution for combining typeclass instances
- Example: combined free applicative/free monad, interpreted into the Future monad
- How the interpreter preserves parallelism when running the applicative `ap` or `zip` methods, while implementing sequential composition when running the `flatMap` method
- Exercises

### Summary

[Summary for Chapter 10](https://www.youtube.com/watch?v=b7SnVTavhUY&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV&index=39)

## Chapter 11: Computations in a functor context III. Monad transformers

[Slides (PDF)](https://github.com/winitzki/talks/blob/master/ftt-fp/11-monad-transformers.pdf)

[Code examples](https://github.com/winitzki/scala-examples/tree/master/chapter11/src)

### Part 1 of 4

[YouTube recording: slides + audio, part 1 of 4](https://www.youtube.com/watch?v=OiIddxiywTQ&index=40&list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)

Part 1 of 4 covers slides 1 to 11.

Contents in brief:

- Combining Future and Option as an example of combining monadic effects "by hand" (without transformers)
- Deriving the desired laws for lifting monads into a combined monad
- Difficulties in combining monads in general: what does and what does not work
- Examples of monads that compose and that do not compose with other monads
- Simplifying the two identity laws of a monad into a single identity law for "lifting"
- Deriving the composition law for "lifting" in terms of `flatten`, `flatMap`, and  in terms of the Kleisli composition
- Definition of "monadic morphism" and a proof that monadic morphisms are always natural transformations
- Monad transformers as a way of reducing the programmer's work as opposed to combining monads by hand
- What is a "monad transformer stack" and how it is different from a stack of nested type constructors
- Formal requirements for a monad transformer: it must have two "liftings" and two "runners"
- First examples: the monad constructions that lead to monad transformers (EitherT, ReaderT, WriterT)
- The "zoology" of monad transformers: to each monad its own transformer
- The list of all known monad transformer constructions: "composed-inside", "composed-outside", "recursive", "product", "contrafunctor-choice", "free pointed", and "irregular" transformers (StateT,  ContT, SelectorT, CodensityT)
- Why the continuation monad (as well as Codensity and Selector) do not actually have a full monad transformer (they do not have one of the "liftings" and they do not have any "runners")


Material possibly to be covered in the remaining parts of Chapter 11:

- mtl-style programming, extensible effects ("types à la carte") - problems and solutions
- alternatives to monad transformers: free monads, recursive combination of free pointed monads, "effect systems" 

## Chapter 12: Recursive type and value constructions

Material possibly to be covered:

- recursive types, row polymorphism / column polymorphism
- type-level and functor-level fixpoints; `matryoshka` library, recursion schemes; when is a recursive type well-defined, lazy / eager evaluation
- various solutions for the "expression problem"
- interpretation of OO programming from the perspective of AFTT
- trampolines in the standard Scala library; monadic tail recursion and stack safety

# Roadmap

0. Cut the scope for the book
1. Finish all videos for that scope
2. Finish writing the book
3. Gather the leftover material for a sequel book devoted to "pragmatics"

The leftover material may include:

- type-level constructions, type-level programming à la `shapeless`, basic usage of dependent types
- design patterns of FP that replace OO design patterns
- functional reactive programming, temporal logic, and UIs
- an example of a full-stack application implemented in Scala with FP patterns
- the following list of functional programming concepts needs to be revisited to select concepts that appear to be both well understood and useful in practice:
    - catamorphisms and other "something-morphisms" (?)
    - comonads and co-applicative functors (?)
    - cofree comonads, cofree functors etc. (?)
    - coroutines, continuations library and "shift/reset programming" (?)
    - zippers / type derivatives (?)
    - lenses / prisms and other "optics", their derivation using profunctor Yoneda (after Milewski)
    - arrows and their relationship to functions (?)
    - Kan extensions, "codensity", other second-order tricks (?)
