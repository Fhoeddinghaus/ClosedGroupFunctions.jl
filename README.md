[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://fhoeddinghaus.github.io/ClosedGroupFunctions.jl)

# ClosedGroupFunctions

This Julia Package provides basic functions to handle **finite** mathematical groups that are defined by multiplication of a given set of generators.

## What can this package do?
1. Generate all elements of a **finite** group (under closure with multiplication)
2. Labelling
   1. Label the generating elements
   2. Generate and label the elements of the group
      1. in a fast way (first occuring representation)
      2. in a slower way (shortest representation)
3. Calculate the conjugacy classes using a given *inverse* function.
4. Investigate the (conjugacy) classes - or some other list of labels that describe group elements in a given group - by applying functions (e.g. invariants)
5. Storage: easy storing and loading a given object (e.g. group, labeled group, conjugacy classes, ...) using *(de)serialize*.
6. Helper functions
   1. Simple element calculation by giving any expression consisting of the labeled generators


## Installation
    ] add git@github.com:Fhoeddinghaus/ClosedGroupFunctions.jl.git

or
 
    ] add https://github.com/Fhoeddinghaus/ClosedGroupFunctions.jl.git

## Usage
See the [Documentation](https://fhoeddinghaus.github.io/ClosedGroupFunctions.jl/) for details.


___
###### Remark
 This package was originally created as a part of the bachelor thesis (2021/22) by Felix Höddinghaus (Fhoeddinghaus).