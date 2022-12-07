# ------------------------------------------------------------------------------
# finite element bases
# ------------------------------------------------------------------------------

"""
```julia
converttensorbasis(ceedbasis)
```

Tensor product basis

# Arguments:

  - `ceedbasis`:  LibCEED.jl tensor product Basis object

# Returns:

  - LFAToolkit.jl tensor product basis object

# Example:

```jldoctest
using LibCEED, LFAToolkit

# libCEED objects
ceed = LibCEED.Ceed("/cpu/self")
ceedbasis = LibCEED.create_tensor_h1_lagrange_basis(ceed, 2, 3, 4, 5, LibCEED.GAUSS)

# convert
lfabasis = converttensorbasis(ceedbasis)
println(lfabasis)

# output

tensor product basis:
    numbernodes1d: 4
    numberquadraturepoints1d: 5
    numbercomponents: 3
    dimension: 2

```
"""
function converttensorbasis(ceedbasis::CeedBasis)
    LFATensorBasis(
        Int(getnumnodes1d(ceedbasis)),
        Int(getnumqpts1d(ceedbasis)),
        Int(getnumcomponents(ceedbasis)),
        Int(getdimension(ceedbasis)),
        LinRange(-1, 1, Int(getnumnodes1d(ceedbasis))),
        # note: these values are copies of the internal libCEED data
        getqref(ceedbasis)[1:Int(getnumqpts1d(ceedbasis))],
        getqweights(ceedbasis)[1:Int(getnumqpts1d(ceedbasis))],
        getinterp1d(ceedbasis),
        getgrad1d(ceedbasis);
        numberelements1d = 1,
    )
end

# ------------------------------------------------------------------------------